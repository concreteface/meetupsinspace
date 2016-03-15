class CreateMeetupsUsers < ActiveRecord::Migration
  def change
    create_table :meetups_users do |table|
      table.integer :meetup_id
      table.integer :user_id
    end
  end
end
