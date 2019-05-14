class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user_login
  end

  def facebook
    user_login
  end

  def user_login
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = "Successfully signed in"
      sign_in_and_redirect @user, event: :authentication
    else
      if request.env['omniauth.auth'] == "google_oauth2"
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
      end
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
