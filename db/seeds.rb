i = 1
while(i < 6)do
  User.create(name: "Student #{i}", email: "student+#{i}@gmail.com", password: "12345678", gender: "male", job: "student")
  User.create(name: "Teacher #{i}", email: "teacher+#{i}@gmail.com", password: "12345678", gender: "female", job: "teacher")
  i+=1
end