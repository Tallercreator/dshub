class ConvertCaseTextFieldsToHtml < ActiveRecord::Migration[8.0]
  # Convert legacy plain-text mini-markup in Case content fields into HTML
  # so the Trix editor can edit them WYSIWYG-style.
  def up
    Case.find_each do |kase|
      changes = {}
      Case::RICH_TEXT_FIELDS.each do |field|
        raw = kase.read_attribute(field).to_s
        next if raw.blank?
        next if html?(raw) # already converted
        changes[field] = CaseContentConverter.call(raw)
      end
      kase.update_columns(changes) if changes.any?
    end
  end

  def down
    # No-op: original plain-text format is not restored.
  end

  private

  # Heuristic: treat a value as HTML if it starts with a known block-level tag.
  def html?(str)
    str.lstrip.match?(/\A<(p|h[1-6]|ul|ol|blockquote|div)\b/i)
  end
end
