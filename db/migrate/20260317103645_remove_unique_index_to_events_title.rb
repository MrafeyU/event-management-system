class RemoveUniqueIndexToEventsTitle < ActiveRecord::Migration[8.1]
  def change
    remove_index :events, name: "index_events_on_title", unique: true
    add_index :events, :title
  end
end
