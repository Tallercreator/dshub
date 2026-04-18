module ApplicationHelper
  # Toggle a value in a multi-param list within the current query string.
  # Returns the URL that, when visited, flips the value on/off.
  def toggle_param_url(param_key, value, current_params:)
    other = current_params.except(param_key, :controller, :action).to_unsafe_h
    current = Array(current_params[param_key]).reject(&:blank?)
    new_values =
      if current.include?(value)
        current - [value]
      else
        current + [value]
      end
    url_for(other.merge(param_key => new_values))
  end

  # Extract source label from resource URL (e.g. habr.com → "Habr")
  SOURCE_LABELS = {
    "habr.com" => "Habr",
    "vc.ru" => "VC.ru",
    "youtube.com" => "YouTube",
    "youtu.be" => "YouTube",
    "github.com" => "GitHub",
    "figma.com" => "Figma",
    "medium.com" => "Medium",
  }.freeze

  def resource_source_label(url)
    return nil if url.blank?
    host = URI.parse(url).host.to_s.sub(/^www\./, "")
    SOURCE_LABELS.each { |domain, label| return label if host.include?(domain) }
    # Fallback: return capitalized domain without TLD
    host.split(".").first&.capitalize
  rescue URI::InvalidURIError
    nil
  end

  # Split a case section body: extracts the last paragraph if it's a pullquote (starts with «)
  # Returns [body_text, quote_text_or_nil]
  def split_section_quote(text)
    return [nil, nil] if text.blank?
    paragraphs = text.to_s.split(/\n\s*\n/).map(&:strip).reject(&:empty?)
    last = paragraphs.last.to_s
    if last.start_with?("«") && last.end_with?("»")
      [paragraphs[0..-2].join("\n\n"), last]
    else
      [text, nil]
    end
  end

  # Render a case section body as a "themed card":
  #   - numbered list    ("1. Title\nbody\n\n2. ...")        → card with "N. Title"
  #   - title-body pairs ("Theme\nbody\n\nTheme\nbody")      → card with just "Title"
  # Otherwise falls back to styled paragraphs with subheadings + inline quotes.
  def render_case_section_body(text, field: nil)
    return "".html_safe if text.blank?
    raw = text.to_s.strip

    items = parse_numbered_items(raw)
    numbered = items.any?
    items = parse_title_body_items(raw) if items.empty? && field == :quotes

    if items.size >= 2
      list_html = items.map do |item|
        title_prefix = numbered ? "#{ERB::Util.h(item[:number])}. " : ""
        body_html =
          if item[:body].present?
            "<p class=\"case-numbered-body\">#{ERB::Util.h(item[:body]).gsub(/\n/, '<br>')}</p>"
          else
            ""
          end
        <<~HTML
          <li class="case-numbered-item">
            <span class="case-numbered-title">#{title_prefix}#{ERB::Util.h(item[:title])}</span>
            #{body_html}
          </li>
        HTML
      end.join
      tag_name = numbered ? "ol" : "ul"
      %(<#{tag_name} class="case-numbered-card">#{list_html}</#{tag_name}>).html_safe
    else
      render_structured_body(raw)
    end
  end

  # Render mixed narrative content, recognising:
  #   - "### N. Title" or "### Title"  → styled subheading
  #   - "«...»"-only paragraph         → inline pullquote
  #   - "• ...", "- ..."               → bullet list
  #   - anything else                  → paragraph
  def render_structured_body(text)
    paragraphs = text.to_s.split(/\n\s*\n/).map(&:strip).reject(&:empty?)
    html = []
    bullet_buffer = []

    flush_bullets = lambda do
      next if bullet_buffer.empty?
      items = bullet_buffer.map { |b| "<li>#{ERB::Util.h(b)}</li>" }.join
      html << %(<ul class="case-bullets">#{items}</ul>)
      bullet_buffer.clear
    end

    paragraphs.each do |p|
      if (m = p.match(/\A###\s+(?:\d+(?:\.\d+)?\.\s*)?(.+)\z/))
        flush_bullets.call
        html << %(<h3 class="case-subheading">#{ERB::Util.h(m[1].strip)}</h3>)
      elsif p.start_with?("•") || p.start_with?("- ")
        bullet_buffer << p.sub(/\A[•\-]\s*/, "").strip
      elsif p.start_with?("«") && p.rstrip.end_with?("»") && !p.include?("\n")
        flush_bullets.call
        html << %(<p class="case-inline-quote">#{ERB::Util.h(p)}</p>)
      else
        flush_bullets.call
        safe = ERB::Util.h(p).gsub(/\n/, "<br>")
        html << "<p>#{safe}</p>"
      end
    end
    flush_bullets.call

    html.join.html_safe
  end

  # Parse "1. Title\nexplanation\n\n2. Title\n..." into [{number:, title:, body:}]
  def parse_numbered_items(text)
    blocks = text.split(/\n\s*\n/).map(&:strip).reject(&:empty?)
    return [] unless blocks.all? { |b| b =~ /\A(\d+)[.)]\s+/ }

    blocks.map do |block|
      m = block.match(/\A(\d+)[.)]\s+(.+?)(?:\n(.*))?\z/m)
      next unless m
      { number: m[1], title: m[2].strip, body: m[3].to_s.strip }
    end.compact
  end

  # Parse "Title line\nbody line(s)\n\nTitle line\n..." (no numbering) into [{title:, body:}]
  # Used for fields like quotes where each block is a theme + its quote.
  def parse_title_body_items(text)
    blocks = text.split(/\n\s*\n/).map(&:strip).reject(&:empty?)
    return [] if blocks.size < 2

    blocks.map do |block|
      title, *rest = block.split("\n", 2)
      { title: title.to_s.strip, body: rest.first.to_s.strip }
    end
  end

  # Titles shown on public case page per field
  CASE_SECTION_TITLES = {
    tldr: "Главное",
    context: "Контекст",
    positioning: "Позиционирование и цели",
    composition: "Состав системы",
    processes: "Процессы развития",
    documentation: "Документация",
    design_code_sync: "Синхронизация дизайна и кода",
    quality: "Контроль качества",
    scaling: "Масштабирование и внедрение",
    unique_practices: "Уникальные практики и «фишки» кейса",
    conclusions: "Выводы и принципы",
    quotes: "Избранные цитаты",
  }.freeze
end
