class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.timestamps    null: false
      t.string :name, null: false, default: "" 
      t.string :description, null: false, default: ""
      t.datetime :begin_date
      t.datetime :end_date
      t.time :begin_time 
      t.references :planner
    end
  end
end
