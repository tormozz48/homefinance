class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.boolean :enabled
      t.float :weight
      t.boolean :training
      t.date :date
      t.references :user
      t.timestamps
    end

    add_index :weights, :user_id
    add_index :weights, :date
    add_index :weights, :enabled
  end
end
