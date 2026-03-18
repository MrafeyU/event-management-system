class RenameColumnEventToEventDateInEvents < ActiveRecord::Migration[8.1]
  def change
    rename_column :events, :event, :event_date
  end
end
