# Resetting database
puts "Cleaning database..."
Property.destroy_all
Region.destroy_all
User.destroy_all
Account.destroy_all

puts "Creating primary account..."
account = Account.create!(name: "Griya Utama", subdomain: "griya")

puts "Creating regions in Yogyakarta..."
regions = [
  { name: "Sleman", center: "POINT(110.3800 -7.7100)" },
  { name: "Bantul", center: "POINT(110.3300 -7.8900)" },
  { name: "Gunung Kidul", center: "POINT(110.6000 -7.9900)" },
  { name: "Kulon Progo", center: "POINT(110.1500 -7.8500)" },
  { name: "Kota Yogyakarta", center: "POINT(110.3700 -7.8000)" }
].map do |r|
  Region.create!(name: r[:name], country_code: "ID", center_point: r[:center])
end

puts "Creating users..."
admin = User.create!(
  email_address: "admin@griya.com",
  password: "password",
  role: :admin,
  account: account
)

agents = [
  { email: "budi@griya.com", name: "Budi Santoso" },
  { email: "siti@griya.com", name: "Siti Aminah" },
  { email: "ari@griya.com", name: "Ari Wijaya" }
].map do |u|
  User.create!(
    email_address: u[ :email],
    password: "password",
    role: :agent,
    account: account
  )
end

puts "Creating properties with detailed specs..."
property_data = [
  {
    title: "Rumah Mewah Modern Minimalis Sleman",
    description: "Hunian eksklusif dengan desain modern di lokasi strategis Sleman. Dekat dengan mall dan pusat bisnis. Lingkungan tenang dan aman dengan sistem one-gate.",
    price: 1500000000,
    listing_type: :for_sale,
    property_type: :house,
    status: :active,
    region: regions[0], # Sleman
    user: agents[0],
    lonlat: "POINT(110.3644 -7.7472)",
    featured: true,
    bedrooms: 4,
    bathrooms: 3,
    building_area: 200,
    surface_area: 150,
    floors: 2,
    certificate_type: "SHM",
    street_address: "Jl. Kaliurang KM 10, Sleman"
  },
  {
    title: "Tanah Murah Dekat Bantul City",
    description: "Tanah kavling siap bangun. Lokasi sangat berkembang, cocok untuk investasi masa depan atau hunian asri. Akses jalan aspal lebar.",
    price: 350000000,
    listing_type: :for_sale,
    property_type: :land,
    status: :active,
    region: regions[1], # Bantul
    user: agents[1],
    lonlat: "POINT(110.3125 -7.8890)",
    featured: false,
    bedrooms: 0,
    bathrooms: 0,
    building_area: 0,
    surface_area: 250,
    floors: 0,
    certificate_type: "SHM",
    street_address: "Jl. Bantul KM 5, Sewon"
  },
  {
    title: "Apartemen Studio City View Yogyakarta",
    description: "Apartemen mewah dengan fasilitas lengkap: kolam renang, gym, dan keamanan 24 jam. View kota yang indah di malam hari. Investasi menarik untuk sewa.",
    price: 550000000,
    listing_type: :for_sale,
    property_type: :apartment,
    status: :active,
    region: regions[4], # Kota
    user: agents[2],
    lonlat: "POINT(110.3705 -7.7810)",
    featured: true,
    bedrooms: 1,
    bathrooms: 1,
    building_area: 36,
    surface_area: 36,
    floors: 1,
    certificate_type: "HGB",
    street_address: "Jl. Laksda Adisucipto"
  },
  {
    title: "Ruko Strategis di Pusat Kota Jogja",
    description: "Ruko 3 lantai sangat luas. Lokasi prime di pinggir jalan utama. Cocok untuk kantor, bank, atau showroom bisnis Anda.",
    price: 25000000,
    listing_type: :for_rent,
    property_type: :commercial,
    status: :active,
    region: regions[4], # Kota
    user: agents[0],
    lonlat: "POINT(110.3650 -7.7940)",
    featured: false,
    bedrooms: 0,
    bathrooms: 2,
    building_area: 150,
    surface_area: 100,
    floors: 3,
    certificate_type: "HGB",
    street_address: "Jl. Malioboro No. 45"
  },
  {
    title: "Rumah Klasik Jawa Estetik Bantul",
    description: "Rumah dengan sentuhan gaya Joglo modern. Udara bersih dan jauh dari kebisingan kota. Interior menggunakan kayu jati pilihan.",
    price: 1200000000,
    listing_type: :for_sale,
    property_type: :house,
    status: :active,
    region: regions[1], # Bantul
    user: agents[1],
    lonlat: "POINT(110.3245 -7.8456)",
    featured: true,
    bedrooms: 3,
    bathrooms: 2,
    building_area: 180,
    surface_area: 300,
    floors: 1,
    certificate_type: "SHM",
    street_address: "Kasongan, Bantul"
  }
].each do |p|
  Property.create!(p.merge(account: account))
end

puts "Seed completed! 🚀"
puts "Users: admin@griya.com, budi@griya.com, siti@griya.com, ari@griya.com (pass: password)"
