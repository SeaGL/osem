class AddPnwToEvents < ActiveRecord::Migration
  def change
    add_column :events, :pnw, :boolean
  end
end
