class SendEmailOrderJob < ApplicationJob
  queue_as :default

  def perform(user, order, token_key, time)
    ShopMailer.new_receipt(user, order, token_key, time).deliver_later(wait: 10.second)
  end
end
