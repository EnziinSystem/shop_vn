class OrderItem < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :cart
  belongs_to :order, optional: true

  def total_price
    product = Product.find(self.product.id)
    if product.present?
      product.price * self.quantity
    else
      0
    end
  end
end
