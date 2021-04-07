require 'rails_helper'

RSpec.describe Api::UsersController, type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  describe "get user info" do
    before do
      get "/users/#{user_id}"
    end

    context "when get user info" do
      it "returns user info" do
        user_response = JSON.parse(response.body)
        expect(user_response["id"]).to eql(user_id)
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

end
