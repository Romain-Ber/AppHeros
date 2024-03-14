knnll = User.find_by(username: "Knnll")
lapiste = Bar.find_by(name: "La Piste")
knnll.latitude = lapiste.latitude
knnll.longitude = lapiste.longitude
knnll.save

romain = User.find_by(email: "romain@gmail.com")
romain.latitude = lapiste.latitude
romain.longitude = lapiste.longitude
romain.save

lapiste.description = "La Piste  à Rennes est un lieu animé et convivial, idéal pour une soirée détendue entre amis. L'ambiance décontractée, la musique entraînante et la sélection de boissons variée en font un choix populaire."
lapiste.save

lapisterUsers = User.find_by(nearest_bar_id: lapiste.id)
lapisterUsers.each do |user|
  70.times do
    Score.create!(
      score: rand(1..5),
      bar: lapiste,
      user: user
    )
  end
end
