# Scan every case content field for term mentions and populate term_cases.
# Run: bin/rails runner script/link_terms_to_cases.rb

# Keyword → synonyms. Matching is case-insensitive substring on any content field.
# Keys must match Term#term exactly (or use :match_by_id for ambiguous names).
TERM_SYNONYMS = {
  "BDUI (Backend-Driven UI)"     => ["bdui", "backend-driven ui", "backend driven ui", "бдюи", "бэкенд-драйвен"],
  "Монорепозиторий"              => ["монорепо", "monorepo"],
  "Foundations"                  => ["foundations", "фаундейшн"],
  "Мод токенов (Mode)"           => ["мод токен", "моды токен", "mode "],
  "Пресет"                       => ["пресет"],
  "Дизайн-токен"                 => ["дизайн-токен", "design token", "design-token"],
  "Паттерн"                      => ["паттерн ", "pattern", "x-pattern"],
  "Базовая палитра (raw-токены)" => ["кор-палитр", "raw-токен", "core palette", "базовая палитр"],
  "Состояния компонента"         => ["состояния компонент", "состояний компонент"],
  "Мультибренд"                  => ["мультибренд", "мультибрендов", "multibrand", "мульти-бренд"],
  "Компонентные токены"          => ["компонентн", "component token"],
  "Семантический токен"          => ["семантическ", "semantic token", "семантическая палитр"],
  "Figma-библиотека"             => ["figma-библиотек", "figma библиотек", "библиотек фигм"],
  "Storybook"                    => ["storybook"],
  "Token Studio"                 => ["token studio", "tokens studio"],
  "Variables (Figma)"            => ["variables", "variables (figma)", "variables figma"],
  "Мастер-компонент"             => ["мастер-компонент", "мастер компонент", "master component"],
  "Инстанс (instance)"           => ["инстанс", "instance"],
  "Open-source ДС"               => ["open source", "opensource", "опенсорс", "публичная ds", "публичность"],
  "Changelog"                    => ["changelog", "чейнджлог"],
  "Definition of Done (DoD)"     => ["definition of done", "dod"],
  "Governance (управление ДС)"   => ["governance"],
  "Детач (detach)"               => ["детач", "detach"],
  "Ревью (дизайн-ревью)"         => ["ревью", "review"],
  "Миграция"                     => ["миграц"],
  "Версионирование"              => ["версион", "version", "релизн", "release"],
  "Контрибьюторская модель"      => ["контрибьютор", "contributor", "контриб"],
  "Time-to-market (TTM)"         => ["time-to-market", "time to market", "тайм-ту-маркет", "ttm"],
  "Метрика здоровья ДС"          => ["csi", "nps", "метрик здоровь", "% использован", "опрос удовлетвор"],
  "UI-кит"                       => ["ui-кит", "ui kit", "ui-kit"],
  "Компонент"                    => [],       # слишком общий — пропускаем
  "Дизайн-система"               => [],       # слишком общий — пропускаем
}

# Build an array of [term, regex] pairs for fast matching
def build_matchers
  TERM_SYNONYMS.flat_map do |term_name, synonyms|
    term = Term.find_by(term: term_name)
    next [] unless term
    next [] if synonyms.empty?

    pattern = synonyms.map { |s| Regexp.escape(s) }.join("|")
    [[term, Regexp.new(pattern, Regexp::IGNORECASE)]]
  end.to_h
end

CONTENT_FIELDS = %w[tldr context positioning composition processes documentation
                    design_code_sync quality scaling unique_practices conclusions
                    quotes intro focus_description card_title tags]

matchers = build_matchers
puts "Loaded #{matchers.size} term matchers"

TermCase.delete_all

total_links = 0
Case.find_each do |kase|
  haystack = CONTENT_FIELDS.map { |f| kase.send(f).to_s }.join("\n").downcase

  matchers.each do |term, re|
    if haystack.match?(re)
      TermCase.create!(term: term, case: kase)
      total_links += 1
    end
  end
end

puts "\nCreated #{total_links} links"
puts "\nPer term:"
Term.joins(:term_cases).group(:term).count.sort_by { |_, c| -c }.each do |term, count|
  puts "  #{count}× #{term}"
end

puts "\nPer case:"
Case.joins(:term_cases).group(:company).count.sort_by { |_, c| -c }.each do |company, count|
  puts "  #{count}× #{company}"
end
