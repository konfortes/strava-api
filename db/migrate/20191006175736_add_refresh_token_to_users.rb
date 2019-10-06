class AddRefreshTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :refresh_token, :string
    add_column :users, :auth_token_expires_at, :integer
  end
end
