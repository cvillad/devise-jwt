class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    @user = User.new(sign_up_params)
    @user.save!
    render json: serializer.new(@user), status: :created
  end

  def serializer 
    UserSerializer
  end
end