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
    description: Faker::Fantasy::Tolkien.poem,
    bar_type: "Bar à bières"
  )
end

puts("Seeded #{Bar.count} bars")

User.destroy_all

50.times do
  bar_id = Bar.all.sample
  User.create!(
    username: Faker::Fantasy::Tolkien.character,
    email: Faker::Internet.email,
    password: "123456",
    age: rand(18..60),
    description: Faker::Fantasy::Tolkien.poem,
    latitude: rand(48.094380..48.136752),
    longitude: rand(-1.629610..-1.703168),
    first_login: false,
    status: "available",
    nearest_bar_id: bar_id
    )
end

User.create!(
  username: Faker::Fantasy::Tolkien.character,
  email: "admin@gmail.com",
  password: "123456",
  age: rand(18..60),
  description: Faker::Fantasy::Tolkien.poem,
  latitude: rand(48.094380..48.136752),
  longitude: rand(-1.629610..-1.703168),
  first_login: false,
  status: "available"
  )

puts("Seeded #{User.count} users")
