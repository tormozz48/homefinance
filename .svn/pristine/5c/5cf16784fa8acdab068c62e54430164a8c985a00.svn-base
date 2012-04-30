class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :amount
      t.date :date
      t.string :comment
      t.integer :transaction_type
      t.references :user
      t.references :category
      t.references :account_from
      t.references :account_to
      t.timestamps
    end

    add_index :transactions, :user_id
    add_index :transactions, :account_from_id
    add_index :transactions, :account_to_id
    add_index :transactions, :category_id
    add_index :transactions, :date
    add_index :transactions, :transaction_type
  end
end
