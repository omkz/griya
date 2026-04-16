# Reset Data
puts "Cleaning database..."
Property.destroy_all
User.destroy_all
Region.destroy_all
Account.destroy_all

# Core Data
acc = Account.create!(name: "Griya Jogja", subdomain: "jogja")
agent = User.create!(email_address: "agent@griya.com", password: "password123", account: acc, role: :agent)
admin = User.create!(email_address: "admin@griya.com", password: "password123", account: acc, role: :admin)

regions = [
  Region.create!(name: "Bangunjiwo", country_code: "ID"),
  Region.create!(name: "Kasihan", country_code: "ID"),
  Region.create!(name: "Sewon", country_code: "ID"),
  Region.create!(name: "Bantul Kota", country_code: "ID"),
  Region.create!(name: "Sleman", country_code: "ID")
]

titles = [
  "Rumah Minimalis Modern", "Tanah Kavling Murah", "Apartemen Eksklusif", 
  "Griya Asri Bangunjiwo", "Hunian Nyaman Keluarga", "Ruko Strategis",
  "Pekarangan Luas Shm", "Rumah Industrial 2 Lantai", "Tanah Tepi Jalan",
  "Vila View Sawah", "Kost Eksklusif Dekat UMY", "Cluster Bangunjiwo Permai"
]

descriptions = [
  "Lokasi sangat strategis dekat dengan pusat pendidikan. Lingkungan aman dan asri.",
  "Sudah pecah SHM, siap bangun. Akses jalan aspal luas bisa simpangan mobil.",
  "Konsep hunian modern dengan pencahayaan alami maksimal. Bebas banjir.",
  "Investasi menjanjikan di Jogja Selatan. Dekat dengan rencana gate tol.",
  "Bangunan kokoh, material berkualitas tinggi, desain kekinian.",
  "Dekat masjid, pasar, dan fasilitas kesehatan. Akses kendaraan mudah."
]

puts "Seeding 20 properties..."

20.times do |i|
  type = Property.property_types.keys.sample
  l_type = Property.listing_types.keys.sample

  
  # Logic for realistic pricing
  base_price = case type
               when "house" then rand(450..2500) * 1_000_000
               when "land" then rand(150..3000) * 1_000_000
               when "apartment" then rand(350..1500) * 1_000_000
               else rand(800..5000) * 1_000_000
               end

  Property.create!(
    account: acc,
    user: [agent, admin].sample,
    region: regions.sample,
    title: "#{titles.sample} #{i+1}",
    description: descriptions.sample,
    price: base_price,
    listing_type: l_type,
    property_type: type,
    status: :active,
    featured: (i < 4), # First 4 are featured
    views_count: rand(10..500),
    lonlat: "POINT(#{110.3 + rand(0.01..0.05)} #{-7.8 - rand(0.01..0.05)})"
  )
end

puts "Database seeded successfully!"
puts "Created #{Property.count} properties."
puts "Featured properties: #{Property.where(featured: true).count}"
