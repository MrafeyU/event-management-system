class RenameColumnUserIdToOrganizerIdInEvents < ActiveRecord::Migration[8.1]
  def change
    rename_column :events, :user_id, :organizer_id
    add_foreign_key :events, :users, column: :organizer_id  
  end
end
