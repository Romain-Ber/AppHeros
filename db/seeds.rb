Challenge.destroy_all
Score.destroy_all
Bar.destroy_all
User.destroy_all
Game.destroy_all

# bars_data.json extraction to generate bars seed

@bars_file = File.join(__dir__, 'bars_data.json')
@bars_data = []
def read_bars_data_json(file)
  if File.exist?(file)
    File.open(file, "r") do |file|
      @bars_data = JSON.parse(file.read)
    end
  end
  return @bars_data
end

# bars builder from scrapped data

def bar_builder
  read_bars_data_json(@bars_file)
  @bars_data.each do |bar_data|
    name, address, bar_type, description, opening_hours = "", "", "", "", ""
    phone, outdoor_seats, wheelchair, website, email = "", "", "", "", ""
    bar_data["data"].each do |data|
      name = data["name"] if data["name"]
      address = data["address"] if data["address"]
      bar_type = data["amenity"] if data["amenity"]
      description = data["description"] if data["description"]
      opening_hours = data["opening_hours"] if data["opening_hours"]
      phone = data["phone"] if data["phone"]
      website = data["website"] if data["website"]
      email = data["email"] if data["email"]
      outdoor_seats = data["outdoor_seats"] if data["outdoor_seats"]
      wheelchair = data["wheelchair"] if data["wheelchair"]
    end
    description = "Toss a Coin to your Scrapper, oh Valley of APIs" if description.blank?
    bar = Bar.create!(
      name: name,
      address: address,
      bar_type: bar_type,
      description: description,
      opening_hours: opening_hours,
      phone: phone,
      outdoor_seats: outdoor_seats,
      wheelchair: wheelchair,
      website: website,
      email: email
    )
  end
end

bar_builder()

puts("Seeded #{Bar.count} bars")

3500.times do
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

User.create!(
  username: "Knnll",
  email: "knnll@gmail.com",
  password: "123456",
  age: 24,
  description: "C'est moi",
  latitude: rand(48.094380..48.136752),
  longitude: rand(-1.629610..-1.703168),
  first_login: false,
  status: "available"
)

User.create!(
  username: Faker::Fantasy::Tolkien.character,
  email: "romain@gmail.com",
  password: "123456",
  age: rand(18..60),
  description: Faker::Fantasy::Tolkien.poem,
  latitude: rand(48.094380..48.136752),
  longitude: rand(-1.629610..-1.703168),
  first_login: false,
  status: "available"
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

35000.times do
  Score.create!(
    score: rand(10..50),
    bar: Bar.all.sample,
    user: User.all.sample
  )
end

puts("Seeded #{Score.count} scores")
