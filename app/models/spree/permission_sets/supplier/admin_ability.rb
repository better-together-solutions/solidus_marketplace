# frozen_string_literal: true

require 'cancan'

module Spree
  module PermissionSets
    module Supplier
      class AdminAbility < PermissionSets::Base

        def activate!
          can :manage,
              Spree.user_class,
              supplier_id: user.supplier_id

          can :update_email,
              Spree.user_class

          can :manage, :api_key

          can :manage,
              Spree::Role,
              name: ['supplier_admin', 'supplier_staff']

          cannot %i[read],
              Spree::Product
          
          can %i[admin create update read stock],
              Spree::Product,
              suppliers: { id: user.supplier_id }

          can %i[admin create update destroy read],
              Spree::Variant

          can %i[admin read index update edit],
              Spree::Shipment,
              order: { state: 'complete' },
              stock_location: { supplier_id: user.supplier_id }

          can %i[admin read],
              Spree::ReturnAuthorization,
              stock_location: { supplier_id: user.supplier_id }

          can %i[admin read],
              Spree::CustomerReturn,
              stock_location: { supplier_id: user.supplier_id }

          cannot :read,
              Spree::StockItem

          can %i[admin index create edit read update],
              Spree::StockItem,
              stock_location: { supplier_id: user.supplier_id }

          cannot :read,
              Spree::StockLocation

          can %i[admin manage create update],
              Spree::StockLocation,
              supplier_id: user.supplier_id,
              active: true

          can %i[admin manage create],
              Spree::StockMovement,
              stock_item: {
                stock_location: {
                  supplier_id: user.supplier_id
                }
              }

          can %i[admin read update],
              Spree::Supplier,
              id: user.supplier_id

          cannot %i[create index],
              Spree::Supplier

          can %i[read admin sales_total],
              :reports

          can %i[admin index edit update cancel read cart resend fire approve],
              Spree::Order,
              stock_locations: { supplier_id: user.supplier_id }

          can %i[admin manage create],
              Spree::Image

          if defined?(Spree::SalePrice)
            can %i[admin manage create update],
                Spree::SalePrice
          end
        end
      end
    end
  end
end
