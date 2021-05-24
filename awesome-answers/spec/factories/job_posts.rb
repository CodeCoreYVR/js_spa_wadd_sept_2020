# To generate this factory runs:
# rails g factory_bot:model job_post

# To use this factory:

# This will generate a new job_post instance but not save it to the database.
# Similar to ".new"
# Factory.build(:job_post)

# This will generate a new job_post instance and save it to the database.
# Similar to ".create"
# Factory.create(:job_post)

# We can override the FactoryBot attributes by passing a hash as a second argument:
# Factory.create(:job_post, title: "Software Engineer")

# Returns a plain hash of the parameters required to create a JobPost
# FactoryBot.attributes_for(:job_post)

DESCRIPTION = "Lorem ipsum dolor sit amet consectetur adipisicing elit. Libero, voluptatem ipsam optio totam provident suscipit sequi dolorem aliquid expedita corporis corrupti id sint fugiat debitis eligendi facere quasi saepe ea eum cum odit animi? Earum molestias architecto a quidem suscipit!"

# All of your factories must always generate valid instances of your models
FactoryBot.define do
  factory :job_post do
    # Sequence is a method provided by factory_bot which injects a variable "n"
    # which is a number that increments on every object that it generates so
    # we can it to make sure all the instances created are unique.
    sequence(:title) { |n| Faker::Job.title + n.to_s }
    
    # In the factory file, we run a method named after the column name of a job_post
    # and pass it a block which will generate our fake data
    description { DESCRIPTION } # Make sure description is over 100 characters in length

    location { Faker::Address.city }
    min_salary { rand(30_000..100_000) }
    max_salary { rand(100_000..200_000) }

    # This will create a user using the user factory before creating the job_post
    # This is necessary to pass the validation added by "belongs_to :user" 
    association(:user, factory: :user)
  end
end

