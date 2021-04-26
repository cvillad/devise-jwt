class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    @user = User.new(sign_up_params)
  
    if @user.save
      #token = user.generate_jwt
      render json: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
end