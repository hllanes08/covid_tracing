class AddDateToWindowDate < ActiveRecord::Migration[6.1]
  def change
    add_column :windows, :window_date, :date
  end
end
