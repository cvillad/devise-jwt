require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do 
  describe "#create" do
    subject { post "/signup", params: params} 
    
    context "when invalid data provided" do 
      let(:params) do 
        {user: {email: nil, password: nil} }
      end

      it "should return unprocessable entity status code" do 
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "should not create a user" do 
        expect{subject}.not_to change{User.count}
      end

      it "should have a proper error json" do 
        subject 
        expect(json[:errors]).to include(
          {
            source: { pointer: "/data/attributes/email" }, 
            detail: "can't be blank", 
            status: 422, 
            title: "Invalid request"
          }, 
          {
            source: { pointer: "/data/attributes/password" }, 
            detail: "can't be blank", 
            status: 422, 
            title: "Invalid request"
          })
      end
    end

    context "when valid data provided" do 
      let(:params) do 
        {user: {email: "jdoe@gmail.com", password: "secret"} }
      end

      it "should return created status code" do 
        subject
        expect(response).to have_http_status(:created)
      end

      it "should create a user" do 
        expect{subject}.to change{User.count}.by(1)
      end

      it "should return the created user" do 
        subject 
        expect(json_data).to include({attributes: {email: 'jdoe@gmail.com'}})
      end
    end
  end
end