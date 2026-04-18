ActiveAdmin.register CaseApplication do
  menu label: "Заявки на кейсы", priority: 4

  actions :index, :show, :destroy

  index do
    selectable_column
    id_column
    column "Имя", :name
    column "Telegram", :telegram
    column "Компания", :company
    column "Другой контакт", :other_contact
    column "Отправлена", :created_at
    actions
  end

  filter :name, label: "Имя"
  filter :telegram, label: "Telegram"
  filter :company, label: "Компания"
  filter :other_contact, label: "Другой контакт"
  filter :created_at, label: "Отправлена"

  show do
    attributes_table do
      row("Имя") { |a| a.name }
      row("Telegram") { |a| a.telegram }
      row("Компания") { |a| a.company }
      row("Другой контакт") { |a| a.other_contact }
      row("Отправлена") { |a| a.created_at }
    end
  end
end
