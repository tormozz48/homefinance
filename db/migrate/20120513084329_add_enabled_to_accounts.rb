class AddEnabledToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :enabled, :boolean, :null => false, :default => true
  end
end
