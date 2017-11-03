class SendEmailMonthlyJob < ApplicationJob
  queue_as :default

  def perform(user)
    ShopMailer.charge_money(user).deliver_later(wait: 5.second)
  end
end
