class Gram < ApplicationRecord
	validates :message, presence: true, length: { minimum: 1}
	validates :picture, presence: true
	mount_uploader :picture, PictureUploader
	belongs_to :user
end
