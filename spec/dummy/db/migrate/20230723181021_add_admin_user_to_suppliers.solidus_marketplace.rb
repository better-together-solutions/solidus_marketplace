# frozen_string_literal: true

# This migration comes from solidus_marketplace (originally 20180827180043)
class AddAdminUserToSuppliers < SolidusSupport::Migration[5.1]
  def change
    add_column :spree_suppliers, :user_id, :integer
    add_index :spree_suppliers, :user_id
    remove_column :spree_suppliers, :email
  end
end
