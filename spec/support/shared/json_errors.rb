require 'rails_helper'

shared_examples_for "unauthorized_requests" do 
  before {subject}

  it "should return 401 status code" do 
    expect(response).to have_http_status(:unauthorized)
  end

  it "should return proper error json" do 
    expect(json[:errors]).to include(unauthorized_error)
  end
end

shared_examples_for "invalid_token_requests" do
  let(:unauthorized_error) do 
    {
      "status": 401,
      "source": { "pointer": "/request/headers/authorization" },
      "title": "Unauthorized",
      "detail": "Auth token is invalid.",
    }
  end
  it_behaves_like "unauthorized_requests"
end

shared_examples_for "no_token_requests" do
  let(:unauthorized_error) do 
    {
      "status": 401,
      "source": { "pointer": "/request/headers/authorization" },
      "title": "Unauthorized",
      "detail": "You need to sign in before continuing.",
    }
  end
  it_behaves_like "unauthorized_requests"
end