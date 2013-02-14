class Identity < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id
  belongs_to :user

  def self.find_or_create_with_omniauth(auth)
    identity = find_by_provider_and_uid(auth['provider'], auth['uid'])
    if identity.nil?
      identity = create_with_omniauth(auth)
    end
    identity
  end

  def self.create_with_omniauth(auth)
    create! do |identity|
      identity.uid = auth['uid']
      identity.provider = auth['provider']
    end
  end
end
