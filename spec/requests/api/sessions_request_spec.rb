require 'rails_helper'

RSpec.describe 'Sessions Api Requests', type: :request do
  let!(:user) { create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let(:credentials) { { email: user.email, password: '123456' }  }
  let(:headers) do
    {
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe "#sign_in" do
    before do
      post api_user_session_path, params: credentials, headers: headers
    end

    context "credentials are valid" do
      it "returns success response" do
        expect(response).to be_successful
      end

      it "returns auth token info response" do
        expect(response.headers).to have_key('access-token')
        expect(response.headers).to have_key('uid')
        expect(response.headers).to have_key('client')
      end
    end

    context "credentials are invalid" do
      let(:credentials) { { email: user.email, password: 'never-will-correct' } }

      it "returns unauthorized" do
        expect(response).to have_http_status(401)
      end

      it "returns auth token info response" do
        expect(json_response).to have_key(:errors)
      end
    end
  end

  describe "#sign_out" do
    before do
      delete destroy_api_user_session_path, headers: headers
    end

    it "returns success response" do
      expect(response).to be_successful
    end

    it "changes the auth token" do
      user.reload
      expect(user).not_to be_valid_token(auth_data['access-token'], auth_data['client'])
    end
  end
end
