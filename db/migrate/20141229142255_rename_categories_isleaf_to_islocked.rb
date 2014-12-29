class RenameCategoriesIsleafToIslocked < ActiveRecord::Migration
  def change
    rename_column :categories, :is_leaf, :is_locked
  end
end
