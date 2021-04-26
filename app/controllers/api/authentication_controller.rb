class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: login_params[:email])
    puts user
    if user&.valid_password?(login_params[:password])
      render json: { token: JsonWebToken.encode(sub: user.id) }
    else
      render json: { errors: 'invalid' }
    end
  end

  def fetch
    render json: current_user
  end

  private 

  def login_params
    params.require(:user).permit(:email, :password)
  end
end