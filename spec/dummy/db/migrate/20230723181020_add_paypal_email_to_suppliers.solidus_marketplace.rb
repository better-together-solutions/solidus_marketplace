# frozen_string_literal: true

# This migration comes from solidus_marketplace (originally 20171027180043)
class AddPaypalEmailToSuppliers < SolidusSupport::Migration[5.1]
  def change
    add_column :spree_suppliers, :paypal_email, :string
  end
end
