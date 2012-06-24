class CreateEatingTypes < ActiveRecord::Migration
  def change
    create_table :eating_types do |t|
      t.string :name
      t.string :eating_order
      t.boolean :enabled
      t.timestamps
    end

    add_index :eating_types, :eating_order
    add_index :eating_types, :enabled
  end
end
