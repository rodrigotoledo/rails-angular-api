require 'rails_helper'

RSpec.describe User, type: :model do
  context "invalid" do
    before do
      subject.valid?
    end

    it { expect(subject.errors.count).to eql(3) }
    it { is_expected.to be_invalid }
    it { is_expected.to have(1).errors_on(:name) }
    it { is_expected.to have(1).errors_on(:email) }
    it { is_expected.to have(1).errors_on(:password) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_uniqueness_of(:auth_token) }

    context "uniq user" do
      let(:email) { 'some-user@email.com' }
      before do
        create(:user, email: email)
        subject.attributes = attributes_for(:user, email: email)
        subject.valid?
      end

      it { expect(subject.errors.count).to eql(1) }
      it { is_expected.to have(1).errors_on(:email) }
      it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
    end
  end

   context "validations" do
     before do
      subject.attributes = attributes_for(:user)
     end
     it { is_expected.to be_valid }
     it { is_expected.to have_many(:tasks).dependent(:destroy) }
     it { is_expected.to allow_value('email@email.com').for(:email) }
     it { is_expected.to validate_uniqueness_of(:auth_token) }
   end

   describe "#generate_auth_token!" do
     it "generates auth token" do
      new_auth_token = '123456asdf123456asdf'
      allow(Devise).to receive(:friendly_token).and_return(new_auth_token)
      subject.generate_auth_token!

      expect(subject.auth_token).to eql(new_auth_token)
     end

     it "renew auth token when exists" do
        auth_token = '123456asdf123456asdfaaaaaaaaaaa'
        new_auth_token = '123456asdf123456asdfbbbbbbbb'
        new_user = create(:user)
        subject.generate_auth_token!

        # mock to loop 3 times
        allow(Devise).to receive(:friendly_token).and_return(auth_token, auth_token, new_auth_token)

        expect(subject.auth_token).not_to eq(new_user.auth_token)
     end


   end


end
