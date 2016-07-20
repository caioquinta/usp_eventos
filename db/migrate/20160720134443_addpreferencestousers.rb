class Addpreferencestousers < ActiveRecord::Migration
  def change
  	add_column :users, :preferences, :text, array: true, default: []
  end
end
