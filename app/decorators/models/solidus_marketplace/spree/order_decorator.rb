# frozen_string_literal: true

module SolidusMarketplace
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.has_many :stock_locations, through: :shipments
        base.has_many :suppliers, through: :stock_locations
      end

      def supplier_total(user_or_supplier)
        supplier = user_or_supplier.is_a?(::Spree::Supplier) ? user_or_supplier : user_or_supplier.supplier
        shipments = self.shipments.by_supplier(supplier)
        commissions = shipments.map(&:supplier_commission_total)
        ::Spree::Money.new(commissions.sum)
      end

      def supplier_earnings_map
        suppliers.map do |s|
          {
            name: s.name,
            earnings: supplier_total(s),
            paypal_email: s.paypal_email
          }
        end
      end

      # Once order is finalized we want to notify the suppliers of their drop ship orders.
      # Here we are handling notification by emailing the suppliers.
      # If you want to customize this you could override it as a hook for notifying
      # a supplier with a API request instead.
      def finalize_with_supplier!
        finalize_without_supplier!
        shipments.each do |shipment|
          next unless SolidusMarketplace::Config.send_supplier_email && shipment.supplier.present?

          begin
            Spree::MarketplaceOrderMailer.supplier_order(shipment.id).deliver!
          rescue StandardError => e # Errno::ECONNREFUSED => ex
            Rails.logger.debug e.message
            Rails.logger.debug e.backtrace.join("\n")
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
            return true # always return true so that failed email doesn't crash app.
          end
        end
      end

      ::Spree::Order.prepend self
    end
  end
end
