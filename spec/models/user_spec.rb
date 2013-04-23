require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user1)
  end

  describe 'shoulda validation' do

    it { should validate_presence_of(:email) }

    it { should ensure_length_of(:email).is_at_most(255) }

    it { should allow_mass_assignment_of(:email) }

    it { should allow_mass_assignment_of(:password) }

    it { should allow_mass_assignment_of(:password_confirmation) }

    it { should allow_mass_assignment_of(:remember_me) }

    it { should allow_mass_assignment_of(:first_name) }

    it { should allow_mass_assignment_of(:last_name) }

    it { should allow_mass_assignment_of(:nickname) }

    it { should allow_mass_assignment_of(:provider) }

    it { should allow_mass_assignment_of(:url) }

    it { should allow_mass_assignment_of(:username) }

    it { should allow_mass_assignment_of(:authentication_token) }

    it { should have_readonly_attribute(:id) }

    it { should have_readonly_attribute(:created_at) }

    it { should have_readonly_attribute(:updated_at) }

    it 'should return display name 1' do
       @user.full_name.should eq('Test First Name Test Last Name')
    end

    it 'should return display name 2' do
      @user.first_name = nil
      @user.full_name.should eq('john_smith@gmail.com')
    end
  end
end