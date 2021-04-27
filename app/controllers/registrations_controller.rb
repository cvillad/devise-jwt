class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    @user = User.new(sign_up_params)
    @user.save!
    render json: serializer.new(@user), status: :created
  end

  private

  def serializer 
    UserSerializer
  end

  def sign_up_params
    params.dig(:data, :attributes)&.permit(:email, :password)
  end
end