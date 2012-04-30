class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :description
      t.float :amount
      t.integer :account_type
      t.references :user
      t.timestamps
    end

    add_index :accounts, :user_id
    add_index :accounts, :account_type
    add_index :accounts, :amount
  end
end
