class ShopMailer < ActionMailer::Base
  default from: 'Super Shop <admin@shop.com>'

  def charge_money(user)
    @user = user
    mail(to: @user.email, subject: 'Please make a payment for subscription!')
  end

  def new_user(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to the Shop!')
  end

  def new_receipt(user, order, token_key, time)
    @user = user
    @order = order
    @token_key = token_key
    @time = time

    title_en = 'Complete payment from Super Shop'
    mail(to: @user.email, subject: title_en)
  end

  def confirm_order(email, new_user, token_key, time, confirm_cart, language)
    @language = language
    @email = email
    @token_key = token_key
    @new_user = new_user
    @confirm_cart = confirm_cart
    @time = time

    @product = @confirm_cart.order_items.first.product

    title_en = 'Confirm enroll course from Enziin Academy - Code confirm: ' + @token_key

    mail(to: @email, subject: title_en)
  end
end
