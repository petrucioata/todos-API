class AddStateToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :state, :integer, default: 0
  end
end
