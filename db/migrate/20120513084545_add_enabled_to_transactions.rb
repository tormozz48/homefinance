class AddEnabledToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :enabled, :boolean, :null => false, :default => true
  end
end
