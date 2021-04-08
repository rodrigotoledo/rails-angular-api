require "rails_helper"

RSpec.describe Authenticable do
  controller(ApplicationController) do
    include Authenticable
  end

  describe "#current_user" do
    let(:user){ create(:user) }

    before do
      req = double(headers: {'Authorization' => user.auth_token})
      allow(subject).to receive(:request).and_return(req)
    end

    it "returns current user from header auth" do
      expect(subject.current_user).to eql(user)
    end
  end

  describe "#auth_with_token!" do
    controller do
      before_action :auth_with_token!


      def restricted; end
    end

    context "user isnt logged" do
      before do
        allow(subject).to receive(:current_user).and_return(nil)
        routes.draw { get 'restricted' => 'anonymous#restricted' }
        get :restricted
      end

      it "returns status code 401" do
        expect(response).to  have_http_status(401)
      end

      it "returns json with errors" do
        expect(json_response).to have_key(:errors)
      end
    end
  end
end
