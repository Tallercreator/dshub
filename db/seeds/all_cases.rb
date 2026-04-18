cases_data = [
  {
    company: "Ozon",
    ds_name: "Ozon DS",
    tags: "Архитектура, Компоненты, Токены",
    industry: "Ecom",
    case_type: "Экспертное интервью",
    case_format: "Экспертное интервью",
    company_type: "Бигтех",
    accent_color: "#005BFF",
    tldr: "ДС нельзя доделать: про BDUI, стандарты и бесконечный продукт. DS в Ozon — инструмент скорости разработки и снижения костов, а не консистентности бренда. BDUI позволяет менять интерфейс без релиза. Все типовые вопросы закрыты документацией — вообще все.",
    published: true
  },
  {
    company: "Альфа-Банк",
    ds_name: "Альфа ДС",
    tags: "Архитектура, Токены",
    industry: "Fintech",
    case_type: "Экспертное интервью",
    case_format: "Экспертное интервью",
    company_type: "Бигтех",
    accent_color: "#EF3124",
    tldr: "ДС — это про людей: пресеты, мультибренд и 10 лет без перезапуска. DS выходит за пределы банка, используется продуктами других брендов. Механизм темизации с сохранением технической базы. Дашборд качества рассматривается на уровне бизнеса.",
    published: true
  },
  {
    company: "Авито",
    ds_name: "AKITA — Avito Design Team",
    tags: "Архитектура, Документация",
    industry: "Ecom",
    case_type: "Экспертное интервью",
    case_format: "Экспертное интервью",
    company_type: "Бигтех",
    accent_color: "#00AAFF",
    tldr: "Масштаб, BDUI и открытая база знаний. DS воспринимается как отдельный продукт с собственным брендом (AKITA). Потребности от ДС всегда больше возможностей, бэклог склонен только расширяться.",
    published: true
  },
  {
    company: "Сбер",
    ds_name: "BTO — Операционный центр",
    tags: "Архитектура, Документация",
    industry: "Fintech",
    case_type: "Экспертное интервью",
    case_format: "Экспертное интервью",
    company_type: "Бигтех",
    accent_color: "#21A038",
    tldr: "ДС как продукт для 130 команд: конструктор, UXcorom и AI-ревьюер. Система — не сами компоненты, а правила и ограничения, которые связывают их воедино. Три аудитории: дизайнеры, разработчики, бизнес/аналитики.",
    published: true
  },
  {
    company: "МТС Финтех",
    ds_name: "Astra",
    tags: "Токены, Компоненты",
    industry: "Fintech",
    case_type: "Экспертное интервью",
    case_format: "Экспертное интервью",
    company_type: "Бигтех",
    accent_color: "#FF0032",
    tldr: "Ценность DS для бизнеса доказана на встречах в Media Room: ускоряет разработку и снижает time-to-market. Переключение бренда в токенах — в один клик.",
    published: true
  },
  {
    company: "ОТП Банк",
    ds_name: "Lora",
    tags: "Токены, Компоненты",
    industry: "Fintech",
    case_type: "Экспертное интервью",
    case_format: "Экспертное интервью",
    company_type: "Бигтех",
    accent_color: "#6F9400",
    tldr: "Инициатива перфекциониста: один дизайнер не вывезет, нужна коммуникация дизайн + разработка. DS — не то, что один раз сделал и всё.",
    published: true
  },
  {
    company: "Skillaz",
    ds_name: "Skill Grid",
    tags: "Компоненты, Документация",
    industry: "Edtech",
    case_type: "Экспертное интервью",
    case_format: "Экспертное интервью",
    company_type: "Стартап",
    accent_color: "#6B4FBB",
    tldr: "DS — реально отдельный продукт. Много времени, постоянная поддержка. Объединение продуктов в единый интерфейс — базовый минимум. UX стоит на первом месте.",
    published: true
  },
  {
    company: "Студия и продукт",
    ds_name: "Eda Project · Glorex · Контур",
    tags: "Архитектура, Компоненты",
    industry: nil,
    case_type: "Экспертное интервью",
    case_format: "Экспертное интервью",
    company_type: "Студия",
    accent_color: "#333333",
    tldr: "Концептуальный взгляд: когда DS нужна, а когда нет. Чем проще — тем лучше. Один компонент — одна страница. Три примера ошибок сложности.",
    published: true
  },
  {
    company: "Яндекс",
    ds_name: "Gravity UI",
    tags: "Архитектура, Токены, Документация",
    industry: nil,
    case_type: "Открытый кейс",
    case_format: "Обзор",
    company_type: "Бигтех",
    accent_color: "#FFCC00",
    tldr: "Обзор публичной DS Яндекса. Полностью открытая: сайт + токены + правила + установка + changelog + Figma Community. 74+ репозитория на GitHub. Web (React), Desktop-first, B2B SaaS.",
    published: true
  },
  {
    company: "Kaspersky",
    ds_name: "Hexa UI",
    tags: "Архитектура, Компоненты, Документация",
    industry: nil,
    case_type: "Открытый кейс",
    case_format: "Обзор",
    company_type: "Бигтех",
    accent_color: "#00A88E",
    tldr: "Обзор DS Лаборатории Касперского. Полностью открытая: GitHub (Apache-2.0) + npm + Storybook + документация процессов. styled-components + antd под капотом.",
    published: true
  },
  {
    company: "Сбер",
    ds_name: "Nova",
    tags: "Компоненты, Токены",
    industry: "Fintech",
    case_type: "Открытый кейс",
    case_format: "Обзор",
    company_type: "Бигтех",
    accent_color: "#21A038",
    tldr: "Обзор DS СберБанк Онлайн. Только витрина — промо-сайт и иконки публично, документация и Figma закрыты. iOS, Android, адаптивный веб.",
    published: true
  },
  {
    company: "ВКонтакте",
    ds_name: "VKUI",
    tags: "Архитектура, Токены, Компоненты",
    industry: nil,
    case_type: "Открытый кейс",
    case_format: "Обзор",
    company_type: "Бигтех",
    accent_color: "#0077FF",
    tldr: "Обзор DS ВКонтакте. Полностью открытая: документация + GitHub + npm + Figma Community + токены в 6 форматах. 97M MAU. Web (React) + iOS + Android, Mobile-first.",
    published: true
  }
]

cases_data.each do |data|
  kase = Case.find_or_initialize_by(company: data[:company], ds_name: data[:ds_name])
  kase.assign_attributes(data)
  kase.save!
  puts "#{kase.new_record? ? 'Created' : 'Saved'}: ##{kase.id} #{kase.company} — #{kase.ds_name} (#{kase.case_format})"
end

puts "\nTotal cases: #{Case.count}"
