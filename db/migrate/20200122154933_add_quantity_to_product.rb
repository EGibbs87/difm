class AddQuantityToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :qty, :string
  end
end
