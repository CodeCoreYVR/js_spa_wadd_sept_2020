class User < ApplicationRecord
  # We'll set the option to nullify so if a user gets deleted, it won't delete
  # any of their associated questions or answers
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :job_posts, dependent: :nullify

  # "has_many" can take a "through" named argument to create a many-to-many
  # relationship cia another "has_many" declaration. The "through" corresponds
  # to the join table (plural) between the two tables that share the many-to-many. We 
  # also specify the "source" which is named after the model (singular).
  # "liked_questions" (plural) is not a column. It is the joint of all the questions
  # through the "likes" join table for this user instance. We can name this whatever
  # we went. user.liked_questions will give us all questions that are liked by this user.
  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  has_secure_password
  # Provides user authentication features on the model that it is
  # called in. It requires a column named "password_digest" to store
  # hashed passwords, and it requires the bcrypt gem.
  # - It adds attribute accessors for "password" and "password_confirmation".
  # - If "password_confirmation" exists then it makes sure it matches 
  #   with "password". "password_confirmation" is optional.
  # - It will add a presence validation for the "password" field.
  # - It will save passwords assigned to "password" using bcrypt to hash
  #   and store it in the "password_digest" column.
  # - It will add the "authenticate" method to verify a user's password. bcrypt will
  #   verify the password by hashing it and comparing it to the "password_digest".
  #   If the password was correct it returns the user, otherwise it returns false.
  validates(
    :email, 
    presence: true, 
    uniqueness: true,
    format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
  )

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
