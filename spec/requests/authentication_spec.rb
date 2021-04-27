require 'rails_helper'

RSpec.describe Api::AuthenticationController, type: :request do 
  describe "#create" do 
    subject { post "/api/auth", params: params }

    context "when invalid data provided" do 
      let(:params) {}

      it "should return not found status code" do 
        subject
        expect(response).to have_http_status(:not_found)
      end

      it "should have a proper error json" do 
        subject 
        expect(json[:errors]).to include({
            detail: "We could not find the object you were looking for.",
            source: {pointer: "/request/url/:id"},
            status: 404,
            title: "Record not Found"
          })
      end
      
    end

    context "when valid data provided" do 
      let(:user) { create :user }

      context "when invalid password provided" do 
        let(:params) do 
          {
            data: {
              attributes: {
                email: user.email, 
                password: "invalid"
              } 
            }
          }
        end

        it "should have a proper error json" do 
          subject 
          expect(json[:errors]).to include({
              detail: "Invalid password.",
              source: {pointer: "/data/attributes/password"},
              status: 422,
              title: "Invalid request"
          })
        end
      end

      describe "when credentials are correct" do 
        let(:params) do 
          {
            data: {
              attributes: {
                email: user.email, 
                password: "secret"
              } 
            }
          }
        end
        
        it "should return proper json with token" do
          allow(JsonWebToken).to receive(:encode).and_return("valid_token")
          subject 
          expect(json_data).to eq(token: "valid_token")
        end
      end
    end
  end
end