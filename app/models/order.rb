class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  after_update :send_receipt_email

  def send_receipt_email
    @user = User.find_by_email(self.user.email)
    @order = self

    time = Time.now.to_i

    joinMd5 = "#{@user.email}-#{time.to_s}-#{ENV['SECRET_CODE_CREATE_ORDER_FROM_EMAIL']}"
    token_key = Digest::MD5.hexdigest joinMd5
    token_key = token_key.upcase

    if @order.status == 'Complete' && @user.present?
      SendEmailOrderJob.perform_later(@user, @order, token_key, time)
    end

  end

  def total_in_vietnamese
    self.total * (ENV['RATE_USD_TO_VND']).to_f
  end

  def update_total_price
    self.total = self.order_items.to_a.sum {|item| item.total_price}
  end

  def add_order_items_from_cart(cart)
    cart.order_items.each do |item|
      item.cart_id = nil
      self.order_items << item
    end
  end
end
