require "json"

resources_data = JSON.parse(File.read(Rails.root.join("tmp/resources.json")))

resources_data.each do |data|
  resource = Resource.find_or_initialize_by(title: data["title"])
  resource.assign_attributes(
    resource_type: data["resource_type"],
    description: data["description"],
    url: data["url"],
    tags: data["tags"],
    published: true
  )
  resource.save!
  puts "Saved: ##{resource.id} [#{resource.resource_type}] #{resource.title}"
end

puts "\nTotal: #{Resource.count}"
puts Resource.group(:resource_type).count
