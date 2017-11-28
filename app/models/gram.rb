class Gram < ApplicationRecord
	validates :message, presence: true, length: { minimum: 1}

	belongs_to :user
end
