require "json"

terms_data = JSON.parse(File.read(Rails.root.join("tmp/terms.json")))

terms_data.each do |data|
  term = Term.find_or_initialize_by(term: data["term"])

  term.assign_attributes(
    category: data["category"],
    definition: data["definition"],
    purpose: data["purpose"],
    context: data["context"],
    sources: data["sources"],
    published: true
  )
  term.save!
  puts "Saved: ##{term.id} #{term.term} (#{term.category})"
end

puts "\nTotal terms: #{Term.count}"
