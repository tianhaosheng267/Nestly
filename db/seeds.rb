














require "faker"




def seed_user!(name:, email:)
  user = User.find_or_initialize_by(email: email)

  user.assign_attributes(
    name: name,
    password: "123456",
    password_confirmation: "123456"
  )

  user.save!
  user
end

landlord_1 = seed_user!(
  name: "Test Landlord",
  email: "landlord@example.com",
)

renter_1 = seed_user!(
  name: "Test Renter",
  email: "renter@example.com",
)

amenities_list = [ "Swimming pool", "Deck or Patio", "Private balcony", "Designated parking space", "Smart lighting", "Smart locks", "Large windows", "Fireplace", "Dishwasher", "Hardwood floors", "High-end appliances", "Solar panels" ]



10.times do
Property.create!(
address: Faker::Address.street_address,
city: Faker::Address.city,
zip: Faker::Address.zip,
state: Faker::Address.state_abbr,
landlord_id: landlord_1.id,
date_available: Faker::Date.between(from: '2026-08-01', to: '2026-10-25'),
monthly_rent: Faker::Number.between(from: 400, to: 6000),
num_bathrooms: Faker::Number.between(from: 1, to: 4),
num_bedrooms: Faker::Number.between(from: 1, to: 4),
sqft: Faker::Number.between(from: 400, to: 1500),
pet_friendly: Faker::Boolean.boolean(true_ratio: 0.8),
amenities: amenities_list.sample(rand(1..amenities_list.length)).join(", "))
end

counter = 1
Property.all.each do |property|
  property.images.attach(io: File.open(Rails.root.join("app/assets/images/#{counter}.jpg")),
  filename: "image#{counter}.jpg")
  counter += 1
end
