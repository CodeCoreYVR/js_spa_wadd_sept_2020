# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = "supersecret"

Tagging.delete_all
Tag.delete_all
Like.delete_all
Answer.delete_all
Question.delete_all
User.delete_all

super_user = User.create(
  first_name: "Jon",
  last_name: "Snow",
  email: "js@winterfell.gov",
  password: PASSWORD,
  is_admin: true,
)

10.times do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: PASSWORD,
  )
end

users = User.all

20.times do
  Tag.create(
    name: Faker::Book.genre
  )
end

tags = Tag.all

200.times do
  created_at = Faker::Date.backward(365 * 5)

  # Faker is a module. We are accessing classes on the module
  # that will create fake data. No need to require the faker gem at the
  # top of this script because we can access all gems in the Gemfile
  # from anywhere.
  q = Question.create(
    title: Faker::Hacker.say_something_smart,
    body: Faker::ChuckNorris.fact,
    view_count: rand(100_000),
    created_at: created_at,
    updated_at: created_at,
    # We can use the user instance for the "user" attribute rather than using "user_id"
    user: users.sample,
  )
  if q.valid?
    # With the writer q.answers=(objects), the answer instances that are being assigned
    # to the question will be saved to the database and associated to the question
    q.answers = rand(0..15).times.map do
      Answer.new(
        body: Faker::GreekPhilosophers.quote,
        user: users.sample,
      )
    end
    q.likers = users.shuffle.slice(0, rand(users.count))
    q.tags = tags.shuffle.slice(0, rand(10))
  end
end

puts Cowsay.say("Generated #{Question.count} questions", :koala)
puts Cowsay.say("Generated #{Answer.count} answers", :stegosaurus)
puts Cowsay.say("Generated #{User.count} users", :ghostbusters)
puts Cowsay.say("Generated #{Like.count} likes", :tux)
puts Cowsay.say("Generated #{Tag.count} tags", :bunny)
puts Cowsay.say("Sign in with #{super_user.email} and password: #{PASSWORD}", :cow)