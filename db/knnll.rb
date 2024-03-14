knnll = User.find_by(username: "Knnll")
lapiste = Bar.find_by(name: "La Piste")
knnll.latitude = lapiste.latitude
knnll.longitude = lapiste.longitude
knnll.save

lapiste.description

randomBar = Bar.first
lapisterUsers = User.find_by(nearest_bar_id: lapiste.id)
lapisterUsers.each do |user|
  user.nearest_bar_id = randomBar.id
  user.save
end
