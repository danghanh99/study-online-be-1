Group.create!(name: "room room", code: "XCVBNMQW")
default_url = "https://meet.jit.si/"
i = 0
while(i < 6)do
  user1 = User.create(name: "Student #{i}", email: "student+#{i}@gmail.com", password: "12345678", gender: "male", job: "student")
  group1 = user1.groups.create!(name: "room #{user1.name}", code: Group.first.random_code, admin_id: user1.id)
  user2 = User.create(name: "Teacher #{i}", email: "teacher+#{i}@gmail.com", password: "12345678", gender: "female", job: "teacher")
  group2 = user2.groups.create!(name: "room #{user2.name}", code: Group.first.random_code, admin_id: user2.id)
  group1.users << user2
  group2.users << user1
  group1.update!(url: default_url + group1.code, members_number: group1.users.count, description: user1.name)
  group2.update!(url: default_url + group2.code, members_number: group1.users.count, description: user2.name)
  i+=1
end
Group.first.destroy
