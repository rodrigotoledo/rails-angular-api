require 'rails_helper'

RSpec.describe "Api::Sessions", type: :request do
  let(:user) { create(:user) }

  describe "create session" do
    before do
      post api_sessions_path, params: { session: credentials }
    end

    context "valid credentials and auth" do
      let(:credentials) { { email: user.email, password: '123456' } }

      it "returns user auth token" do
        user.reload
        expect(json_response[:auth_token]).to eql(user.auth_token)
      end

      it "returns status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "invalid credentials" do
      let(:credentials) { { email: user.email, password: 'invalid' } }

      it "returns user auth token" do
        expect(json_response).to have_key(:errors)
      end

      it "returns status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "destroy session" do
    let(:auth_token) { user.auth_token }

    before do
      delete api_session_path(auth_token)
    end

    it "return status 204" do
      expect(response).to have_http_status(204)
    end

    it "change user auth token" do
      expect(User.find_by(auth_token: auth_token)).to be_nil
    end


  end

end
