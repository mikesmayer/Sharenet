class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|

      t.integer :user_id,         null: false,  default: 0
      t.integer :parent_id,       null: false,  default: 0

      t.string  :name,            null: false,  default: ""
      t.string  :description,     null: false,  default: ""
      t.string  :slug,            null: false,  default: ""

      #status
      t.boolean :is_public,       null: false,  default: true
      t.boolean :is_leaf,         null: false,  default: false
      t.boolean :is_trend,        null: false,  default: false
      t.boolean :is_active,       null: false,  default: true
    end
  end
end
