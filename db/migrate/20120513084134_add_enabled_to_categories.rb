class AddEnabledToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :enabled, :boolean, :null => false, :default => true

  end
end
