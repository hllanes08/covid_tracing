class CreateWindows < ActiveRecord::Migration[6.1]
  def change
    create_table :windows do |t|
      t.integer :windows, array: true, default: []
      t.integer :contact_user_id
      t.integer :user_id

      t.timestamps
    end
  end
end
