require 'rails_helper'

RSpec.describe "Notes", type: :request do
  describe "#index" do
    context "when no token provided" do 
      subject {get "/api/notes"}
      it_behaves_like "no_token_requests"
    end

    context "when invalid token provided" do 
      subject {get "/api/notes", headers: {"Authorization": "invalid_token" } }
      it_behaves_like "invalid_token_requests"
    end

    context "when valid token provided" do 
      subject {get "/api/notes", headers: {"Authorization": JsonWebToken.encode({id: user.id})}}
      let(:user) {create :user}
      let(:note) {create :note, user: user}
      let(:another_note) {create :note, user: user}

      before do 
        note
        another_note
        subject
      end

      it "should return http status ok" do 
        expect(response).to have_http_status(:ok)
      end

      it "should return a proper json" do 
        expect(json_data).to include(
          {
            id: another_note.id.to_s,
            type: "note",
            attributes: {
              title: another_note.title,
              body: another_note.body
            },
            relationships: {
              user: {
                data: {
                  id: user.id.to_s,
                  type: "user"
                }
              }
            }
          },
          {
          id: note.id.to_s,
          type: "note",
          attributes: {
            title: note.title,
            body: note.body
          },
          relationships: {
            user: {
              data: {
                id: user.id.to_s,
                type: "user"
              }
            }
          }
        })
      end
    end
  end

  describe "#create" do 
    context "when no token provided" do 
      subject {post "/api/notes"}
      it_behaves_like "no_token_requests"
    end

    context "when invalid token provided" do 
      subject {post "/api/notes", headers: {"Authorization": "invalid_token" } }
      it_behaves_like "invalid_token_requests"
    end

    context "when valid token provided" do 
      let(:user) {create :user}

      subject {post "/api/notes", 
              headers: {"Authorization": JsonWebToken.encode({id: user.id})},
              params: params}

      describe "when invalid data provided" do 
        let(:params) {}

        it "should return unprocessable entity" do 
          subject 
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return a proper json error" do 
          subject
          expect(json[:errors]).to include(
            {
              "source": {
                  "pointer": "/data/attributes/title"
              },
              "detail": "can't be blank",
              "status": 422,
              "title": "Invalid request"
            },
            {
              "source": {
                  "pointer": "/data/attributes/body"
              },
              "detail": "can't be blank",
              "status": 422,
              "title": "Invalid request"
            })
        end
      end

      describe "when valid data provided" do 
        let(:params) do 
          {
            data:{
                attributes: {
                    title: "note-title-sample",
                    body: "note-body-sample"
                }
            }
          }
        end

        it "should return ok status code" do 
          subject
          expect(response).to have_http_status(:ok)
        end
  
        it "should return proper json" do 
          subject
          expect(json_data[:attributes]).to eq({
            title: "note-title-sample",
            body: "note-body-sample"
          })
        end
  
        it "should create a note" do 
          expect{subject}.to change{Note.count}.by(1)
        end
      end
    end
  end
end
