class SessionsController < ApplicationController
  # OmniAuth callback url does not correctly verify the rails authenticity token and so will destroy any session data
  # TODO: Investigate security implications here!
  skip_before_filter :verify_authenticity_token, only: :create

  def new
  end

  def create
    auth = request.env['omniauth.auth']

    @identity = Identity.find_or_create_with_omniauth(auth)

    if signed_in?
      if @identity.user == self.current_user
        # User is signed in so they are trying to link an identity with their
        # account. But we found the identity and the user associated with it
        # is the current user. So the identity is already associated with
        # this user. So let's display an error message.
        redirect_to redirect_url, notice: 'Already linked that account!'
      else
        # There is a guest_user or a user who registered with another identity
        # Associate this identity with the guest user -> Making the user full-registered
        @identity.user = current_user
        @identity.save()

        # User is no longer guest:
        # TODO: Figure out the Cookies
        self.current_user.update_with_omniauth(auth)

        redirect_to redirect_url, notice: 'Successfully linked that account!'
      end
    else
      if @identity.user.present?
        # The identity we found had a user associated with it so let's
        # just log them in here
        self.current_user = @identity.user
        redirect_to root_url, notice: 'Signed in!'
      else
        # We should not be hitting this when coming from an assessment,
        # because we always create a guest user for an assessment. But in the future
        # we may be authentication without hitting the assessment first.

        # No user associated with the identity so we need to create a new one
        user = User.create_with_omniauth(auth)
        self.current_user = user
        @identity.user = user
        @identity.save()
        redirect_to redirect_url
      end
    end

  end

  def destroy
    self.current_user = nil
    redirect_to redirect_url
  end

  def failure
    redirect_to login_url, alert: 'Authentication failed, please try again.'
  end

  private

  def redirect_url
    redirect_url = root_url
    if cookies[:current_stage]
      current_stage = cookies[:current_stage]
      redirect_url = "#{redirect_url}#stage/#{current_stage}"
    end
    redirect_url    
  end
end
