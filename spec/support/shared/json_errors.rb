require 'rails_helper'

shared_examples_for "unauthorized_requests" do
  let(:unauthorized_error) do 
    {
      "status": 401,
      "source": { "pointer": "/request/headers/authorization" },
      "title": "Unauthorized",
      "detail": "You need to sign in or sign up before continuing.",
    }
  end
  it "should return 401 status code" do 
    subject 
    expect(response).to have_http_status(:unauthorized)
  end

  it "should return proper error json" do 
    subject 
    expect(json[:errors]).to include(unauthorized_error)
  end
end