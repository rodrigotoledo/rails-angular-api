require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  context "when is new" do
    it { expect(task.done).to eql(false) }

    it { is_expected.to belong_to(:user) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

end
