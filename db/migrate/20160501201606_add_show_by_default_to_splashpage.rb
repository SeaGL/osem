class AddShowByDefaultToSplashpage < ActiveRecord::Migration
  def change
    add_column :splashpages, :show_by_default, :boolean
  end
end
