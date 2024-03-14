# ------------------------------------------------------------------------------
# CONFIG
# ------------------------------------------------------------------------------

Faker::Config.locale = :fr

# ------------------------------------------------------------------------------
# DESTROY_ALL
# ------------------------------------------------------------------------------

def remove_seed
  Message.destroy_all
  Challenge.destroy_all
  Score.destroy_all
  Bar.destroy_all
  User.destroy_all
  Game.destroy_all
end

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
  puts("Seeded User ##{User.count} / 1300")
end

def seed_users
  # rennes users
    # male users
  350.times do
    first_name = Faker::Name.male_first_name
    image_id = @img_male_users.sample
    latitude = rand(48.094380..48.136752)
    longitude = -rand(1.629610..1.703168)
    gender = "male"
    user_builder(first_name, gender, image_id, latitude, longitude)
  end
  # rennes users
    # female users
  350.times do
    first_name = Faker::Name.female_first_name
    image_id = @img_female_users.sample
    latitude = rand(48.094380..48.136752)
    longitude = -rand(1.629610..1.703168)
    gender = "female"
    user_builder(first_name, gender, image_id, latitude, longitude)
  end
  # nantes users
    # male users
  300.times do
    first_name = Faker::Name.male_first_name
    image_id = @img_male_users.sample
    latitude = rand(47.180189..47.252873)
    longitude = -rand(1.493774..1.620718)
    gender = "male"
    user_builder(first_name, gender, image_id, latitude, longitude)
  end
  # nantes users
    # female users
  300.times do
    first_name = Faker::Name.female_first_name
    image_id = @img_female_users.sample
    latitude = rand(47.180189..47.252873)
    longitude = -rand(1.493774..1.620718)
    gender = "female"
    user_builder(first_name, gender, image_id, latitude, longitude)
  end
end

def seed_wagon
  @bar = Bar.first
  User.create!(
    username: "Knnll",
    email: "knnll@gmail.com",
    password: "123456",
    age: 24,
    description: "J'aime bien la bière, rencontrer du beau monde, mais surtout GAGNER",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_female_users.sample,
    gender: "female",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Romain",
    email: "romain@gmail.com",
    password: "123456",
    age: 38,
    description: "Ah que coucou",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Florian",
    email: "florian@gmail.com",
    password: "123456",
    age: 26,
    description: "T'as de l'argent de poche Tonton?",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Marine",
    email: "marine@gmail.com",
    password: "123456",
    age: 30,
    description: "Grande prêtresse de la félicité",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_female_users.sample,
    gender: "female",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Perrine",
    email: "perrine@gmail.com",
    password: "123456",
    age: 28,
    description: "Gardienne de la stabilité",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_female_users.sample,
    gender: "female",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Mathieu",
    email: "mathieu@gmail.com",
    password: "123456",
    age: 28,
    description: "Beatles.each do |beatle|",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Cédric",
    email: "cedric@gmail.com",
    password: "123456",
    age: 45,
    description: "Amateur de marteaux",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "JJ",
    email: "jj@gmail.com",
    password: "123456",
    age: 28,
    description: "Front-end God",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Lomig",
    email: "lomig@gmail.com",
    password: "123456",
    age: 45,
    description: "Back-end God",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Hugo",
    email: "hugo@gmail.com",
    password: "123456",
    age: 28,
    description: "DE OUF",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Jerome",
    email: "jerome@gmail.com",
    password: "123456",
    age: 38,
    description: "On va à La Piste les gars?",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Maelie",
    email: "maelie@gmail.com",
    password: "123456",
    age: 22,
    description: "On va au Berthom les gars?",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_female_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Eva",
    email: "eva@gmail.com",
    password: "123456",
    age: 25,
    description: "Non mais sans déconner",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_female_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Kevin",
    email: "kevin@gmail.com",
    password: "123456",
    age: 30,
    description: "C'est habile!",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Louis",
    email: "louis@gmail.com",
    password: "123456",
    age: 30,
    description: "Ok",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Gwendal",
    email: "gwendal@gmail.com",
    password: "123456",
    age: 25,
    description: "Pushez sur Heroku les gars!",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
  User.create!(
    username: "Valentin THE Boss",
    email: "valentin@gmail.com",
    password: "123456",
    age: 36,
    description: "Demandez a vos ex si Le Wagon ca les interesse",
    latitude: rand(48.094380..48.136752),
    longitude: -rand(1.629610..1.703168),
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: @bar.id
  )
end

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

#seed_games()

# ------------------------------------------------------------------------------
# SCORES SEED
# ------------------------------------------------------------------------------

def seed_score
  @users = User.all
  @users.each do |user|
    score = rand(1...100)
    Score.create!(
      score: score,
      bar: Bar.find_by(id: user.nearest_bar_id),
      user: user
    )
    user.score = score
    user.save
    puts("Seeded Score ##{Score.count} / #{User.count}")
  end
end

# ------------------------------------------------------------------------------
# DEMO SEED /!\ NO TESTING /!\
# ------------------------------------------------------------------------------

def seed_rennes
  lapiste = Bar.find_by(name: "La Piste")
  lapiste.description = "La Piste à Rennes est un lieu animé et convivial, idéal pour une soirée détendue entre amis. L'ambiance décontractée, la musique entraînante et la sélection de boissons variée en font un choix populaire."
  lapiste.save
  lapisterUsers = User.where(nearest_bar_id: lapiste.id)
  lapisterUsers.each do |user|
    user.nearest_bar_id = Bar.first
    user.save
  end

  knnll = User.find_by(email: "knnll@gmail.com")
  knnll.latitude = lapiste.latitude
  knnll.longitude = lapiste.longitude
  knnll.nearest_bar_id = lapiste.id
  knnll.save

  romain = User.find_by(email: "romain@gmail.com")
  romain.latitude = lapiste.latitude
  romain.longitude = lapiste.longitude
  romain.nearest_bar_id = lapiste.id
  romain.save

  florian = User.find_by(email: "florian@gmail.com")
  florian.latitude = lapiste.latitude
  florian.longitude = lapiste.longitude
  florian.nearest_bar_id = lapiste.id
  florian.save

  marine = User.find_by(email: "marine@gmail.com")
  marine.latitude = lapiste.latitude
  marine.longitude = lapiste.longitude
  marine.nearest_bar_id = lapiste.id
  marine.save

  perrine = User.find_by(email: "perrine@gmail.com")
  perrine.latitude = lapiste.latitude
  perrine.longitude = lapiste.longitude
  perrine.nearest_bar_id = lapiste.id
  perrine.save

  mathieu = User.find_by(email: "mathieu@gmail.com")
  mathieu.latitude = lapiste.latitude
  mathieu.longitude = lapiste.longitude
  mathieu.nearest_bar_id = lapiste.id
  mathieu.save

  cedric = User.find_by(email: "cedric@gmail.com")
  cedric.latitude = lapiste.latitude
  cedric.longitude = lapiste.longitude
  cedric.nearest_bar_id = lapiste.id
  cedric.save

  jj = User.find_by(email: "jj@gmail.com")
  jj.latitude = lapiste.latitude
  jj.longitude = lapiste.longitude
  jj.nearest_bar_id = lapiste.id
  jj.save

  hugo = User.find_by(email: "hugo@gmail.com")
  hugo.latitude = lapiste.latitude
  hugo.longitude = lapiste.longitude
  hugo.nearest_bar_id = lapiste.id
  hugo.save

  lomig = User.find_by(email: "lomig@gmail.com")
  lomig.latitude = lapiste.latitude
  lomig.longitude = lapiste.longitude
  lomig.nearest_bar_id = lapiste.id
  lomig.save

  kevin = User.find_by(email: "kevin@gmail.com")
  kevin.latitude = lapiste.latitude
  kevin.longitude = lapiste.longitude
  kevin.nearest_bar_id = lapiste.id
  kevin.save

  jerome = User.find_by(email: "jerome@gmail.com")
  jerome.latitude = lapiste.latitude
  jerome.longitude = lapiste.longitude
  jerome.nearest_bar_id = lapiste.id
  jerome.save

  eva = User.find_by(email: "eva@gmail.com")
  eva.latitude = lapiste.latitude
  eva.longitude = lapiste.longitude
  eva.nearest_bar_id = lapiste.id
  eva.save

  maelie = User.find_by(email: "maelie@gmail.com")
  maelie.latitude = lapiste.latitude
  maelie.longitude = lapiste.longitude
  maelie.nearest_bar_id = lapiste.id
  maelie.save

  gwendal = User.find_by(email: "gwendal@gmail.com")
  gwendal.latitude = lapiste.latitude
  gwendal.longitude = lapiste.longitude
  gwendal.nearest_bar_id = lapiste.id
  gwendal.save

  louis = User.find_by(email: "louis@gmail.com")
  louis.latitude = lapiste.latitude
  louis.longitude = lapiste.longitude
  louis.nearest_bar_id = lapiste.id
  louis.save

  valentin = User.find_by(email: "valentin@gmail.com")
  valentin.latitude = lapiste.latitude
  valentin.longitude = lapiste.longitude
  valentin.nearest_bar_id = lapiste.id
  valentin.save

  puts("Seeded Rennes")
end

def seed_nantes
  berthom = Bar.find_by(name: "Les BerThoM")
  berthom.description = "Quand on aime on ne compte pas ! Et nous, on aime beaucoup vous accueillir dans nos établissements. Depuis 1994 on oeuvre à créer une jolie petite famille. Chaque établissement a sa propre identité et est à l'image des gens qui y travaillent et de ceux qui le font exister (on parle de vous là)."
  berthom.save
  berthomrUsers = User.where(nearest_bar_id: berthom.id)
  berthomrUsers.each do |user|
    user.nearest_bar_id = Bar.first
    user.save
  end

  knnll = User.find_by(email: "knnll@gmail.com")
  knnll.latitude = berthom.latitude
  knnll.longitude = berthom.longitude
  knnll.nearest_bar_id = berthom.id
  knnll.save

  romain = User.find_by(email: "romain@gmail.com")
  romain.latitude = berthom.latitude
  romain.longitude = berthom.longitude
  romain.nearest_bar_id = berthom.id
  romain.save

  florian = User.find_by(email: "florian@gmail.com")
  florian.latitude = berthom.latitude
  florian.longitude = berthom.longitude
  florian.nearest_bar_id = berthom.id
  florian.save

  marine = User.find_by(email: "marine@gmail.com")
  marine.latitude = berthom.latitude
  marine.longitude = berthom.longitude
  marine.nearest_bar_id = berthom.id
  marine.save

  perrine = User.find_by(email: "perrine@gmail.com")
  perrine.latitude = berthom.latitude
  perrine.longitude = berthom.longitude
  perrine.nearest_bar_id = berthom.id
  perrine.save

  mathieu = User.find_by(email: "mathieu@gmail.com")
  mathieu.latitude = berthom.latitude
  mathieu.longitude = berthom.longitude
  mathieu.nearest_bar_id = berthom.id
  mathieu.save

  cedric = User.find_by(email: "cedric@gmail.com")
  cedric.latitude = berthom.latitude
  cedric.longitude = berthom.longitude
  cedric.nearest_bar_id = berthom.id
  cedric.save

  jj = User.find_by(email: "jj@gmail.com")
  jj.latitude = berthom.latitude
  jj.longitude = berthom.longitude
  jj.nearest_bar_id = berthom.id
  jj.save

  hugo = User.find_by(email: "hugo@gmail.com")
  hugo.latitude = berthom.latitude
  hugo.longitude = berthom.longitude
  hugo.nearest_bar_id = berthom.id
  hugo.save

  lomig = User.find_by(email: "lomig@gmail.com")
  lomig.latitude = berthom.latitude
  lomig.longitude = berthom.longitude
  lomig.nearest_bar_id = berthom.id
  lomig.save

  kevin = User.find_by(email: "kevin@gmail.com")
  kevin.latitude = berthom.latitude
  kevin.longitude = berthom.longitude
  kevin.nearest_bar_id = berthom.id
  kevin.save

  jerome = User.find_by(email: "jerome@gmail.com")
  jerome.latitude = berthom.latitude
  jerome.longitude = berthom.longitude
  jerome.nearest_bar_id = berthom.id
  jerome.save

  eva = User.find_by(email: "eva@gmail.com")
  eva.latitude = berthom.latitude
  eva.longitude = berthom.longitude
  eva.nearest_bar_id = berthom.id
  eva.save

  maelie = User.find_by(email: "maelie@gmail.com")
  maelie.latitude = berthom.latitude
  maelie.longitude = berthom.longitude
  maelie.nearest_bar_id = berthom.id
  maelie.save

  gwendal = User.find_by(email: "gwendal@gmail.com")
  gwendal.latitude = berthom.latitude
  gwendal.longitude = berthom.longitude
  gwendal.nearest_bar_id = berthom.id
  gwendal.save

  louis = User.find_by(email: "louis@gmail.com")
  louis.latitude = berthom.latitude
  louis.longitude = berthom.longitude
  louis.nearest_bar_id = berthom.id
  louis.save

  valentin = User.find_by(email: "valentin@gmail.com")
  valentin.latitude = lapiste.latitude
  valentin.longitude = lapiste.longitude
  valentin.nearest_bar_id = lapiste.id
  valentin.save

  puts("Seeded Nantes")
end

def reset_demo_scores
  lapiste = Bar.find_by(name: "La Piste")
  berthom = Bar.find_by(name: "Les BerThoM")
  knnll = User.find_by(email: "knnll@gmail.com")
  Score.where(user: knnll).destroy
  knnll.score = 90
  knll.save
  Score.create!(
    score: 90,
    bar: lapiste,
    user: knnll.score
  )
  Score.create!(
    score: 90,
    bar: berthom,
    user: knnll.score
  )
  romain = User.find_by(email: "romain@gmail.com")
  Score.where(user: romain).destroy
  romain.score = 70
  romain.save
  Score.create!(
    score: 70,
    bar: lapiste,
    user: romain.score
  )
  Score.create!(
    score: 70,
    bar: berthom,
    user: romain.score
  )
  florian = User.find_by(email: "florian@gmail.com")
  Score.where(user: florian).destroy
  florian.score = 71
  florian.save
  Score.create!(
    score: 71,
    bar: lapiste,
    user: florian.score
  )
  Score.create!(
    score: 71,
    bar: berthom,
    user: florian.score
  )
  User.find_by(email: "marine@gmail.com")
  Score.where(user: marine).destroy
  marine.score = 50
  marine.save
  Score.create!(
    score: 50,
    bar: lapiste,
    user: marine.score
  )
  Score.create!(
    score: 50,
    bar: berthom,
    user: marine.score
  )
  perrine = User.find_by(email: "perrine@gmail.com")
  Score.where(user: perrine).destroy
  perrine.score = 74
  perrine.save
  Score.create!(
    score: 74,
    bar: lapiste,
    user: perrine.score
  )
  Score.create!(
    score: 74,
    bar: berthom,
    user: perrine.score
  )
  mathieu = User.find_by(email: "mathieu@gmail.com")
  Score.where(user: mathieu).destroy
  mathieu.score = 20
  mathieu.save
  Score.create!(
    score: 20,
    bar: lapiste,
    user: mathieu.score
  )
  Score.create!(
    score: 20,
    bar: berthom,
    user: mathieu.score
  )
  cedric = User.find_by(email: "cedric@gmail.com")
  Score.where(user: cedric).destroy
  cedric.score = 1
  cedric.save
  Score.create!(
    score: 1,
    bar: lapiste,
    user: cedric.score
  )
  Score.create!(
    score: 1,
    bar: berthom,
    user: cedric.score
  )
  lomig = User.find_by(email: "lomig@gmail.com")
  Score.where(user: lomig).destroy
  lomig.score = 40
  lomig.save
  Score.create!(
    score: 40,
    bar: lapiste,
    user: lomig.score
  )
  Score.create!(
    score: 40,
    bar: berthom,
    user: lomig.score
  )
  jj = User.find_by(email: "jj@gmail.com")
  Score.where(user: jj).destroy
  Score.create!(
    score: 72,
    bar: lapiste,
    user: jj
  )
  Score.create!(
    score: 72,
    bar: berthom,
    user: jj
  )
  hugo = User.find_by(email: "hugo@gmail.com")
  Score.where(user: hugo).destroy
  Score.create!(
    score: 72,
    bar: lapiste,
    user: hugo
  )
  Score.create!(
    score: 72,
    bar: berthom,
    user: hugo
  )
  kevin = User.find_by(email: "kevin@gmail.com")
  Score.where(user: kevin).destroy
  Score.create!(
    score: 52,
    bar: lapiste,
    user: kevin
  )
  Score.create!(
    score: 52,
    bar: berthom,
    user: kevin
  )
  jerome = User.find_by(email: "jerome@gmail.com")
  Score.where(user: jerome).destroy
  Score.create!(
    score: 73,
    bar: lapiste,
    user: jerome
  )
  Score.create!(
    score: 73,
    bar: berthom,
    user: jerome
  )
  eva = User.find_by(email: "eva@gmail.com")
  Score.where(user: eva).destroy
  Score.create!(
    score: 68,
    bar: lapiste,
    user: eva
  )
  Score.create!(
    score: 68,
    bar: berthom,
    user: eva
  )
  maelie = User.find_by(email: "maelie@gmail.com")
  Score.where(user: maelie).destroy
  Score.create!(
    score: 37,
    bar: lapiste,
    user: maelie
  )
  Score.create!(
    score: 37,
    bar: berthom,
    user: maelie
  )
  gwendal = User.find_by(email: "gwendal@gmail.com")
  Score.where(user: gwendal).destroy
  Score.create!(
    score: 24,
    bar: lapiste,
    user: gwendal
  )
  Score.create!(
    score: 24,
    bar: berthom,
    user: gwendal
  )
  louis = User.find_by(email: "louis@gmail.com")
  Score.where(user: louis).destroy
  Score.create!(
    score: 51,
    bar: lapiste,
    user: louis
  )
  Score.create!(
    score: 51,
    bar: berthom,
    user: louis
  )
  valentin = User.find_by(email: "valentin@gmail.com")
  Score.where(user: valentin).destroy
  Score.create!(
    score: 99,
    bar: lapiste,
    user: valentin
  )
  Score.create!(
    score: 99,
    bar: berthom,
    user: valentin
  )
end

# ------------------------------------------------------------------------------
# METHODS
# ------------------------------------------------------------------------------

remove_seed()
seed_images()
seed_bars()
seed_users()
seed_wagon()
seed_games()
seed_score()

seed_rennes()
#seed_nantes()

reset_demo_scores()
