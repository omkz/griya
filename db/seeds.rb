# Hapus data lama biar bersih
Property.destroy_all
User.destroy_all
Account.destroy_all

# Buat data minimal
acc = Account.create!(name: "Griya Jogja", subdomain: "jogja")
user = User.create!(email_address: "agent@griya.com", password: "password123", account: acc, role: :agent)
reg = Region.create!(name: "Bangunjiwo", country_code: "ID")

# Buat 1 Properti buat ngetes
Property.create!(
  account: acc, user: user, region: reg,
  title: "Rumah Cantik di Bangunjiwo",
  description: "Dekat dengan alam dan tenang.",
  price: 950_000_000,
  listing_type: :for_sale,
  property_type: :house,
  status: :active,
  lonlat: "POINT(110.3245 -7.8456)"
)
