class AddViolationToEating < ActiveRecord::Migration
  def change
    add_column :eatings, :violation, :boolean
  end
end
