# Imports 8 expert-interview cases from docx files in ~/Downloads into the DB.
# Run via: bin/rails runner script/import_expert_cases.rb
#
# Mapping strategy:
#   - Parse docx → paragraphs (via zipfile + regex)
#   - Detect numbered sections "N) Title" (and "N.N Title" subsections)
#   - Parse "Паспорт кейса" block (Домен / Фокус / Контекст / Главная мысль)
#   - Route each section to a DB field by keyword match on the heading
#   - Collect every «...» line across the doc → quotes field as "Theme\n«quote»" pairs

require "json"

DOWNLOADS = File.expand_path("~/Downloads")
RAW_JSON  = "/tmp/cases_raw.json" # precomputed by the Python extractor

RAW_LINES = File.exist?(RAW_JSON) ? JSON.parse(File.read(RAW_JSON)) : {}

FILES = {
  "Ozon"    => { file: "Кейс_Ozon_дизайн-система.docx",    company: "Ozon",    ds_name: "Ozon Design System",            industry: "Ecom",    company_type: "Бигтех", accent: "#005BFF", card_title: "Дизайн-система как продуктовая инфраструктура" },
  "Skillaz" => { file: "Кейс_Skillaz_дизайн-система.docx", company: "Skillaz", ds_name: "Skillaz DS (на базе Magritte)",  industry: "HRtech",  company_type: "Продукт", accent: "#FF5C5C", card_title: "Дизайн-система как «интеграционный слой»" },
  "Avito"   => { file: "Кейс_Авито_дизайн-система.docx",   company: "Авито",   ds_name: "Avito Design System",           industry: "Ecom",    company_type: "Бигтех", accent: "#00AAFF", card_title: "Дизайн-система как «внутренний продукт»" },
  "Alpha"   => { file: "Кейс_Альфа_дизайн-система.docx",   company: "Альфа",   ds_name: "Дизайн-система Альфы",          industry: "Fintech", company_type: "Бигтех", accent: "#EF3124", card_title: "Дизайн-система как «единый продукт» в масштабе" },
  "MTS"     => { file: "Кейс_МТС_дизайн-система.docx",     company: "МТС Финтех", ds_name: "Astra",                      industry: "Fintech", company_type: "Бигтех", accent: "#E30611", card_title: "«Astra» как надстройка над экосистемой" },
  "OTP"     => { file: "Кейс_ОТП_дизайн-система.docx",     company: "ОТП Банк", ds_name: "Дизайн-система ОТП",           industry: "Fintech", company_type: "Бигтех", accent: "#76B82A", card_title: "Как собрать дизайн-систему «снизу вверх»" },
  "Sber"    => { file: "Кейс_Сбер_дизайн-система.docx",    company: "Сбер",    ds_name: "Дизайн-система канала (B2E)",   industry: "Fintech", company_type: "Бигтех", accent: "#21A038", card_title: "Дизайн-система канала как инфраструктура" },
  "Studio"  => { file: "Кейс_Сережа_студия_дизайн-система.docx", company: "Студия (Сергей)", ds_name: "Обзор практики", industry: "Ecom",    company_type: "Студия", accent: "#A0E557", card_title: "Студийная перспектива: правила и договорённости" },
}

# Keyword → DB field. Evaluated in order, first match wins.
FIELD_RULES = [
  [/контекст/i,                                                      :context],
  [/уникальн|фишк/i,                                                 :unique_practices],
  [/переня|что стоит|инсайт|итог|выводы/i,                           :conclusions],
  [/документац|портал/i,                                             :documentation],
  [/синхрон|автоматизац|backend|bdui|sdui|single source|источник правды|выгрузк|код/i, :design_code_sync],
  [/качеств|ревью|риск|ошибк|тупик|контрол|sla|рейтинг|аналитик/i,    :quality],
  [/масштаб|эволюц|границ|локализац|внедрен|рост/i,                  :scaling],
  [/процесс|коммуникац|ритм|вовлеч|запрос|приоритизац|релиз|обновлен|ai|ии|будущ|демо|миграц/i, :processes],
  [/токен|архитектур|устройств|состав|команд|роли|файл|библиотек|темы|компонент|foundations|старт/i, :composition],
  [/цел|принцип|позиционир/i,                                        :positioning],
]

def docx_lines(filename)
  lines = RAW_LINES[filename]
  abort "No raw lines for #{filename} — rerun the Python extractor" unless lines
  lines
end

SECTION_RE   = /\A\s*(\d+)\)\s*(.+?)\s*\z/
SUBSECT_RE   = /\A\s*(\d+\.\d+)\s+(.+?)\s*\z/
PASSPORT_KEYS = %w[Домен Фокус Контекст Главная]

def parse(lines)
  result = { title: nil, passport: {}, sections: [] }
  state = :preamble
  current = nil

  lines.each do |raw|
    line = raw.to_s.strip
    next if line.empty?

    # Page 1 preamble
    if result[:title].nil? && line.start_with?("Кейс:")
      result[:title] = line.sub(/\AКейс:\s*/, "")
      next
    end

    if line == "Паспорт кейса"
      state = :passport
      next
    end

    if state == :passport && (m = line.match(/\A(Домен|Фокус|Контекст|Главная мысль)\s*:\s*(.+)/))
      result[:passport][m[1]] = m[2].strip
      next
    end

    if (m = line.match(SECTION_RE))
      current = { number: m[1], title: m[2], body: [] }
      result[:sections] << current
      state = :section
      next
    end

    if (m = line.match(SUBSECT_RE)) && current
      current[:body] << "" unless current[:body].last.to_s.empty?
      current[:body] << "**#{m[2]}**"
      next
    end

    if state == :section && current
      current[:body] << line
    end
    # ignore pre-section noise (Формат:, Источник:)
  end

  result
end

def pick_field(title)
  FIELD_RULES.each { |re, f| return f if title =~ re }
  :composition
end

def section_short_theme(title)
  # "Принципы: удобство, прозрачность" → "Принципы"
  title.split(/[:—]/).first.strip
end

def group_body_paragraphs(body_lines)
  # Each non-empty line in docx === one paragraph. No further grouping.
  body_lines.reject { |l| l.to_s.strip.empty? }.map(&:strip)
end

def looks_like_quote?(text)
  text.include?("«") && text.include?("»")
end

def build_fields(parsed)
  field_bodies = Hash.new { |h, k| h[k] = [] }
  all_quotes   = []

  parsed[:sections].each do |sec|
    field = pick_field(sec[:title])
    theme = section_short_theme(sec[:title])

    paragraphs = group_body_paragraphs(sec[:body])
    text_paras = []
    paragraphs.each do |p|
      if looks_like_quote?(p) && p.strip.start_with?("«")
        # Standalone pull-quote paragraph → goes to quotes AND may stay inline
        all_quotes << { theme: theme, quote: p.strip }
        # keep inline too — feels natural in the text
        text_paras << p.strip
      else
        text_paras << p.strip
      end
    end

    title_line = "### #{sec[:number]}. #{sec[:title]}"
    block = [title_line, *text_paras].join("\n\n")
    field_bodies[field] << block
  end

  result = {}
  field_bodies.each { |f, arr| result[f] = arr.join("\n\n").strip }

  # quotes field: Theme\n«quote»
  if all_quotes.any?
    seen = {}
    quote_blocks = all_quotes.uniq { |h| h[:quote] }.map do |h|
      theme = h[:theme]
      seen[theme] ||= 0
      seen[theme] += 1
      label = seen[theme] > 1 ? "#{theme} (#{seen[theme]})" : theme
      "#{label}\n#{h[:quote]}"
    end
    result[:quotes] = quote_blocks.join("\n\n")
  end

  result
end

def tldr_from_passport(p)
  parts = []
  parts << p["Главная мысль"] if p["Главная мысль"]
  parts << "Фокус: #{p["Фокус"]}" if p["Фокус"]
  parts << "Контекст: #{p["Контекст"]}" if p["Контекст"]
  parts.join("\n\n")
end

def positioning_text(p, extra)
  base = []
  base << p["Главная мысль"] if p["Главная мысль"]
  base << extra if extra.present?
  base.compact.join("\n\n")
end

# ---- Run ----

FILES.each do |key, meta|
  puts "Importing #{key} (#{meta[:company]})…"
  lines  = docx_lines(meta[:file])
  parsed = parse(lines)
  fields = build_fields(parsed)

  # Assemble positioning with passport "главная мысль"
  existing_pos = fields[:positioning].to_s
  fields[:positioning] = positioning_text(parsed[:passport], existing_pos)
  fields[:tldr] = tldr_from_passport(parsed[:passport])

  # Focus_description & intro from passport
  focus_text = parsed[:passport]["Фокус"].to_s.split(/[,;]/).first(4).join(", ").strip
  focus_text = focus_text.empty? ? nil : focus_text

  intro_text = parsed[:passport]["Главная мысль"] || parsed[:passport]["Контекст"]

  tags = parsed[:passport]["Фокус"]
    .to_s
    .split(/[,;()]/)
    .map(&:strip).reject(&:empty?)
    .first(5)
    .map { |t| t.sub(/\s+—.*\z/, "").capitalize }
    .uniq
    .join(", ")

  kase = Case.find_or_initialize_by(company: meta[:company], ds_name: meta[:ds_name])
  kase.assign_attributes(
    card_title:         parsed[:title] || meta[:card_title],
    accent_color:       meta[:accent],
    industry:           meta[:industry],
    company_type:       meta[:company_type],
    case_type:          "Экспертное интервью",
    case_format:        "Экспертное интервью",
    materials:          "",
    tags:               tags,
    focus_description:  parsed[:passport]["Фокус"],
    speaker_role:       nil,
    artifacts:          nil,
    intro:              intro_text,
    tldr:               fields[:tldr],
    context:            fields[:context],
    positioning:        fields[:positioning],
    composition:        fields[:composition],
    processes:          fields[:processes],
    documentation:      fields[:documentation],
    design_code_sync:   fields[:design_code_sync],
    quality:            fields[:quality],
    scaling:            fields[:scaling],
    unique_practices:   fields[:unique_practices],
    conclusions:        fields[:conclusions],
    quotes:             fields[:quotes],
    published:          true,
  )
  kase.save!
  puts "  ✓ #{kase.company} — #{kase.ds_name} (##{kase.id})"
end

puts "Done."
