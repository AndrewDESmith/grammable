class RemoveDeviseFromGrams < ActiveRecord::Migration
  def change
    remove_column :grams, :email,                   :string
    remove_column :grams, :encrypted_password,      :string
    remove_column :grams, :reset_password_token,    :string
    remove_column :grams, :reset_password_sent_at,  :datetime
    remove_column :grams, :remember_created_at,     :datetime
    remove_column :grams, :sign_in_count,           :integer
    remove_column :grams, :current_sign_in_at,      :datetime
    remove_column :grams, :last_sign_in_at,         :datetime
    remove_column :grams, :current_sign_in_ip,      :inet
    remove_column :grams, :last_sign_in_ip,         :inet
  end
end
