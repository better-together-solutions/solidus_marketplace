# frozen_string_literal: true

SolidusMarketplace.configure do |config|
  # Determines if send orders directly to supplier.
  # config.automatically_deliver_orders_to_supplier = true

  # Default flat rate to charge suppliers per order for commission.
  # config.default_commission_flat_rate = 0.0

  # Default percentage to charge suppliers per order for commission.
  # config.default_commission_percentage = 0.0

  # Determines whether or not to email a new supplier their welcome email.
  # config.send_supplier_email = true
end
