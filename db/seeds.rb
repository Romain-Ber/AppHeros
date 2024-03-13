# ------------------------------------------------------------------------------
# CONFIG
# ------------------------------------------------------------------------------

Faker::Config.locale = :fr

# ------------------------------------------------------------------------------
# DESTROY_ALL
# ------------------------------------------------------------------------------

def reset_seed
  Message.destroy_all
  Challenge.destroy_all
  Score.destroy_all
  Bar.destroy_all
  User.destroy_all
  Game.destroy_all
end

reset_seed()

# ------------------------------------------------------------------------------
# CLOUDINARY IMAGES SEED
# ------------------------------------------------------------------------------

def fetch_images_id
  cloudinary_api_key = ENV['CLOUDINARY_API_KEY']
  cloudinary_api_secret = ENV['CLOUDINARY_API_SECRET']
  cloudinary_cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  url = "https://#{cloudinary_api_key}:#{cloudinary_api_secret}@api.cloudinary.com/v1_1/#{cloudinary_cloud_name}/resources/image?max_results=500"
  response = RestClient.get(url)
  data = JSON.parse(response.body)
  @images = data["resources"]
  @cloudinary_file = File.join(__dir__, 'cloudinary_data.json')
  File.open(@cloudinary_file, 'w') do |file|
    file.write(JSON.pretty_generate(@images))
  end
end

@cloudinary_data = []

def read_images_data_json
  @cloudinary_data_file = File.join(__dir__, 'cloudinary_data.json')
  if File.exist?(@cloudinary_data_file)
    File.open(@cloudinary_data_file, "r") do |file|
      @cloudinary_data = JSON.parse(file.read)
    end
  end
  return @cloudinary_data
end

@img_bars = []
@img_male_users = []
@img_female_users = []

def sort_images
  @cloudinary_data.each do |img|
    if img["public_id"].include?("development/AppHeros/bar")
      @img_bars << img["public_id"]
    elsif img["public_id"].include?("development/AppHeros/user/male")
      @img_male_users << img["public_id"]
    elsif img["public_id"].include?("development/AppHeros/user/female")
      @img_female_users << img["public_id"]
    end
  end
end

def seed_images
  fetch_images_id()
  read_images_data_json()
  sort_images()
  img_total = @img_bars.count + @img_male_users.count + @img_female_users.count
  puts("Seeded #{@img_total} images")
end

seed_images()

# ------------------------------------------------------------------------------
# BARS SEED
# ------------------------------------------------------------------------------

def read_bars_data_json
  @bars_file = File.join(__dir__, 'bars_data.json')
  @bars_data = []
  if File.exist?(@bars_file)
    File.open(@bars_file, "r") do |file|
      @bars_data = JSON.parse(file.read)
    end
  end
  return @bars_data
end

def bar_builder
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
      email: email,
      image_id: @img_bars.sample
    )
    puts("Seeded Bar ##{Bar.count} / 495")
  end
end

def seed_bars
  read_bars_data_json()
  bar_builder()
end

seed_bars()

# ------------------------------------------------------------------------------
# FAKE USERS SEED
# ------------------------------------------------------------------------------

def user_builder(first_name, gender, image_id, latitude, longitude)
  bar = Bar.all.sample
  last_name = Faker::Name.last_name
  username = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  email = "#{first_name.unicode_normalize(:nfkd).encode('ASCII', replace: '').downcase.gsub(/\s+/, "")}.#{last_name.unicode_normalize(:nfkd).encode('ASCII', replace: '').downcase.gsub(/\s+/, "")}@gmail.com"
  if User.all.any? { |user| user.email == email }
    email += "#{rand(1..90000)}"
  end
  User.create!(
    username: username,
    email: email,
    password: "9876543210",
    age: rand(18..45),
    # random faker description of someone enjoying bars
    description: "Ma bière préférée est la #{Faker::Beer.name} mais j'aime aussi la #{Faker::Beer.brand}. Respectivement #{Faker::Beer.alcohol} et #{Faker::Beer.alcohol} d'alcool. Hésite pas à me proposer une partie, j'aime bien rencontrer de nouvelles personnes!",
    latitude: latitude,
    longitude: longitude,
    first_login: false,
    status: "available",
    nearest_bar_id: bar.id,
    image_id: image_id,
    gender: gender
    )
  puts("Seeded User ##{User.count} / 3504")
end

def create_users
  # rennes users
    # male users
  1000.times do
    first_name = Faker::Name.male_first_name
    image_id = @img_male_users.sample
    latitude = rand(48.094380..48.136752)
    longitude = rand(-1.629610..-1.703168)
    gender = "male"
    user_builder(first_name, gender, image_id, latitude, longitude)
  end
  # rennes users
    # female users
  1000.times do
    first_name = Faker::Name.female_first_name
    image_id = @img_female_users.sample
    latitude = rand(48.094380..48.136752)
    longitude = rand(-1.629610..-1.703168)
    gender = "female"
    user_builder(first_name, gender, image_id, latitude, longitude)
  end
  # nantes users
    # male users
  750.times do
    first_name = Faker::Name.male_first_name
    image_id = @img_male_users.sample
    latitude = rand(47.180189..47.252873)
    longitude = rand(-1.620718..-1.493774)
    gender = "male"
    user_builder(first_name, gender, image_id, latitude, longitude)
  end
  # nantes users
    # female users
  750.times do
    first_name = Faker::Name.female_first_name
    image_id = @img_female_users.sample
    latitude = rand(47.180189..47.252873)
    longitude = rand(-1.620718..-1.493774)
    gender = "female"
    user_builder(first_name, gender, image_id, latitude, longitude)
  end
end

# admins
def create_admins
  User.create!(
    username: "GOD",
    email: "admin@gmail.com",
    password: "123456",
    age: rand(18..60),
    description: Faker::Fantasy::Tolkien.poem,
    latitude: rand(48.094380..48.136752),
    longitude: rand(-1.629610..-1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male"
  )
  User.create!(
    username: "Knnll",
    email: "knnll@gmail.com",
    password: "123456",
    age: 24,
    description: "J'aime bien la bière, rencontrer du beau monde, mais surtout GAGNER",
    latitude: rand(48.094380..48.136752),
    longitude: rand(-1.629610..-1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_female_users.sample,
    gender: "female"
  )
  User.create!(
    username: "Romain",
    email: "romain@gmail.com",
    password: "123456",
    age: 38,
    description: "Ah que coucou",
    latitude: rand(48.094380..48.136752),
    longitude: rand(-1.629610..-1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male"
  )
  User.create!(
    username: "Florian",
    email: "florian@gmail.com",
    password: "123456",
    age: 26,
    description: "T'as de l'argent de poche Tonton?",
    latitude: rand(48.094380..48.136752),
    longitude: rand(-1.629610..-1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male"
  )
end

def seed_users
  create_users()
  create_admins()
end

seed_users()

# ------------------------------------------------------------------------------
# GAMES SEED
# ------------------------------------------------------------------------------

def seed_games
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
end

seed_games()

# ------------------------------------------------------------------------------
# SCORES SEED
# ------------------------------------------------------------------------------

def seed_scores
  35000.times do
    Score.create!(
      score: rand(10..50),
      bar: Bar.all.sample,
      user: User.all.sample
    )
    puts("Seeded Score ##{Score.count} / 35,000")
  end
end

seed_scores()

# ------------------------------------------------------------------------------
# CHALLENGES SEED /!\ TESTING PURPOSES /!\
# ------------------------------------------------------------------------------

def seed_challenges
  Challenge.create!(
    location: "4ème table à gauche à l'entrée du bar",
    status: "accepted",
    game: Game.all.sample,
    bar: Bar.all.sample,
    challenger: User.all.sample,
    challenged: User.all.sample
  )
  puts("Seeded #{Challenge.count} challenges")
end

seed_challenges()
