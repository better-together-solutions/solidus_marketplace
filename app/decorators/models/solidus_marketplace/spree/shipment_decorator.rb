# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        base.belongs_to :order, class_name: '::Spree::Order', touch: true, inverse_of: :shipments
        base.has_many :payments, as: :payable
        base.scope :by_supplier, ->(supplier_id) {
                                   joins(:stock_location).where(spree_stock_locations: { supplier_id: supplier_id })
                                 }
        base.delegate :supplier, to: :stock_location
        base.whitelisted_ransackable_attributes = ["number", "state"]
      end

      def display_final_price_with_items
        Spree::Money.new final_price_with_items
      end

      def final_price_with_items
        item_cost + final_price
      end

      # TODO move commission to spree_marketplace?
      def supplier_commission_total
        ((final_price_with_items * supplier.commission_percentage / 100) + supplier.commission_flat_rate)
      end

      private

      def after_ship
        super

        return if supplier.blank?

        update_commission
      end

      def update_commission
        update(supplier_commission: supplier_commission_total)
      end

      ::Spree::Shipment.prepend self
    end
  end
end
