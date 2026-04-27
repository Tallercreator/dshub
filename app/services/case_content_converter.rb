# Converts the legacy plain-text case content (with custom mini-markup)
# into HTML compatible with the Trix editor.
#
# Mini-markup recognised:
#   "### Title"          → <h1>Title</h1>
#   "1. Title\nbody…"    → <ol><li><strong>Title</strong><br>body…</li>…</ol>
#   "• item" / "- item"  → <ul><li>item</li>…</ul>
#   "«quote»" paragraph  → <blockquote>«quote»</blockquote>
#   anything else        → <p>…</p> (single \n becomes <br>)
class CaseContentConverter
  def self.call(text)
    new(text).to_html
  end

  def initialize(text)
    @text = text.to_s
  end

  def to_html
    return "" if @text.strip.empty?

    blocks = @text.strip.split(/\n\s*\n/).map(&:strip).reject(&:empty?)

    if numbered_blocks?(blocks)
      return numbered_list_html(blocks)
    end

    chunks = []
    bullet_buffer = []

    flush_bullets = -> {
      next if bullet_buffer.empty?
      items = bullet_buffer.map { |b| "<li>#{escape(b)}</li>" }.join
      chunks << "<ul>#{items}</ul>"
      bullet_buffer.clear
    }

    blocks.each do |block|
      if (m = block.match(/\A###\s+(?:\d+(?:\.\d+)?\.\s*)?(.+)\z/))
        flush_bullets.call
        chunks << "<h1>#{escape(m[1].strip)}</h1>"
      elsif block.start_with?("•") || block.start_with?("- ")
        bullet_buffer << block.sub(/\A[•\-]\s*/, "").strip
      elsif quote_block?(block)
        flush_bullets.call
        chunks << "<blockquote>#{escape(block)}</blockquote>"
      else
        flush_bullets.call
        chunks << "<p>#{escape(block).gsub(/\n/, '<br>')}</p>"
      end
    end
    flush_bullets.call

    chunks.join
  end

  private

  def numbered_blocks?(blocks)
    return false if blocks.size < 2
    blocks.all? { |b| b =~ /\A\d+[.)]\s+/ }
  end

  def numbered_list_html(blocks)
    items = blocks.map do |block|
      m = block.match(/\A\d+[.)]\s+(.+?)(?:\n(.*))?\z/m)
      next unless m
      title = escape(m[1].strip)
      body  = m[2].to_s.strip
      if body.empty?
        "<li><strong>#{title}</strong></li>"
      else
        "<li><strong>#{title}</strong><br>#{escape(body).gsub(/\n/, '<br>')}</li>"
      end
    end.compact.join
    "<ol>#{items}</ol>"
  end

  def quote_block?(block)
    block.start_with?("«") && block.rstrip.end_with?("»") && !block.include?("\n")
  end

  def escape(str)
    ERB::Util.h(str)
  end
end
