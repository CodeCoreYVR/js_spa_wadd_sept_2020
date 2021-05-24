class Like < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question_id, uniqueness: { scope: :user_id }
  # This validation created a scoped uniqueness. It means that 
  # there can only be one os the same question_id per user_id

  # id | question_id | user_id
  # 1  | 20          | 3     <- valid
  # 2  | 13          | 11    <- valid
  # 3  | 17          | 34    <- valid
  # 4  | 10          | 3     <- valid
  # 5  | 13          | 11    <- invalid
  # 6  | 10          | 34    <- valid
end
