# frozen_string_literal: true

# This migration comes from solidus_marketplace (originally 20140416184616)
class MigratePaymentAndCommission < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_payments, :payable_id, :integer
    add_column :spree_payments, :payable_type, :string
    add_index :spree_payments, [:payable_id, :payable_type]
  end
end
