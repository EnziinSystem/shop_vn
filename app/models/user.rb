class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable, :timeoutable, :lockable


  def self.find_for_google_oauth2(provider, uid, name, email, signed_in_resource = nil)
    user = User.where(:provider => provider, :uid => uid).first

    if user
      return user
    else
      registered_user = User.where(:email => email).first
      if registered_user
        return registered_user
      else
        user = User.new(
            name: name,
            provider: provider,
            email: email,
            uid: uid,
            password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.skip_confirmation_notification!
        user.save
        return user
      end
    end
  end

  def self.find_for_facebook_oauth(provider, uid, name, email, signed_in_resource = nil)
    user = User.where(:provider => provider, :uid => uid).first

    if user
      return user
    else
      registered_user = User.where(:email => email).first
      if registered_user
        return registered_user
      else
        user = User.new(
            name: name,
            provider: provider,
            email: email,
            uid: uid,
            password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.skip_confirmation_notification!
        user.save
        return user
      end
    end
  end

  def self.find_for_twitter_oauth(provider, uid, name, email, signed_in_resource = nil)
    user = User.where(:provider => provider, :uid => uid).first

    if user
      return user
    else
      registered_user = User.where(:email => email).first
      if registered_user
        return registered_user
      else
        user = User.new(
            name: name,
            provider: provider,
            email: email,
            uid: uid,
            password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.skip_confirmation_notification!
        user.save
        return user
      end
    end
  end

end
