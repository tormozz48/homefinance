require 'spec_helper'

describe Transaction do
  before(:each) do
    @account1 = FactoryGirl.create(:account1)
    @account2 = FactoryGirl.create(:account2)
    @account3 = FactoryGirl.create(:account3)
    @account4 = FactoryGirl.create(:account4)

    @category1 = FactoryGirl.create(:category1)

    @transaction1 = FactoryGirl.create(:transaction1)
    @transaction2 = FactoryGirl.create(:transaction2)
    @transaction3 = FactoryGirl.create(:transaction3)
    @transaction4 = FactoryGirl.create(:transaction4)
    @transaction5 = FactoryGirl.create(:transaction5)
    @transaction6 = FactoryGirl.create(:transaction6)
    @transaction7 = FactoryGirl.create(:transaction7)
    @transaction8 = FactoryGirl.create(:transaction8)
  end

  describe 'shoulda validation' do
    it { should belong_to(:user) }

    it { should belong_to(:category) }

    it { should belong_to(:account_from).class_name(Account) }

    it { should belong_to(:account_to).class_name(Account) }

    it { should validate_presence_of(:amount) }

    it { should validate_presence_of(:date) }

    it { should validate_presence_of(:transaction_type) }

    it { should validate_presence_of(:user_id) }

    it { should validate_numericality_of(:amount) }

    it { should validate_numericality_of(:user_id).only_integer }

    it { should validate_numericality_of(:transaction_type).only_integer }

    it { should ensure_length_of(:comment).is_at_most(255) }
  end

  describe 'add errors' do
    it 'should add negative account error' do
      @transaction1.add_negative_account_error
      expect(@transaction1.errors.messages).to include :account_from => [I18n.t('message.error.account.negative')]
    end

    it 'should add empty account from error' do
      @transaction1.add_empty_account_from_error
      expect(@transaction1.errors.messages).to include :account_from => [I18n.t('message.error.account.empty')]
    end

    it 'should add empty account to error' do
      @transaction1.add_empty_account_to_error
      expect(@transaction1.errors.messages).to include :account_to => [I18n.t('message.error.account.empty')]
    end

    it 'should add empty category error' do
      @transaction1.add_empty_category_error
      expect(@transaction1.errors.messages).to include :category => [I18n.t('message.error.category.empty')]
    end
  end

  describe 'check for' do
    it 'should check for account from' do
      @transaction1.check_for_account_from.should eq(false)
      @transaction2.check_for_account_from.should eq(true)
      @transaction3.check_for_account_from.should eq(true)
      @transaction4.check_for_account_from.should eq(true)
      @transaction5.check_for_account_from.should eq(false)
      @transaction6.check_for_account_from.should eq(true)
      @transaction7.check_for_account_from.should eq(true)
      @transaction8.check_for_account_from.should eq(true)
    end

    it 'should check for account to' do
      @transaction1.check_for_account_to.should eq(true)
      @transaction2.check_for_account_to.should eq(true)
      @transaction3.check_for_account_to.should eq(true)
      @transaction4.check_for_account_to.should eq(false)
      @transaction5.check_for_account_to.should eq(true)
      @transaction6.check_for_account_to.should eq(true)
      @transaction7.check_for_account_to.should eq(true)
      @transaction8.check_for_account_to.should eq(false)
    end

    it 'should check for category' do
      @transaction1.check_for_category.should eq(false)
      @transaction2.check_for_category.should eq(false)
      @transaction3.check_for_category.should eq(false)
      @transaction4.check_for_category.should eq(true)
      @transaction5.check_for_category.should eq(false)
      @transaction6.check_for_category.should eq(false)
      @transaction7.check_for_category.should eq(false)
      @transaction8.check_for_category.should eq(true)
    end
  end

  it 'should transfer sum to account success' do
    @transaction1.transfer_sum_to_account.should eq(true)
    account = Account.find(1)
    account.amount.should eq(10.0)
  end

  it 'should transfer sum to account failure' do
    @transaction4.transfer_sum_to_account.should eq(false)
  end

  it 'should change sum to account success' do
    @transaction1.amount = 20
    @transaction1.change_sum_to_account.should eq(true)
    account = Account.find(1)
    account.amount.should eq(10)
  end

  it 'should change sum to account failure' do
    @transaction4.change_sum_to_account.should eq(false)
  end

  it 'should rollback sum from account success' do
    account_old = Account.find(1)
    account_old.amount = 20
    account_old.save
    @transaction1.rollback_sum_from_account.should eq(true)
    account_new = Account.find(1)
    account_new.amount.should eq(10)
  end

  it 'should rollback sum from account failure 1' do
    @transaction1.rollback_sum_from_account.should eq(false)
    expect(@transaction1.errors.messages).to include :account_from => [I18n.t('message.error.account.negative')]
  end

  it 'should rollback sum from account failure 2' do
    @transaction4.rollback_sum_from_account.should eq(false)
  end

  it 'should transfer sum between accounts success' do
    account1 = Account.find(1)
    account1.amount = 30
    account1.save
    @transaction2.transfer_sum_between_accounts.should eq(true)
    account11 = Account.find(1)
    account33 = Account.find(3)
    account11.amount.should eq(20)
    account33.amount.should eq(10)
  end

  it 'should transfer sum between accounts failure 1' do
    @transaction2.transfer_sum_between_accounts.should eq(false)
    expect(@transaction2.errors.messages).to include :account_from => [I18n.t('message.error.account.negative')]
  end

  it 'should transfer sum between accounts failure 2' do
    @transaction1.transfer_sum_between_accounts.should eq(false)
  end

  it 'should change sum between accounts success' do
    account1 = Account.find(1)
    account1.amount = 30
    account1.save
    @transaction2.transfer_sum_between_accounts.should eq(true)
    account11 = Account.find(1)
    account33 = Account.find(3)
    account11.amount.should eq(20)
    account33.amount.should eq(10)

    @transaction2.amount = 20
    @transaction2.change_sum_between_accounts.should eq(true)
    account11 = Account.find(1)
    account33 = Account.find(3)
    account11.amount.should eq(10)
    account33.amount.should eq(20)
  end

  it 'should change sum between accounts failure 1' do
    account1 = Account.find(1)
    account1.amount = 30
    account1.save
    @transaction2.transfer_sum_between_accounts.should eq(true)
    account11 = Account.find(1)
    account33 = Account.find(3)
    account11.amount.should eq(20)
    account33.amount.should eq(10)

    @transaction2.amount = 50
    @transaction2.change_sum_between_accounts.should eq(false)
    expect(@transaction2.errors.messages).to include :account_from => [I18n.t('message.error.account.negative')]
  end

  it 'should change sum between accounts failure 2' do
    @transaction1.change_sum_between_accounts.should eq(false)
  end

  it 'should rollback sum between accounts success' do
    account3 = Account.find(3)
    account3.amount = 30
    account3.save
    @transaction2.rollback_sum_between_accounts.should eq(true)

    account33 = Account.find(3)
    account33.amount.should eq(20)
  end

  it 'should rollback sum between accounts failure 1' do
    @transaction2.rollback_sum_between_accounts.should eq(false)
    expect(@transaction2.errors.messages).to include :account_from => [I18n.t('message.error.account.negative')]
  end

  it 'should rollback sum between accounts failure 2' do
    @transaction1.rollback_sum_between_accounts.should eq(false)
  end

  it 'should transfer sum from account to category success' do
    account_old = Account.find(1)
    account_old.amount = 30
    account_old.save
    @transaction4.transfer_sum_from_account_to_category.should eq(true)
    account_new = Account.find(1)
    category = Category.find(1)
    account_new.amount.should eq(20)
    category.amount.should eq(10)
  end

  it 'should transfer sum from account to category failure 1' do
    @transaction4.transfer_sum_from_account_to_category.should eq(false)
    expect(@transaction4.errors.messages).to include :account_from => [I18n.t('message.error.account.negative')]
  end

  it 'should transfer sum from account to category failure 2' do
    @transaction2.transfer_sum_from_account_to_category.should eq(false)
  end

  it 'should change sum from account to category success' do
    account_old = Account.find(1)
    account_old.amount = 30
    account_old.save
    @transaction4.transfer_sum_from_account_to_category.should eq(true)
    account_new = Account.find(1)
    category = Category.find(1)
    account_new.amount.should eq(20)
    category.amount.should eq(10)

    @transaction4.amount = 20
    @transaction4.change_sum_from_account_to_category.should eq(true)
    account_new = Account.find(1)
    category = Category.find(1)
    account_new.amount.should eq(10)
    category.amount.should eq(20)
  end

  it 'should change sum from account to category failure 1' do
    account_old = Account.find(1)
    account_old.amount = 30
    account_old.save
    @transaction4.transfer_sum_from_account_to_category.should eq(true)
    account_new = Account.find(1)
    category = Category.find(1)
    account_new.amount.should eq(20)
    category.amount.should eq(10)

    @transaction4.amount = 50

    @transaction4.change_sum_from_account_to_category.should eq(false)
    expect(@transaction4.errors.messages).to include :account_from => [I18n.t('message.error.account.negative')]
  end

  it 'should change sum from account to category failure 2' do
    @transaction2.change_sum_from_account_to_category.should eq(false)
  end

  it 'should rollback sum from category success' do
    @transaction4.rollback_sum_from_category.should eq(true)
    account = Account.find(1)
    account.amount.should eq(10)
  end

  it 'should rollback sum from category failure' do
    @transaction2.rollback_sum_from_category.should eq(false)
  end

  describe 'calculate transaction new' do
    it 'should calculate transaction new 1' do
      @transaction1.calculate_transaction_new.should eq(true)
    end

    it 'should calculate transaction new 2' do
      account1 = Account.find(1)
      account1.amount = 30
      account1.save
      @transaction2.calculate_transaction_new.should eq(true)
    end

    it 'should calculate transaction new 3' do
      account1 = Account.find(1)
      account1.amount = 30
      account1.save
      @transaction3.calculate_transaction_new.should eq(true)
    end

    it 'should calculate transaction new 4' do
      account1 = Account.find(1)
      account1.amount = 30
      account1.save
      @transaction4.calculate_transaction_new.should eq(true)
    end

    it 'should calculate transaction new 5' do
      account2 = Account.find(2)
      account2.amount = 30
      account2.save
      @transaction5.calculate_transaction_new.should eq(true)
    end

    it 'should calculate transaction new 6' do
      account2 = Account.find(2)
      account2.amount = 30
      account2.save
      @transaction6.calculate_transaction_new.should eq(true)
    end

    it 'should calculate transaction new 7' do
      account2 = Account.find(2)
      account2.amount = 30
      account2.save
      @transaction7.calculate_transaction_new.should eq(true)
    end

    it 'should calculate transaction new 8' do
      account2 = Account.find(2)
      account2.amount = 30
      account2.save
      @transaction8.calculate_transaction_new.should eq(true)
    end
  end

  describe 'calculate transaction edit' do
    it 'should calculate transaction edit 1' do
      @transaction1.calculate_transaction_edit.should eq(true)
    end

    it 'should calculate transaction edit 2' do
      @transaction2.calculate_transaction_edit.should eq(true)
    end

    it 'should calculate transaction edit 3' do
      @transaction3.calculate_transaction_edit.should eq(true)
    end

    it 'should calculate transaction edit 4' do
      @transaction4.calculate_transaction_edit.should eq(true)
    end

    it 'should calculate transaction edit 5' do
      @transaction5.calculate_transaction_edit.should eq(true)
    end

    it 'should calculate transaction edit 6' do
      @transaction6.calculate_transaction_edit.should eq(true)
    end

    it 'should calculate transaction edit 7' do
      @transaction7.calculate_transaction_edit.should eq(true)
    end

    it 'should calculate transaction edit 8' do
      @transaction8.calculate_transaction_edit.should eq(true)
    end
  end

  describe 'calculate transaction destroy' do
    it 'should calculate transaction destroy 1' do
      account = Account.find(1)
      account.amount = 30
      account.save
      @transaction1.calculate_transaction_destroy.should eq(true)
    end

    it 'should calculate transaction destroy 2' do
      account = Account.find(3)
      account.amount = 30
      account.save
      @transaction2.calculate_transaction_destroy.should eq(true)
    end

    it 'should calculate transaction destroy 3' do
      account = Account.find(2)
      account.amount = 30
      account.save
      @transaction3.calculate_transaction_destroy.should eq(true)
    end

    it 'should calculate transaction destroy 4' do
      @transaction4.calculate_transaction_destroy.should eq(true)
    end

    it 'should calculate transaction destroy 5' do
      account = Account.find(2)
      account.amount = 30
      account.save
      @transaction5.calculate_transaction_destroy.should eq(true)
    end

    it 'should calculate transaction destroy 6' do
      account = Account.find(1)
      account.amount = 30
      account.save
      @transaction6.calculate_transaction_destroy.should eq(true)
    end

    it 'should calculate transaction destroy 7' do
      account = Account.find(4)
      account.amount = 30
      account.save
      @transaction7.calculate_transaction_destroy.should eq(true)
    end

    it 'should calculate transaction destroy 8' do
      @transaction8.calculate_transaction_destroy.should eq(true)
    end
  end
end