class AddBannerToSplashpage < ActiveRecord::Migration
  def change
    add_column :splashpages, :banner_file_name, :string
    add_column :splashpages, :banner_content_type, :string
    add_column :splashpages, :banner_file_size, :integer
    add_column :splashpages, :banner_updated_at, :datetime
  end
end
