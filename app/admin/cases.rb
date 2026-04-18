ActiveAdmin.register Case do
  permit_params :company, :ds_name, :card_title, :tags, :accent_color, :cover_image, :hero_image,
                :industry, :case_type, :case_format, :company_type, :materials,
                :focus_description, :speaker_role, :artifacts, :intro,
                :tldr, :context, :positioning, :composition, :processes,
                :documentation, :design_code_sync, :quality, :scaling,
                :unique_practices, :conclusions, :quotes, :published,
                recommended_resource_ids: []

  menu label: "Кейсы", priority: 1

  index do
    selectable_column
    id_column
    column "Обложка" do |kase|
      if kase.cover_image.attached?
        image_tag url_for(kase.cover_image), style: "max-width: 80px; height: auto;"
      end
    end
    column "Компания", :company
    column "Дизайн-система", :ds_name
    column "Отрасль", :industry
    column "Тип кейса", :case_type
    column "Формат", :case_format
    column "Теги", :tags
    column "Опубликован", :published
    column "Создан", :created_at
    actions
  end

  filter :company, label: "Компания"
  filter :ds_name, label: "Дизайн-система"
  filter :industry,
         as: :select,
         collection: Case::INDUSTRIES,
         label: "Отрасль"
  filter :case_type,
         as: :select,
         collection: Case::CASE_TYPES,
         label: "Тип кейса"
  filter :company_type,
         as: :select,
         collection: Case::COMPANY_TYPES,
         label: "Тип компании"
  filter :tags, label: "Теги"
  filter :published, label: "Опубликован"
  filter :created_at, label: "Создан"

  form do |f|
    f.inputs "Основное" do
      f.input :company, label: "Компания"
      f.input :ds_name, label: "Название дизайн-системы"
      f.input :card_title, label: "Заголовок на карточке", hint: "Если пусто — берётся первая строка «Главного»"
      f.input :tags, label: "Теги (фокус кейса)", hint: "Через запятую. Используются как теги карточки и для фильтра «Фокус» (например: Архитектура, Токены, Документация, Компоненты)"
      f.input :accent_color, label: "Акцентный цвет", hint: "HEX, например #FF6600"
      f.input :cover_image,
              as: :file,
              label: "Обложка карточки",
              hint: (f.object.cover_image.attached? ? image_tag(url_for(f.object.cover_image), style: "max-width: 200px; height: auto;") : "Используется на главной и в списке кейсов. PNG, JPEG, WEBP, SVG, до 10 МБ")
      f.input :hero_image,
              as: :file,
              label: "Обложка страницы кейса",
              hint: (f.object.hero_image.attached? ? image_tag(url_for(f.object.hero_image), style: "max-width: 200px; height: auto;") : "Опционально. Если не загружена — берётся «Обложка карточки». PNG, JPEG, WEBP, SVG, до 10 МБ")
      f.input :published, label: "Опубликован"
    end

    f.inputs "Фильтры" do
      f.input :industry,
              as: :select,
              collection: Case::INDUSTRIES,
              include_blank: "— не выбрано —",
              label: "Отрасль"
      f.input :case_type,
              as: :select,
              collection: Case::CASE_TYPES,
              include_blank: "— не выбрано —",
              label: "Тип кейса"
      f.input :case_format,
              as: :select,
              collection: Case::CASE_FORMATS,
              include_blank: "— не выбрано —",
              label: "Формат"
      f.input :company_type,
              as: :select,
              collection: Case::COMPANY_TYPES,
              include_blank: "— не выбрано —",
              label: "Тип компании"
      f.input :materials, label: "Материалы в кейсе", hint: "Через запятую из: #{Case::MATERIALS.join(', ')}"
    end

    f.inputs "Сайдбар" do
      f.input :focus_description, label: "Фокус кейса (текст)", input_html: { rows: 3 }, hint: "Одна-две строки свободным текстом для сайдбара. Например: «организация дизайн-системы в мобильном продукте, ускорение delivery и снижение ошибок»"
      f.input :speaker_role, label: "Роль эксперта", input_html: { rows: 2 }, hint: "Например: «Никита — дизайнер дизайн-системы (в команде есть лиды по iOS и Android)»"
      f.input :artifacts, label: "Артефакты в кейсе", input_html: { rows: 3 }, hint: "Через запятую. Например: «Figma-файлы (showcase + master), документация в Figma, dev sandbox»"
      f.input :intro, label: "Вводный абзац (над «Контекстом»)", input_html: { rows: 4 }, hint: "Короткое вступление о дизайн-системе — появляется в сайдбаре под лейблами."
    end

    f.inputs "Рекомендованные ресурсы" do
      f.input :recommended_resources,
              as: :check_boxes,
              collection: Resource.order(:resource_type, :title).map { |r| ["[#{r.resource_type}] #{r.title}", r.id] },
              label: "Привязанные ресурсы",
              hint: "Отметьте ресурсы, которые дизайнер посоветовал в этом кейсе. Если ничего не выбрано — блок на странице не показывается."
    end

    f.inputs "Содержание" do
      f.input :tldr, label: "Главное", input_html: { rows: 6 }
      f.input :context, label: "Контекст", input_html: { rows: 6 }
      f.input :positioning, label: "Позиционирование", input_html: { rows: 6 }
      f.input :composition, label: "Состав", input_html: { rows: 6 }
      f.input :processes, label: "Процессы", input_html: { rows: 6 }
      f.input :documentation, label: "Документация", input_html: { rows: 6 }
      f.input :design_code_sync, label: "Синхронизация дизайна и кода", input_html: { rows: 6 }
      f.input :quality, label: "Качество", input_html: { rows: 6 }
      f.input :scaling, label: "Масштабирование", input_html: { rows: 6 }
      f.input :unique_practices, label: "Уникальные практики", input_html: { rows: 6 }
      f.input :conclusions, label: "Выводы", input_html: { rows: 6 }
      f.input :quotes, label: "Цитаты", input_html: { rows: 6 }
    end

    f.actions
  end

  show do
    attributes_table do
      row("Обложка карточки") do |kase|
        if kase.cover_image.attached?
          image_tag url_for(kase.cover_image), style: "max-width: 400px; height: auto;"
        end
      end
      row("Обложка страницы кейса") do |kase|
        if kase.hero_image.attached?
          image_tag url_for(kase.hero_image), style: "max-width: 400px; height: auto;"
        end
      end
      row("Компания") { |k| k.company }
      row("Дизайн-система") { |k| k.ds_name }
      row("Заголовок на карточке") { |k| k.card_title }
      row("Отрасль") { |k| k.industry }
      row("Тип кейса") { |k| k.case_type }
      row("Формат") { |k| k.case_format }
      row("Тип компании") { |k| k.company_type }
      row("Материалы") { |k| k.materials }
      row("Теги") { |k| k.tags }
      row("Акцентный цвет") { |k| k.accent_color }
      row("Опубликован") { |k| k.published }
      row("Фокус кейса (текст)") { |k| simple_format(k.focus_description.to_s) }
      row("Роль эксперта") { |k| simple_format(k.speaker_role.to_s) }
      row("Артефакты в кейсе") { |k| simple_format(k.artifacts.to_s) }
      row("Вводный абзац") { |k| simple_format(k.intro.to_s) }
      row("Главное") { |k| simple_format(k.tldr.to_s) }
      row("Контекст") { |k| simple_format(k.context.to_s) }
      row("Позиционирование") { |k| simple_format(k.positioning.to_s) }
      row("Состав") { |k| simple_format(k.composition.to_s) }
      row("Процессы") { |k| simple_format(k.processes.to_s) }
      row("Документация") { |k| simple_format(k.documentation.to_s) }
      row("Синхронизация дизайна и кода") { |k| simple_format(k.design_code_sync.to_s) }
      row("Качество") { |k| simple_format(k.quality.to_s) }
      row("Масштабирование") { |k| simple_format(k.scaling.to_s) }
      row("Уникальные практики") { |k| simple_format(k.unique_practices.to_s) }
      row("Выводы") { |k| simple_format(k.conclusions.to_s) }
      row("Цитаты") { |k| simple_format(k.quotes.to_s) }
      row("Создан") { |k| k.created_at }
      row("Рекомендованные ресурсы") do |k|
        if k.recommended_resources.any?
          safe_join(k.recommended_resources.map { |r| "[#{r.resource_type}] #{r.title}" }, tag.br)
        else
          "—"
        end
      end
      row("Обновлён") { |k| k.updated_at }
    end
  end
end
