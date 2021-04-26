require 'rails_helper'

RSpec.describe "Notes", type: :request do
  describe "GET /index" do

    context "when invalid token provided" do 
      subject {get "/api/notes"}
      it_behaves_like "unauthorized_requests"
    end

    context "when valid token provided" do 
      subject {get "/api/notes", headers: {"Authorization" => JsonWebToken.encode({id: user.id})}}
      let(:user) {create :user}
      let(:note) {create :note, user: user}
      before{note}
      it "should return http status ok" do 
        subject 
        expect(response).to have_http_status(:ok)
      end

      it "should return a proper json" do 
        subject 
        expect(json_data).to include({
          id: note.id.to_s,
          type: "note",
          attributes: {
            title: note.title,
            body: note.body
          }
        })
      end
    end
  end
end
