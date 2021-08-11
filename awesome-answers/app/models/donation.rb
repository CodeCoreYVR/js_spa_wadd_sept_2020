class Donation < ApplicationRecord 
    belongs_to :giver, class_name: "User"
    belongs_to :receiver, class_name: "User"
    belongs_to :answer
end