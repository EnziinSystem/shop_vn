class AddLockableToUsers < ActiveRecord::Migration[5.1]
  def self.up
    add_column :users, :failed_attempts, :integer, default: 0
    add_column :users, :unlock_token, :string
    add_column :users, :locked_at, :datetime
  end

  def self.down
    remove_column :users, :failed_attempts, :integer
    remove_column :users, :unlock_token, :string
    remove_column :users, :locked_at, :datetime
  end
end
