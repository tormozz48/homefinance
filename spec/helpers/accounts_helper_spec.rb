require 'spec_helper'

describe AccountsHelper do

  it 'should return index title for card' do
    get_account_index_title(0).should eq(I18n.t('list.account.cards'))
  end

  it 'should return index title for cash' do
    get_account_index_title(1).should eq(I18n.t('list.account.cashes'))
  end

  it 'should return add title for card' do
    get_account_add_title(0).should eq(I18n.t('form.title.new.account.card'))
  end

  it 'should return add title for cash' do
    get_account_add_title(1).should eq(I18n.t('form.title.new.account.cash'))
  end

  it 'should return edit title for card' do
    get_account_edit_title(0).should eq(I18n.t('form.title.edit.account.card'))
  end

  it 'should return edit title for cash' do
    get_account_edit_title(1).should eq(I18n.t('form.title.edit.account.cash'))
  end
end