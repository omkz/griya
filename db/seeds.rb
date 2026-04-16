# Hapus data lama biar bersih
Property.destroy_all
User.destroy_all
Region.destroy_all
Account.destroy_all

# Buat data minimal
acc = Account.create!(name: "Griya Jogja", subdomain: "jogja")
user = User.create!(email_address: "agent@griya.com", password: "password123", account: acc, role: :agent)
reg = Region.create!(name: "Bangunjiwo", country_code: "ID")
reg2 = Region.create!(name: "Kasihan", country_code: "ID")

properties_data = [
  {
    title: "Rumah Minimalis Modern Bangunjiwo",
    description: "Hunian asri dengan konsep open space. Cocok untuk keluarga muda. Dekat dengan Kampus UMY.",
    price: 750_000_000,
    listing_type: :for_sale,
    property_type: :house,
    status: :active,
    region: reg,
    lonlat: "POINT(110.3245 -7.8456)"
  },
  {
    title: "Tanah Kavling Siap Bangun",
    description: "Lokasi strategis di pinggir jalan utama. View sawah yang menenangkan.",
    price: 350_000_000,
    listing_type: :for_sale,
    property_type: :land,
    status: :active,
    region: reg,
    lonlat: "POINT(110.3250 -7.8460)"
  },
  {
    title: "Apartemen Mewah Dekat Ring Road",
    description: "Fasilitas lengkap: kolam renang, gym, dan keamanan 24 jam.",
    price: 500_000_000,
    listing_type: :for_rent,
    property_type: :apartment,
    status: :active,
    region: reg2,
    lonlat: "POINT(110.3300 -7.8400)"
  },
  {
    title: "Rumah Industrial Bangunjiwo",
    description: "Desain unik, material ekspos, pencahayaan alami sangat baik.",
    price: 1_200_000_000,
    listing_type: :for_sale,
    property_type: :house,
    status: :active,
    region: reg,
    lonlat: "POINT(110.3200 -7.8500)"
  },
  {
    title: "Tanah Luas untuk Investasi",
    description: "Cocok untuk dibangun perumahan atau villa. Legalitas lengkap (SHM).",
    price: 2_500_000_000,
    listing_type: :for_sale,
    property_type: :land,
    status: :active,
    region: reg2,
    lonlat: "POINT(110.3400 -7.8300)"
  },
  {
    title: "Rumah Subsidi Cicilan Ringan",
    description: "Program pemerintah, harga terjangkau, lingkungan sudah ramai.",
    price: 165_000_000,
    listing_type: :for_sale,
    property_type: :house,
    status: :active,
    region: reg,
    lonlat: "POINT(110.3100 -7.8600)"
  }
]

properties_data.each do |data|
  Property.create!(data.merge(account: acc, user: user))
end

puts "Seed selesai! Dibuat #{Property.count} properti."

