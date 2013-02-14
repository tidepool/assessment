class User < OmniAuth::Identity::Models::ActiveRecord

  attr_accessible :name, :email, :guest, :gender, :password_digest, :password, :password_confirmation
  validates_presence_of :name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  has_many :assessments
  has_many :identities

  def self.create_guest
    create! do |user|
  		user.guest = true
  		user.name = "User_#{rand(10000000)}"
  	end
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.guest = false
      user.name = auth['info']['name']
      user.email = auth['info']['email']
      user.gender = auth['info']['gender']
    end
  end
end
