class AddRangeToService < ActiveRecord::Migration[6.0]
  def change
    add_column :services, :range, :float
  end
end
