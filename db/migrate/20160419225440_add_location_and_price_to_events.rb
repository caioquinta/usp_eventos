class AddLocationAndPriceToEvents < ActiveRecord::Migration
  def change
    add_column :events, :location, :string, default: ''
    add_column :events, :price, :decimal, default: 0.0
  end
end
