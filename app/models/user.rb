class User < ActiveRecord::Base
  attr_accessible :name, :email, :guest, :gender

  has_many :assessments
  has_many :identities

  def self.create_guest
    guest_id = rand(36**10).to_s(36)

    # Create the user as a guest
    user = User.create!(guest: true, name: "User_#{guest_id}")

    # Create an guest identity for the user
    identity = Identity.create(provider: 'guest', uid: guest_id)
    identity.user = user
    identity.save!
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.guest = false
      user.name = auth['info']['name']
      user.email = auth['info']['email']
      user.gender = auth['info']['gender']
    end
  end

  def update_with_omniauth(auth)
    self.name = auth['info']['name']
    self.email = auth['info']['email']
    self.gender = auth['info']['gender']
    self.save!
  end
end
