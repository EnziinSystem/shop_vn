class Slide < ApplicationRecord

  validates :align, presence: true
  validates :content, presence: true
  validates :image, presence: true

  has_attached_file :image, :styles => {:medium => '1920*960>', :thumb => '430x240>'}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 5.megabytes

end
