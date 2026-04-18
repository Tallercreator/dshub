require "json"

data = JSON.parse(File.read(Rails.root.join("db/seeds/data/new_reviews.json")))

data.each do |_key, attrs|
  company = attrs["company"]
  ds_name = attrs["ds_name"]
  kase = Case.find_or_initialize_by(company: company, ds_name: ds_name)

  kase.assign_attributes(
    attrs.merge(
      "case_type" => "Открытый кейс",
      "case_format" => "Обзор",
      "published" => true
    )
  )
  kase.save!
  puts "Saved: ##{kase.id} #{kase.company} — #{kase.ds_name}"
end

puts "\nTotal cases: #{Case.count}"
