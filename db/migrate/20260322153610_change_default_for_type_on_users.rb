class ChangeDefaultForTypeOnUsers < ActiveRecord::Migration[8.1]
  def change
      change_column_default :users, :type,nil
  end
end
