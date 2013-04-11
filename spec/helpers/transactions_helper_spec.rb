require 'spec_helper'

describe TransactionsHelper do

  describe 'color by date' do
    it 'should return color by date (monday)' do
      get_row_color_by_date(Date.new(2013, 4, 8)).should eq('#FF6A4D')
    end

    it 'should return color by date (tuesday)' do
      get_row_color_by_date(Date.new(2013, 4, 9)).should eq('#FFC34D')
    end

    it 'should return color by date (wednesday)' do
      get_row_color_by_date(Date.new(2013, 4, 10)).should eq('#E1FF4D')
    end

    it 'should return color by date (thursday)' do
      get_row_color_by_date(Date.new(2013, 4, 11)).should eq('#88FF4D')
    end

    it 'should return color by date (friday)' do
      get_row_color_by_date(Date.new(2013, 4, 12)).should eq('#4DE1FF')
    end

    it 'should return color by date (saturday)' do
      get_row_color_by_date(Date.new(2013, 4, 13)).should eq('#4D88FF')
    end

    it 'should return color by date (sunday)' do
      get_row_color_by_date(Date.new(2013, 4, 14)).should eq('#C34DFF')
    end
  end

  describe 'color by day' do
    it 'should return color by day (monday)' do
      get_row_color_by_day(1).should eq('#FF6A4D')
    end

    it 'should return color by day (tuesday)' do
      get_row_color_by_day(2).should eq('#FFC34D')
    end

    it 'should return color by day (wednesday)' do
      get_row_color_by_day(3).should eq('#E1FF4D')
    end

    it 'should return color by day (thursday)' do
      get_row_color_by_day(4).should eq('#88FF4D')
    end

    it 'should return color by day (friday)' do
      get_row_color_by_day(5).should eq('#4DE1FF')
    end

    it 'should return color by day (saturday)' do
      get_row_color_by_day(6).should eq('#4D88FF')
    end

    it 'should return color by day (sunday)' do
      get_row_color_by_day(0).should eq('#C34DFF')
    end
  end

  describe 'get index title' do
    it 'should return index title for TR_TO_ACCOUNT' do
      get_index_title(0).should eq(I18n.t('list.transactions.to_account'))
    end

    it 'should return index title for TR_FROM_ACCOUNT_TO_ACCOUNT' do
      get_index_title(1).should eq(I18n.t('list.transactions.from_account.to_account'))
    end

    it 'should return index title for TR_FROM_ACCOUNT_TO_CASH' do
      get_index_title(2).should eq(I18n.t('list.transactions.from_account.to_cash'))
    end

    it 'should return index title for TR_FROM_ACCOUNT_TO_CATEGORY' do
      get_index_title(3).should eq(I18n.t('list.transactions.from_account.to_category'))
    end

    it 'should return index title for TR_TO_CASH' do
      get_index_title(4).should eq(I18n.t('list.transactions.to_cash'))
    end

    it 'should return index title for TR_FROM_CASH_TO_ACCOUNT' do
      get_index_title(5).should eq(I18n.t('list.transactions.from_cash.to_account'))
    end

    it 'should return index title for TR_FROM_CASH_TO_CASH' do
      get_index_title(6).should eq(I18n.t('list.transactions.from_cash.to_cash'))
    end

    it 'should return index title for TR_FROM_CASH_TO_CATEGORY' do
      get_index_title(7).should eq(I18n.t('list.transactions.from_cash.to_category'))
    end
  end

  describe 'get new title' do
    it 'should return new title for TR_TO_ACCOUNT' do
      get_new_title(0).should eq(I18n.t('form.title.new.transaction.to_account'))
    end

    it 'should return new title for TR_FROM_ACCOUNT_TO_ACCOUNT' do
      get_new_title(1).should eq(I18n.t('form.title.new.transaction.from_account.to_account'))
    end

    it 'should return new title for TR_FROM_ACCOUNT_TO_CASH' do
      get_new_title(2).should eq(I18n.t('form.title.new.transaction.from_account.to_cash'))
    end

    it 'should return new title for TR_FROM_ACCOUNT_TO_CATEGORY' do
      get_new_title(3).should eq(I18n.t('form.title.new.transaction.from_account.to_category'))
    end

    it 'should return new title for TR_TO_CASH' do
      get_new_title(4).should eq(I18n.t('form.title.new.transaction.to_cash'))
    end

    it 'should return new title for TR_FROM_CASH_TO_ACCOUNT' do
      get_new_title(5).should eq(I18n.t('form.title.new.transaction.from_cash.to_account'))
    end

    it 'should return new title for TR_FROM_CASH_TO_CASH' do
      get_new_title(6).should eq(I18n.t('form.title.new.transaction.from_cash.to_cash'))
    end

    it 'should return new title for TR_FROM_CASH_TO_CATEGORY' do
      get_new_title(7).should eq(I18n.t('form.title.new.transaction.from_cash.to_category'))
    end
  end

  describe 'get edit title' do
    it 'should return edit title for TR_TO_ACCOUNT' do
      get_edit_title(0).should eq(I18n.t('form.title.edit.transaction.to_account'))
    end

    it 'should return edit title for TR_FROM_ACCOUNT_TO_ACCOUNT' do
      get_edit_title(1).should eq(I18n.t('form.title.edit.transaction.from_account.to_account'))
    end

    it 'should return edit title for TR_FROM_ACCOUNT_TO_CASH' do
      get_edit_title(2).should eq(I18n.t('form.title.edit.transaction.from_account.to_cash'))
    end

    it 'should return edit title for TR_FROM_ACCOUNT_TO_CATEGORY' do
      get_edit_title(3).should eq(I18n.t('form.title.edit.transaction.from_account.to_category'))
    end

    it 'should return edit title for TR_TO_CASH' do
      get_edit_title(4).should eq(I18n.t('form.title.edit.transaction.to_cash'))
    end

    it 'should return edit title for TR_FROM_CASH_TO_ACCOUNT' do
      get_edit_title(5).should eq(I18n.t('form.title.edit.transaction.from_cash.to_account'))
    end

    it 'should return edit title for TR_FROM_CASH_TO_CASH' do
      get_edit_title(6).should eq(I18n.t('form.title.edit.transaction.from_cash.to_cash'))
    end

    it 'should return edit title for TR_FROM_CASH_TO_CATEGORY' do
      get_edit_title(7).should eq(I18n.t('form.title.edit.transaction.from_cash.to_category'))
    end
  end

  it 'should round float' do
    round_float(999.99999999).should eq(999.99)
  end

  describe 'create table header' do
    it 'should create table header for TR_TO_ACCOUNT' do
      create_table_header(0).should eq('<th width="40%">' + I18n.t('field.transaction.account_to') + '</th>')
    end

    it 'should create table header for TR_FROM_ACCOUNT_TO_ACCOUNT' do
      create_table_header(1).should eq('<th width="20%">' + I18n.t('field.transaction.account_from') + '</th>' +
                                       '<th width="20%">' + I18n.t('field.transaction.account_to') + '</th>')
    end

    it 'should create table header for TR_FROM_ACCOUNT_TO_CASH' do
      create_table_header(2).should eq('<th width="20%">' + I18n.t('field.transaction.account_from') + '</th>' +
                                       '<th width="20%">' + I18n.t('field.transaction.cash_to') + '</th>')
    end

    it 'should create table header for TR_FROM_ACCOUNT_TO_CATEGORY' do
      create_table_header(3).should eq('<th width="20%">' + I18n.t('field.transaction.account_from') + '</th>' +
                                       '<th width="20%">' + I18n.t('field.transaction.category') + '</th>')
    end

    it 'should create table header for TR_TO_CASH' do
      create_table_header(4).should eq('<th width="40%">' + I18n.t('field.transaction.cash_to') + '</th>')
    end

    it 'should create table header for TR_FROM_CASH_TO_ACCOUNT' do
      create_table_header(5).should eq('<th width="20%">' + I18n.t('field.transaction.cash_from') + '</th>' +
                                       '<th width="20%">' + I18n.t('field.transaction.account_to') + '</th>')
    end

    it 'should create table header for TR_FROM_CASH_TO_CASH' do
      create_table_header(6).should eq('<th width="20%">' + I18n.t('field.transaction.cash_from') + '</th>' +
                                       '<th width="20%">' + I18n.t('field.transaction.cash_to') + '</th>')
    end

    it 'should create table header for TR_FROM_CASH_TO_CATEGORY' do
      create_table_header(7).should eq('<th width="20%">' + I18n.t('field.transaction.cash_from') + '</th>' +
                                       '<th width="20%">' + I18n.t('field.transaction.category') + '</th>')
    end
  end
end