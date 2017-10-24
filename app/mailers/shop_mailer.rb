class ShopMailer < ActionMailer::Base
  default from: 'Super Shop <admin@shop.com>'

  def new_user(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to the Shop!')
  end
end
