# Reset Data
puts "Cleaning database..."
Property.destroy_all
User.destroy_all
Region.destroy_all
Account.destroy_all

# Core Account
acc = Account.create!(name: "Griya Jogja", subdomain: "jogja")

# Users
puts "Creating users..."
admin = User.create!(email_address: "admin@griya.com", password: "password123", account: acc, role: :admin)
agent1 = User.create!(email_address: "agent_jogja@griya.com", password: "password123", account: acc, role: :agent)
agent2 = User.create!(email_address: "agent_bantul@griya.com", password: "password123", account: acc, role: :agent)
agent3 = User.create!(email_address: "agent_sleman@griya.com", password: "password123", account: acc, role: :agent)

agents = [agent1, agent2, agent3]

# Regions
regions = [
  Region.create!(name: "Bangunjiwo", country_code: "ID"),
  Region.create!(name: "Kasihan", country_code: "ID"),
  Region.create!(name: "Sewon", country_code: "ID"),
  Region.create!(name: "Bantul Kota", country_code: "ID"),
  Region.create!(name: "Sleman", country_code: "ID"),
  Region.create!(name: "Godean", country_code: "ID"),
  Region.create!(name: "Mlati", country_code: "ID")
]

titles = [
  "Rumah Minimalis Modern", "Tanah Kavling Murah", "Apartemen Eksklusif", 
  "Griya Asri Bangunjiwo", "Hunian Nyaman Keluarga", "Ruko Strategis",
  "Pekarangan Luas Shm", "Rumah Industrial 2 Lantai", "Tanah Tepi Jalan",
  "Vila View Sawah", "Kost Eksklusif Dekat UMY", "Cluster Bangunjiwo Permai",
  "Rumah Heritage Kotagede", "Tanah Pekarangan Matang", "Condo Mewah Ringroad"
]

descriptions = [
  "Lokasi sangat strategis dekat dengan pusat pendidikan. Lingkungan aman dan asri.",
  "Sudah pecah SHM, siap bangun. Akses jalan aspal luas bisa simpangan mobil.",
  "Konsep hunian modern dengan pencahayaan alami maksimal. Bebas banjir.",
  "Investasi menjanjikan di Jogja Selatan. Dekat dengan rencana gate tol.",
  "Bangunan kokoh, material berkualitas tinggi, desain kekinian.",
  "Dekat masjid, pasar, dan fasilitas kesehatan. Akses kendaraan mudah."
]

puts "Seeding 30 properties..."

30.times do |i|
  type = Property.property_types.keys.sample
  l_type = Property.listing_types.keys.sample
  
  base_price = case type
               when "house" then rand(450..2500) * 1_000_000
               when "land" then rand(150..3000) * 1_000_000
               when "apartment" then rand(350..1500) * 1_000_000
               else rand(800..5000) * 1_000_000
               end

  Property.create!(
    account: acc,
    user: (i < 5 ? admin : agents.sample), # Admin owns 5, others distributed
    region: regions.sample,
    title: "#{titles.sample} #{i+1}",
    description: descriptions.sample,
    price: base_price,
    listing_type: l_type,
    property_type: type,
    status: :active,
    featured: (i < 6), # First 6 are featured
    views_count: rand(10..1000),
    lonlat: "POINT(#{110.3 + rand(0.01..0.08)} #{-7.8 - rand(0.01..0.08)})"
  )
end

puts "--- SEED SUMMARY ---"
puts "Users: #{User.count} (1 Admin, 3 Agents)"
puts "Properties: #{Property.count}"
puts "Featured: #{Property.where(featured: true).count}"
puts "Agent Jogja Listings: #{agent1.properties.count}"
puts "Agent Bantul Listings: #{agent2.properties.count}"
puts "Agent Sleman Listings: #{agent3.properties.count}"
puts "--------------------"
