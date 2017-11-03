class Product < ApplicationRecord
  require 'babosa'
  require 'rubygems'
  require 'nokogiri'

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  has_one :landing_page

  validates :category, presence: true
  validates :name, presence: true
  validates :content, presence: true
  validates :price, presence: true

  has_attached_file :image, :styles => {:medium => '850*480>', :thumb => '430x240>'}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 2.megabytes

  mount_uploader :data_file, DataFileUploader

  before_save :replace_image_tag
  before_destroy :ensure_not_ref_by_order_item

  def short_content
    article_html = Nokogiri::HTML(content).text

    if article_html.length > 256
      i = 256
      while (article_html[i] != ' ') && (i <= 300)
        i += 1
      end
      article_html[0..i] + '...'
    else
      article_html
    end
  end

  def percent_sale_off
    percent = ((older_price - price) * 100 / older_price).to_i
    'Save ' + percent.to_s + '%'
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :vietnamese).to_s
  end

  def should_generate_new_friendly_id?
    slug.blank? || self.name_changed?
  end

  private

  def ensure_not_ref_by_order_item
    product = OrderItem.all.find_by(product_id: self.id)
    if product.present?
      errors.add(:base, 'Order items present')
      throw :abort
    end
  end

  def replace_image_tag
    image_content = Nokogiri::HTML(self.content)
    array_images = image_content.css('img')

    array_images.each do |image|
      image['style'] = "max-width: 100%; width: auto; height: auto;"
      source_img = image['src']
      source_img = source_img.gsub("/content_", '/')
      image['src'] = source_img
    end

    write_attribute(:content, image_content)
  end
end
