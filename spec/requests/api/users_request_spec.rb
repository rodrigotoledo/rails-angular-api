require 'rails_helper'

RSpec.describe Api::UsersController, type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    {
      'Authorization' => user.auth_token
    }
  end

  describe "get user info" do
    before do
      create_list(:task, 5, user_id: user.id)
      get api_user_path(user_id), headers: headers
    end

    context "when get user info" do
      it "returns user info" do
        expect(json_response[:id]).to eql(user_id)
      end

      it "returns tasks info" do
        expect(json_response).to have_key(:tasks)
        expect(json_response[:tasks]).to have(5).items
      end

      it "returns success response" do
        expect(response).to be_successful
      end
    end

    context "when fail to get user info" do
      let(:user_id) { -1 }

      it "returns not found response" do
        expect(response).to be_not_found
      end
    end
  end

  describe "create user" do
    before do
      post api_users_path, params: { user: user_params }
    end

    context "when have valid params" do
      let(:user_params) { attributes_for(:custom_user) }

      it "returns user created info" do
        expect(json_response[:email]).to eql(user_params[:email])
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
      create_list(:task, 2, user_id: user.id)
      put api_user_path(user_id), params: { user: user_params }, headers: headers
    end

    context "when update user info" do
      it "returns user info with new info" do
        expect(json_response[:email]).to eql(user_params[:email])
      end

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "returns tasks info" do
        expect(json_response).to have_key(:tasks)
        expect(json_response[:tasks]).to have(2).items
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
      delete api_user_path(user_id), headers: headers
    end

    it "returns entity destroyed response" do
      expect(response).to be_successful
    end
  end
end
