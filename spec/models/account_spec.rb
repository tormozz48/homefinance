require 'spec_helper'

describe Account do
  before(:each) do
    @account = FactoryGirl.create(:account1)
  end

  describe 'shoulda validation' do
    it { should belong_to(:user) }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:amount) }

    it { should validate_presence_of(:account_type) }

    it { should validate_presence_of(:user_id) }

    it { should validate_presence_of(:enabled) }

    it { should validate_numericality_of(:amount) }

    it { should validate_numericality_of(:user_id).only_integer }

    it { should validate_numericality_of(:account_type).only_integer }

    it { should validate_uniqueness_of(:name).scoped_to([:user_id, :account_type, :enabled]) }

    it { should ensure_length_of(:name).is_at_least(5) }

    it { should ensure_length_of(:name).is_at_most(30) }

    it { should ensure_length_of(:description).is_at_most(255) }

    it { should allow_mass_assignment_of(:name) }

    it { should allow_mass_assignment_of(:amount) }

    it { should allow_mass_assignment_of(:description) }

    it { should allow_mass_assignment_of(:account_type) }

    it { should allow_mass_assignment_of(:user) }

    it { should allow_mass_assignment_of(:user_id) }

    it { should allow_mass_assignment_of(:enabled) }

    it { should have_readonly_attribute(:id) }

    it { should have_readonly_attribute(:created_at) }

    it { should have_readonly_attribute(:updated_at) }
  end

  describe 'custom methods' do
    it 'should return name with amount' do
      @account.name_with_amount.should eq('Privat Bank Corporate Card 0.0')
    end
  end
end