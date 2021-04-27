class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by!(email: login_params[:email])
    if user&.valid_password?(login_params[:password])
      render json: { data: {token: JsonWebToken.encode(id: user.id)} }
    else
      render json: { errors: [{
        source: { pointer: "/data/attributes/password" }, 
        detail: "Invalid password.", 
        status: 422, 
        title: "Invalid request"
      }] }
    end
  end

  def fetch
    render json: current_user
  end

  private 

  def login_params
    params.dig(:data, :attributes)&.permit(:email, :password).to_h
  end
end