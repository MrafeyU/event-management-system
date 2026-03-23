class ChangeDefaultForTypeOnUsers < ActiveRecord::Migration[8.1]
  def change
      change_column_default :users, :type, from: nil, to: "Attendee"
  end
end
