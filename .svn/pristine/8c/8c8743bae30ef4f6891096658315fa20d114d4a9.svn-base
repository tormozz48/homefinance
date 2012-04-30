class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.string :color
      t.float :amount
      t.references :user
      t.timestamps
    end

    add_index :categories, :user_id
    add_index :categories, :amount
  end
end
