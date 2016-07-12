class AddBannerAttributionToSplashpage < ActiveRecord::Migration
  def change
    add_column :splashpages, :banner_attribution, :string
  end
end
