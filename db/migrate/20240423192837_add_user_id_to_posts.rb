class AddUserIdToPosts < ActiveRecord::Migration[7.1]
  def change
    # Add user_id foreign key referencing users
    add_reference :posts, :user, foreign_key: true
  end
end
