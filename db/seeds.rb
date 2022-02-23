i = 1
while(i < 6)do
  User.create(name: "Student #{i}", email: "student+#{i}@gmail.com", password: "12345678", gender: "male", job: "student")
  User.create(name: "Teacher #{i}", email: "teacher+#{i}@gmail.com", password: "12345678", gender: "female", job: "teacher")
  i+=1
end
User.first.groups.create!(name: "room room", code: "XCVBNMQW", admin_id: User.first.id)

while(i < 12)do
  user = User.find_by(id: i)
  group =  user.groups.create!(name: "room #{i} #{user.name}", code: Group.first.random_code, admin_id: user.id) if user
  i+=1
end

while(i < 12)do
  user = User.find_by(id: i)
  group = Group.find_by(id: i)
  group.users << user if user.present? && group.present? && ((group.users.include? user) == false)
  i+=1
end

while(i < 5)do
  user = User.find_by(id: i )
  group = Group.find_by(id: i +1)
  group.users << user if user.present? && group.present? && ((group.users.include? user) == false)
  i+=1
end




