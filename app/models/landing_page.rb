class LandingPage < ApplicationRecord
  belongs_to :product

  validates :product, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates :cover_image, presence: true

  has_attached_file :cover_image, :styles => {:medium => '1920*960>', :thumb => '430x240>'}
  validates_attachment_content_type :cover_image, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :cover_image, less_than: 5.megabytes

end
