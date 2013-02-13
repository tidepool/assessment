class User < ActiveRecord::Base
  attr_accessible :name, :anonymous
  has_many :assessments
  has_many :identities

  def self.create_anonymous
  	create! do |user|
  		user.anonymous = true
  		user.name = "User_#{rand(10000000)}"
  	end
  end

	def self.from_omniauth(auth, anonymous_user)
    if anonymous_user && anonymous_user.anonymous
      convert_anonymous_to_authenticated(auth, anonymous_user)
    else
      find_by_provider_and_uid(auth['provider'], auth['uid']) || create_with_omniauth(auth)
    end
  end

  def self.convert_anonymous_to_authenticated(auth, anonymous_user)
    anonymous_user.anonymous = false
    anonymous_user.provider = auth['provider']
    anonymous_user.uid = auth['uid']
    anonymous_user.name = auth['info']['name']
    anonymous_user.save!
    anonymous_user  
  end

  def self.create_with_omniauth(auth)
  	create! do |user|
  		user.anonymous = false
  		user.provider = auth['provider']
  		user.uid = auth['uid']
  		user.name = auth['info']['name']
  	end
	end
end
