ActiveAdmin.register Term do
  permit_params :term, :definition, :purpose, :context, :category, :sources,
                :image, :published,
                examples: [],
                mentioned_in_case_ids: []

  menu label: "Глоссарий", priority: 2

  index do
    selectable_column
    id_column
    column "Изображение" do |t|
      if t.image.attached?
        image_tag url_for(t.image), style: "max-width: 80px; height: auto;"
      end
    end
    column "Термин", :term
    column "Категория", :category
    column "Источники", :sources
    column "Опубликован", :published
    column "Создан", :created_at
    actions
  end

  filter :term, label: "Термин"
  filter :category, as: :select, collection: Term::CATEGORIES, label: "Категория"
  filter :sources, label: "Источники"
  filter :published, label: "Опубликован"
  filter :created_at, label: "Создан"

  form do |f|
    f.inputs "Основное" do
      f.input :term, label: "Термин"
      f.input :category,
              as: :select,
              collection: Term::CATEGORIES,
              include_blank: "— не выбрано —",
              label: "Категория"
      f.input :published, label: "Опубликован"
    end

    f.inputs "Содержание" do
      f.input :definition, label: "Определение", input_html: { rows: 5 }
      f.input :purpose, label: "Для чего нужен", input_html: { rows: 4 }
      f.input :context, label: "Где используется", input_html: { rows: 4 }
      f.input :sources, label: "Упоминания в кейсе", hint: "Например: Dodo, Ozon, Альфа-Банк"
    end

    f.inputs "Упоминания в кейсах" do
      f.input :mentioned_in_cases,
              as: :check_boxes,
              collection: Case.order(:company).map { |c| ["#{c.company} — #{c.ds_name}", c.id] },
              label: "Привязанные кейсы",
              hint: "Автоматически заполняется скриптом script/link_terms_to_cases.rb. Можно править вручную."
    end

    f.inputs "Изображения" do
      f.input :image,
              as: :file,
              label: "Главное изображение",
              hint: (f.object.image.attached? ? image_tag(url_for(f.object.image), style: "max-width: 200px; height: auto;") : "PNG, JPEG, WEBP, SVG или GIF, до 10 МБ")
      f.input :examples,
              as: :file,
              input_html: { multiple: true },
              label: "Примеры использования",
              hint: (f.object.examples.attached? ? safe_join(f.object.examples.map { |img| image_tag(url_for(img), style: "max-width: 150px; height: auto; margin-right: 8px;") }) : "Можно выбрать несколько файлов")
    end

    f.actions
  end

  show do
    attributes_table do
      row("Изображение") do |t|
        if t.image.attached?
          image_tag url_for(t.image), style: "max-width: 400px; height: auto;"
        end
      end
      row("Термин") { |t| t.term }
      row("Категория") { |t| t.category }
      row("Определение") { |t| simple_format(t.definition.to_s) }
      row("Для чего нужен") { |t| simple_format(t.purpose.to_s) }
      row("Где используется") { |t| simple_format(t.context.to_s) }
      row("Упоминания в кейсе") { |t| t.sources }
      row("Примеры использования") do |t|
        if t.examples.attached?
          safe_join(t.examples.map { |ex| image_tag(url_for(ex), style: "max-width: 200px; height: auto; margin-right: 8px;") })
        end
      end
      row("Привязанные кейсы") do |t|
        if t.mentioned_in_cases.any?
          safe_join(t.mentioned_in_cases.map { |c| "#{c.company} — #{c.ds_name}" }, tag.br)
        else
          "—"
        end
      end
      row("Опубликован") { |t| t.published }
      row("Создан") { |t| t.created_at }
      row("Обновлён") { |t| t.updated_at }
    end
  end
end
