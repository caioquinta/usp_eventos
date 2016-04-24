class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :user_name,               null: false, default: ""
      t.string :description,         null: false, default: ""
      t.string :email,              null: false, default: "" 
      t.timestamps null: false
    end
  end
end
