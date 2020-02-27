class Mention < ApplicationRecord
    validates :user_id, presence: true
    validates :micropost_id, presence: true
    belongs_to :micropost
    belongs_to :user
end
