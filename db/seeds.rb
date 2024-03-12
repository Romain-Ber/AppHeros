Message.destroy_all
Challenge.destroy_all
Score.destroy_all
Bar.destroy_all
User.destroy_all
Game.destroy_all

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

100.times do
  bar = Bar.all.sample
  username = Faker::Fantasy::Tolkien.character
  while username.length >= 15
    username = Faker::Fantasy::Tolkien.character
  end
  User.create!(
    username: username,
    email: Faker::Internet.email,
    password: "123456",
    age: rand(18..60),
    description: Faker::Fantasy::Tolkien.poem,
    latitude: rand(48.094380..48.136752),
    longitude: rand(-1.629610..-1.703168),
    first_login: false,
    status: "available",
    nearest_bar_id: bar.id
    )
end

User.create!(
  username: "Admin",
  email: "admin@gmail.com",
  password: "123456",
  age: rand(18..60),
  description: Faker::Fantasy::Tolkien.poem,
  latitude: rand(48.094380..48.136752),
  longitude: rand(-1.629610..-1.703168),
  first_login: false,
  status: "available",
  nearest_bar_id: Bar.first.id
)

User.create!(
  username: "Knnll",
  email: "knnll@gmail.com",
  password: "123456",
  age: 24,
  description: "C'est moi",
  latitude: rand(48.094380..48.136752),
  longitude: rand(-1.629610..-1.703168),
  first_login: false,
  status: "available",
  nearest_bar_id: Bar.first.id
)

User.create!(
  username: "Romain",
  email: "romain@gmail.com",
  password: "123456",
  age: rand(18..60),
  description: Faker::Fantasy::Tolkien.poem,
  latitude: rand(48.094380..48.136752),
  longitude: rand(-1.629610..-1.703168),
  first_login: false,
  status: "available",
  nearest_bar_id: Bar.first.id
)

puts("Seeded #{User.count} users")

Game.create!(
  name: "Partie Personnalisée",
  slug: "custom_game"
)

Game.create!(
  name: "Memory",
  slug: "memory_game"
)

Game.create!(
  name: "Tap Ta Bière",
  slug: "taptabiere_game"
)

puts("Seeded #{Game.count} games")

Challenge.create!(
  location: "4ème table à gauche à l'entrée du bar",
  status: "accepted",
  game: Game.all.sample,
  bar: Bar.all.sample,
  challenger: User.all.sample,
  challenged: User.all.sample
)

puts("Seeded #{Challenge.count} challenges")

1000.times do
  Score.create!(
    score: rand(10..50),
    bar: Bar.all.sample,
    user: User.all.sample
  )
end

puts("Seeded #{Score.count} scores")
