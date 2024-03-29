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
    gender: gender,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    nearest_bar_id: @bar.id,
    score: rand(1..110)
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
    score = rand(1..100)
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
# RENNES DEMO SEED /!\ NO TESTING /!\
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

# ------------------------------------------------------------------------------
# NANTES DEMO SEED /!\ NO TESTING /!\
# ------------------------------------------------------------------------------

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
  valentin.latitude = berthom.latitude
  valentin.longitude = berthom.longitude
  valentin.nearest_bar_id = berthom.id
  valentin.save

  puts("Seeded Nantes")
end

# ------------------------------------------------------------------------------
# EPITECH DEMO SEED /!\ NO TESTING /!\
# ------------------------------------------------------------------------------

def seed_epitech
  yermat = Bar.find_by(name: "Yermat")
  yermat.description = "Quand on aime on ne compte pas ! Et nous, on aime beaucoup vous accueillir dans nos établissements. Depuis 1994 on oeuvre à créer une jolie petite famille. Chaque établissement a sa propre identité et est à l'image des gens qui y travaillent et de ceux qui le font exister (on parle de vous là)."
  yermat.save
  yermatrUsers = User.where(nearest_bar_id: yermat.id)
  yermatrUsers.each do |user|
    user.nearest_bar_id = Bar.first
    user.save
  end

  romain = User.find_by(email: "romain@gmail.com")
  romain.latitude = yermat.latitude
  romain.longitude = yermat.longitude
  romain.nearest_bar_id = yermat.id
  romain.score = 56
  romain.save
  Score.create!(
    user_id: romain.id,
    bar: yermat,
    score: romain.score
  )

  florian = User.find_by(email: "florian@gmail.com")
  florian.latitude = yermat.latitude
  florian.longitude = yermat.longitude
  florian.nearest_bar_id = yermat.id
  florian.score = 78
  florian.save
  Score.create!(
    user_id: florian.id,
    bar: yermat,
    score: florian.score
  )

  marine = User.find_by(email: "marine@gmail.com")
  marine.latitude = yermat.latitude
  marine.longitude = yermat.longitude
  marine.nearest_bar_id = yermat.id
  marine.score = 50
  marine.save
  Score.create!(
    user_id: marine.id,
    bar: yermat,
    score: marine.score
  )

  christelle = User.create!(
    username: "Christelle",
    email: "christelle@gmail.com",
    password: "123456",
    age: 36,
    description: "Directrice Epitech",
    latitude: yermat.latitude,
    longitude: yermat.longitude,
    first_login: false,
    status: "available",
    image_id: image_id = @img_female_users.sample,
    gender: "female",
    nearest_bar_id: yermat.id,
    score: rand(1..110)
  )
  Score.create!(
    user_id: christelle.id,
    bar: yermat,
    score: christelle.score
  )

  pascal = User.create!(
    username: "Pascal",
    email: "pascal@gmail.com",
    password: "123456",
    age: 24,
    description: "Enseignant Epitech",
    latitude: yermat.latitude,
    longitude: yermat.longitude,
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: yermat.id,
    score: 76
  )
  Score.create!(
    user_id: pascal.id,
    bar: yermat,
    score: pascal.score
  )

  marvin = User.create!(
    username: "Marvin",
    email: "marvin@gmail.com",
    password: "123456",
    age: 25,
    description: "Directeur Epitech",
    latitude: yermat.latitude,
    longitude: yermat.longitude,
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: yermat.id,
    score: 62
  )
  Score.create!(
    user_id: marvin.id,
    bar: yermat,
    score: marvin.score
  )

  curtis = User.create!(
    username: "Curtis",
    email: "curtis@gmail.com",
    password: "123456",
    age: 30,
    description: "Intervenant Epitech",
    latitude: yermat.latitude,
    longitude: yermat.longitude,
    first_login: false,
    status: "available",
    image_id: image_id = @img_male_users.sample,
    gender: "male",
    nearest_bar_id: yermat.id,
    score: 64
  )
  Score.create!(
    user_id: curtis.id,
    bar: yermat,
    score: curtis.score
  )

  puts("Seeded Epitech")
end

# ------------------------------------------------------------------------------
# SCORE DEMO SEED /!\ NO TESTING /!\
# ------------------------------------------------------------------------------

def reset_demo_scores
  lapiste = Bar.find_by(name: "La Piste")
  berthom = Bar.find_by(name: "Les BerThoM")
  knnll = User.find_by(email: "knnll@gmail.com")
  Score.where(user_id: knnll).destroy_all
  knnll.score = 56
  knnll.save
  Score.create!(
    user_id: knnll.id,
    bar: lapiste,
    score: knnll.score
  )
  Score.create!(
    user_id: knnll.id,
    bar: berthom,
    score: knnll.score
  )
  romain = User.find_by(email: "romain@gmail.com")
  Score.where(user_id: romain).destroy_all
  romain.score = 78
  romain.save
  Score.create!(
    user_id: romain.id,
    bar: lapiste,
    score: romain.score
  )
  Score.create!(
    user_id: romain.id,
    bar: berthom,
    score: romain.score
  )
  florian = User.find_by(email: "florian@gmail.com")
  Score.where(user_id: florian).destroy_all
  florian.score = 73
  florian.save
  Score.create!(
    user_id: florian.id,
    bar: lapiste,
    score: florian.score
  )
  Score.create!(
    user_id: florian.id,
    bar: berthom,
    score: florian.score
  )
  marine = User.find_by(email: "marine@gmail.com")
  Score.where(user_id: marine).destroy_all
  marine.score = 50
  marine.save
  Score.create!(
    user_id: marine.id,
    bar: lapiste,
    score: marine.score
  )
  Score.create!(
    user_id: marine.id,
    bar: berthom,
    score: marine.score
  )
  perrine = User.find_by(email: "perrine@gmail.com")
  Score.where(user_id: perrine).destroy_all
  perrine.score = 74
  perrine.save
  Score.create!(
    user_id: perrine.id,
    bar: lapiste,
    score: perrine.score
  )
  Score.create!(
    user_id: perrine.id,
    bar: berthom,
    score: perrine.score
  )
  mathieu = User.find_by(email: "mathieu@gmail.com")
  Score.where(user_id: mathieu).destroy_all
  mathieu.score = 20
  mathieu.save
  Score.create!(
    user_id: mathieu.id,
    bar: lapiste,
    score: mathieu.score
  )
  Score.create!(
    user_id: mathieu.id,
    bar: berthom,
    score: mathieu.score
  )
  cedric = User.find_by(email: "cedric@gmail.com")
  Score.where(user_id: cedric).destroy_all
  cedric.score = 11
  cedric.save
  Score.create!(
    user_id: cedric.id,
    bar: lapiste,
    score: cedric.score
  )
  Score.create!(
    user_id: cedric.id,
    bar: berthom,
    score: cedric.score
  )
  lomig = User.find_by(email: "lomig@gmail.com")
  Score.where(user_id: lomig).destroy_all
  lomig.score = 40
  lomig.save
  Score.create!(
    user_id: lomig.id,
    bar: lapiste,
    score: lomig.score
  )
  Score.create!(
    user_id: lomig.id,
    bar: berthom,
    score: lomig.score
  )
  jj = User.find_by(email: "jj@gmail.com")
  Score.where(user_id: jj).destroy_all
  jj.score = 72
  jj.save
  Score.create!(
    user_id: jj.id,
    bar: lapiste,
    score: jj.score
  )
  Score.create!(
    user_id: jj.id,
    bar: berthom,
    score: jj.score
  )
  hugo = User.find_by(email: "hugo@gmail.com")
  Score.where(user_id: hugo).destroy_all
  hugo.score = 72
  hugo.save
  Score.create!(
    user_id: hugo.id,
    bar: lapiste,
    score: hugo.score
  )
  Score.create!(
    user_id: hugo.id,
    bar: berthom,
    score: hugo.score
  )
  kevin = User.find_by(email: "kevin@gmail.com")
  Score.where(user_id: kevin).destroy_all
  kevin.score = 52
  kevin.save
  Score.create!(
    user_id: kevin.id,
    bar: lapiste,
    score: kevin.score
  )
  Score.create!(
    user_id: kevin.id,
    bar: berthom,
    score: kevin.score
  )
  jerome = User.find_by(email: "jerome@gmail.com")
  Score.where(user_id: jerome).destroy_all
  jerome.score = 71
  jerome.save
  Score.create!(
    user_id: jerome.id,
    bar: lapiste,
    score: jerome.score
  )
  Score.create!(
    user_id: jerome.id,
    bar: berthom,
    score: jerome.score
  )
  eva = User.find_by(email: "eva@gmail.com")
  Score.where(user_id: eva).destroy_all
  eva.score = 68
  eva.save
  Score.create!(
    user_id: eva.id,
    bar: lapiste,
    score: eva.score
  )
  Score.create!(
    user_id: eva.id,
    bar: berthom,
    score: eva.score
  )
  maelie = User.find_by(email: "maelie@gmail.com")
  Score.where(user_id: maelie).destroy_all
  maelie.score = 37
  maelie.save
  Score.create!(
    user_id: maelie.id,
    bar: lapiste,
    score: maelie.score
  )
  Score.create!(
    user_id: maelie.id,
    bar: berthom,
    score: maelie.score
  )
  gwendal = User.find_by(email: "gwendal@gmail.com")
  Score.where(user_id: gwendal).destroy_all
  gwendal.score = 24
  gwendal.save
  Score.create!(
    user_id: gwendal.id,
    bar: lapiste,
    score: gwendal.score
  )
  Score.create!(
    user_id: gwendal.id,
    bar: berthom,
    score: gwendal.score
  )
  louis = User.find_by(email: "louis@gmail.com")
  Score.where(user_id: louis).destroy_all
  louis.score = 51
  louis.save
  Score.create!(
    user_id: louis.id,
    bar: lapiste,
    score: louis.score
  )
  Score.create!(
    user_id: louis.id,
    bar: berthom,
    score: louis.score
  )
  valentin = User.find_by(email: "valentin@gmail.com")
  Score.where(user_id: valentin).destroy_all
  valentin.score = 1
  valentin.save
  Score.create!(
    user_id: valentin.id,
    bar: lapiste,
    score: valentin.score
  )
  Score.create!(
    user_id: valentin.id,
    bar: berthom,
    score: valentin.score
  )
  puts "Seeded Demo Scores"
end

# ------------------------------------------------------------------------------
# IMG EPITECH
# ------------------------------------------------------------------------------

def seed_epitech_img
  christelle = User.find_by(email: "christelle@gmail.com")
  christelle.image_id = @img_female_users.sample
  christelle.save

  curtis = User.find_by(email: "curtis@gmail.com")
  curtis.image_id = @img_male_users.sample
  curtis.save

  pascal = User.find_by(email: "pascal@gmail.com")
  pascal.image_id = @img_male_users.sample
  pascal.save

  marvin = User.find_by(email: "marvin@gmail.com")
  marvin.image_id = @img_male_users.sample
  marvin.save
end

# ------------------------------------------------------------------------------
# METHODS
# ------------------------------------------------------------------------------

#remove_seed()
seed_images()
#seed_bars()
#seed_users()
#seed_wagon()
#seed_games()
#seed_score()
#seed_rennes()
#seed_nantes()
seed_epitech()
seed_epitech_img()
#reset_demo_scores()

# ------------------------------------------------------------------------------
# PATCH AREA /!\ BULLSHIT FOR WAGON DEMO RENNES/NANTES /!\
# ------------------------------------------------------------------------------

def bartypes
  @category = ["Bar", "Café", "Pub", "Bar à Bières", "Cave", "Bar à Cocktails"]
  Bar.all.each do |bar|
    bar.bar_type = @category.sample
    bar.save
  end
  lapiste = Bar.find_by(name: "La Piste")
  berthom = Bar.find_by(name: "Les BerThoM")
  lapiste.bar_type = "Bar à Bières"
  lapiste.save
  berthom.bar_type = "Bar à Bières"
  berthom.save
end

#bartypes()
