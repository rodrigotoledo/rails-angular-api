require 'rails_helper'

RSpec.describe 'Users Api Requests', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe "get user info" do
    before do
      get api_auth_validate_token_path, headers: headers
    end

    context "when get user info" do
      it "returns user info" do
        expect(json_response[:data][:id]).to eql(user_id)
      end

      it "returns success response" do
        expect(response).to be_successful
      end
    end

    context "when fail to get user info" do
      before do
        headers['access-token'] = 'invalid'
        get api_auth_validate_token_path, headers: headers
      end

      it "returns unauthorized" do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "create user" do
    before do
      post api_user_registration_path, params: user_params, headers: headers
    end

    context "when have valid params" do
      let(:user_params) { attributes_for(:custom_user) }

      it "returns user created info" do
        expect(json_response[:data][:email]).to eql(user_params[:email])
      end

      it "returns success response" do
        expect(response).to be_successful
      end
    end

    context "when have invalid params" do
      let(:user_params) { {email: 'invalid'} }

      it "returns errors info" do
        expect(json_response).to have_key(:errors)
      end

      it "returns unprocessable entity response" do
        expect(response).to be_unprocessable
      end
    end
  end

  describe "update user" do
    let(:user_params) { attributes_for(:custom_user) }

    before do
      put api_user_registration_path, params: user_params, headers: headers
    end

    context "when update user info" do
      it "returns user info with new info" do
        expect(json_response[:data][:email]).to eql(user_params[:email])
      end

      it "returns a successful response" do
        expect(response).to be_successful
      end
    end

    context "when have invalid params" do
      let(:user_params) { {email: 'invalid'} }

      it "returns errors info" do
        expect(json_response).to have_key(:errors)
      end

      it "returns unprocessable entity response" do
        expect(response).to be_unprocessable
      end
    end
  end

  describe "remove user" do
    before do
      delete api_user_registration_path, headers: headers
    end

    it "returns entity destroyed response" do
      expect(response).to be_successful
    end
  end
end
