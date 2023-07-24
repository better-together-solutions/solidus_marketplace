# frozen_string_literal: true

# This migration comes from solidus_marketplace (originally 20130216070944)
class ProductBelongsToSupplier < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_products, :supplier_id, :integer
    add_index :spree_products, :supplier_id
  end
end
