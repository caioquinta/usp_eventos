class RemoveBeginTimeFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :begin_time, :time
  end
end
