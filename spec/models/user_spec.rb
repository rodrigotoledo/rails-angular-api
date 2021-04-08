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

    context "uniq user" do
      let(:email) { 'some-user@email.com' }
      before do
        create(:user, email: email)
        subject.attributes = attributes_for(:user, email: email)
        subject.valid?
      end

      it { expect(subject.errors.count).to eql(1) }
      it { is_expected.to have(1).errors_on(:email) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

  end

   context "valid" do
     before do
      subject.attributes = attributes_for(:user)
     end
     it { is_expected.to be_valid }
     it { is_expected.to allow_value('email@email.com').for(:email) }
   end
end
