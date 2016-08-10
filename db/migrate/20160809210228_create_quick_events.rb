class CreateQuickEvents < ActiveRecord::Migration
  def change
    create_table :quick_events do |t|
      t.timestamps null: false
      t.string :message, null: false, default: ""  
      t.references :user
    end
  end
end
