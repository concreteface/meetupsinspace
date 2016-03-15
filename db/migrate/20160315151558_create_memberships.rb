class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |table|
      table.integer :meetup_id
      table.integer :user_id
    end
  end
end
