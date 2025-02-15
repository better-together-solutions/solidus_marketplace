# frozen_string_literal: true

# This migration comes from solidus_marketplace (originally 20140323170638)
class AddSupplierCommissionToShipments < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_shipments, :supplier_commission, :decimal, precision: 8, scale: 2, default: 0.0, null: false
  end
end
