User.destroy_all

10.times do
  User.create!(
    username: Faker::Fantasy::Tolkien.character,
    email: Faker::Internet.email,
    password: "123456",
    age: rand(18..60),
    description: Faker::Fantasy::Tolkien.poem,
    latitude: rand(48.094380..48.136752),
    longitude: rand(-1.629610..-1.703168)
    )
end

User.create!(
  username: Faker::Fantasy::Tolkien.character,
  email: "admin@gmail.com",
  password: "123456",
  age: rand(18..60),
  description: Faker::Fantasy::Tolkien.poem,
  latitude: rand(48.094380..48.136752),
  longitude: rand(-1.629610..-1.703168)
  )

puts("Seeded #{User.count} users")

Bar.destroy_all

ADDRESSES = [
  "La Piste, Rennes",
  "Le mabilay, Rennes",
  "La gare, Rennes",
  "Mairie, Rennes"
]

10.times do
  Bar.create!(
    name: Faker::Fantasy::Tolkien.location,
    address: ADDRESSES.sample,
    description: Faker::Fantasy::Tolkien.poem
  )
end

puts("Seeded #{Bar.count} bars")
