require "json"

content = JSON.parse(File.read(Rails.root.join("tmp/cases_content.json")))

# Match company_key from JSON → Case record (company + ds_name)
mapping = {
  "Ozon" => ["Ozon", "Ozon DS"],
  "Альфа-Банк" => ["Альфа-Банк", "Альфа ДС"],
  "Авито" => ["Авито", "AKITA — Avito Design Team"],
  "Сбер" => ["Сбер", "BTO — Операционный центр"],
  "МТС Финтех" => ["МТС Финтех", "Astra"],
  "ОТП Банк" => ["ОТП Банк", "Lora"],
  "Skillaz" => ["Skillaz", "Skill Grid"],
  "Студия и продукт" => ["Студия и продукт", "Eda Project · Glorex · Контур"],
  "Яндекс" => ["Яндекс", "Gravity UI"],
  "Kaspersky" => ["Kaspersky", "Hexa UI"],
  "Сбер_Nova" => ["Сбер", "Nova"],
  "ВКонтакте" => ["ВКонтакте", "VKUI"],
}

content.each do |key, fields|
  company, ds_name = mapping[key]
  kase = Case.find_by(company: company, ds_name: ds_name)
  unless kase
    puts "NOT FOUND: #{company} — #{ds_name}"
    next
  end

  kase.update!(fields)
  filled = fields.count { |_, v| v.present? }
  puts "Updated ##{kase.id} #{kase.company} — #{kase.ds_name} (#{filled} sections)"
end

puts "\nDone. Total cases: #{Case.count}"
