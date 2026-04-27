module ApplicationHelper
  # Tags allowed in case content fields edited via Trix.
  RICH_TEXT_TAGS = %w[h1 h2 h3 p br strong em b i u s strike a ul ol li blockquote pre code].freeze
  RICH_TEXT_ATTRS = %w[href].freeze

  # Sanitize Trix-produced HTML for display on public pages and Active Admin show.
  def safe_admin_html(html)
    return "" if html.blank?
    sanitize(html.to_s, tags: RICH_TEXT_TAGS, attributes: RICH_TEXT_ATTRS)
  end

  # Render a case section body. With the Trix migration this is just a
  # sanitised pass-through; the wrapping <div class="case-body"> in the
  # view supplies the typography styles.
  def render_case_section_body(html)
    safe_admin_html(html)
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

end
