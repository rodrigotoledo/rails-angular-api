require 'rails_helper'

RSpec.describe Api::UsersController, type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  describe "get user info" do
    before do
      get api_user_path(user_id)
    end

    context "when get user info" do
      it "returns user info" do
        expect(json_response[:id]).to eql(user_id)
      end

      it "returns status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when fail to get user info" do
      let(:user_id) { -1 }

      it "returns status 404" do
        expect(response).to have_http_status(404)
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

      it "returns status 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when have invalid params" do
      let(:user_params) { {email: 'invalid'} }

      it "returns errors info" do
        expect(json_response).to have_key(:errors)
      end

      it "returns status 422" do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "update user" do
    let(:user_params) { attributes_for(:custom_user) }

    before do
      put api_user_path(user_id), params: { user: user_params }
    end

    context "when update user info" do
      it "returns user info with new info" do
        expect(json_response[:email]).to eql(user_params[:email])
      end

      it "returns status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when have invalid params" do
      let(:user_params) { {email: 'invalid'} }

      it "returns errors info" do
        expect(json_response).to have_key(:errors)
      end

      it "returns status 422" do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "remove user" do
    before do
      delete api_user_path(user_id)
    end

    context "when destroy user" do
      it "returns status 204" do
        expect(response).to have_http_status(204)
      end
    end
  end
end
