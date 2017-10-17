module ApplicationHelper
  require 'uri'

  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=350"
  end
end
