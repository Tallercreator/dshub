ActiveAdmin.register Resource do
  permit_params :resource_type, :tags, :title, :description, :url, :published, :cover_image

  menu label: "Ресурсы", priority: 3

  index do
    selectable_column
    id_column
    column "Тип", :resource_type
    column "Заголовок", :title
    column "Ссылка", :url do |r|
      link_to r.url, r.safe_url, target: "_blank", rel: "noopener" if r.url.present?
    end
    column "Теги", :tags
    column "Опубликован", :published
    column "Создан", :created_at
    actions
  end

  filter :resource_type,
         as: :select,
         collection: Resource::RESOURCE_TYPES,
         label: "Тип"
  filter :title, label: "Заголовок"
  filter :tags, label: "Теги"
  filter :published, label: "Опубликован"
  filter :created_at, label: "Создан"

  form do |f|
    f.inputs do
      f.input :resource_type,
              as: :select,
              collection: Resource::RESOURCE_TYPES,
              include_blank: "— не выбрано —",
              label: "Тип"
      f.input :title, label: "Заголовок"
      f.input :url, label: "Ссылка", hint: "Полный URL, например https://example.com/article"
      f.input :description, label: "Описание", input_html: { rows: 6 }
      f.input :tags, label: "Теги", hint: "Теги через запятую"
      f.input :cover_image, as: :file, label: "Обложка",
              hint: f.object.cover_image.attached? ? image_tag(f.object.cover_image, style: "max-height: 120px; border-radius: 8px;") : "PNG/JPG/WEBP/SVG"
      f.input :published, label: "Опубликован"
    end
    f.actions
  end

  show do
    attributes_table do
      row("Тип") { |r| r.resource_type }
      row("Заголовок") { |r| r.title }
      row("Ссылка") { |r| link_to r.url, r.safe_url, target: "_blank", rel: "noopener" if r.url.present? }
      row("Описание") { |r| simple_format(r.description.to_s) }
      row("Теги") { |r| r.tags }
      row("Обложка") { |r| image_tag(r.cover_image, style: "max-height: 200px; border-radius: 8px;") if r.cover_image.attached? }
      row("Опубликован") { |r| r.published }
      row("Создан") { |r| r.created_at }
      row("Обновлён") { |r| r.updated_at }
    end
  end
end
