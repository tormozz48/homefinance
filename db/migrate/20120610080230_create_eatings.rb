class CreateEatings < ActiveRecord::Migration
  def change
    create_table :eatings do |t|
      t.boolean :enabled
      t.time :time
      t.string :food
      t.boolean :overweight
      t.references :weight
      t.references :eating_type
      t.timestamps
    end

    add_index :eatings, :weight_id
    add_index :eatings, :eating_type_id
    add_index :eatings, :enabled
  end
end
