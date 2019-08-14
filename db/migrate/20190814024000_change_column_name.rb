class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :customerID, :customerId
  end
end
