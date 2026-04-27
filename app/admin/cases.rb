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
      f.input :focus_description, as: :trix, label: "Фокус кейса (текст)", hint: "Одна-две строки свободным текстом для сайдбара."
      f.input :speaker_role, label: "Роль эксперта", input_html: { rows: 2 }, hint: "Например: «Никита — дизайнер дизайн-системы (в команде есть лиды по iOS и Android)»"
      f.input :artifacts, as: :trix, label: "Артефакты в кейсе", hint: "Например: «Figma-файлы (showcase + master), документация в Figma, dev sandbox»"
      f.input :intro, as: :trix, label: "Вводный абзац (над «Контекстом»)", hint: "Короткое вступление о дизайн-системе — появляется в сайдбаре под лейблами."
    end

    f.inputs "Рекомендованные ресурсы" do
      f.input :recommended_resources,
              as: :check_boxes,
              collection: Resource.order(:resource_type, :title).map { |r| ["[#{r.resource_type}] #{r.title}", r.id] },
              label: "Привязанные ресурсы",
              hint: "Отметьте ресурсы, которые дизайнер посоветовал в этом кейсе. Если ничего не выбрано — блок на странице не показывается."
    end

    f.inputs "Содержание" do
      f.input :tldr, as: :trix, label: "Главное"
      f.input :context, as: :trix, label: "Контекст"
      f.input :positioning, as: :trix, label: "Позиционирование"
      f.input :composition, as: :trix, label: "Состав"
      f.input :processes, as: :trix, label: "Процессы"
      f.input :documentation, as: :trix, label: "Документация"
      f.input :design_code_sync, as: :trix, label: "Синхронизация дизайна и кода"
      f.input :quality, as: :trix, label: "Качество"
      f.input :scaling, as: :trix, label: "Масштабирование"
      f.input :unique_practices, as: :trix, label: "Уникальные практики"
      f.input :conclusions, as: :trix, label: "Выводы"
      f.input :quotes, as: :trix, label: "Цитаты"
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
      row("Фокус кейса (текст)") { |k| safe_admin_html(k.focus_description) }
      row("Роль эксперта") { |k| simple_format(k.speaker_role.to_s) }
      row("Артефакты в кейсе") { |k| safe_admin_html(k.artifacts) }
      row("Вводный абзац") { |k| safe_admin_html(k.intro) }
      row("Главное") { |k| safe_admin_html(k.tldr) }
      row("Контекст") { |k| safe_admin_html(k.context) }
      row("Позиционирование") { |k| safe_admin_html(k.positioning) }
      row("Состав") { |k| safe_admin_html(k.composition) }
      row("Процессы") { |k| safe_admin_html(k.processes) }
      row("Документация") { |k| safe_admin_html(k.documentation) }
      row("Синхронизация дизайна и кода") { |k| safe_admin_html(k.design_code_sync) }
      row("Качество") { |k| safe_admin_html(k.quality) }
      row("Масштабирование") { |k| safe_admin_html(k.scaling) }
      row("Уникальные практики") { |k| safe_admin_html(k.unique_practices) }
      row("Выводы") { |k| safe_admin_html(k.conclusions) }
      row("Цитаты") { |k| safe_admin_html(k.quotes) }
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
