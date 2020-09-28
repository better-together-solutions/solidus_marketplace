# frozen_string_literal: true

# This module is responsible for managing what attributes can be updated
# through the api. It also overrides Spree::Permitted attributes to allow the
# solidus api to accept nested params for subscription models as well

module SolidusMarketplace
  module PermittedAttributes
    class << self
      @@supplier_attributes = [
        :id,
        :address_id,
        :commission_flat_rate,
        :commission_percentage,
        :user_id,
        :name,
        :url,
        :deleted_at,
        :tax_id,
        :token,
        :slug,
        :paypal_email
      ]

      mattr_reader(:supplier_attributes)
    end

    def question_attributes
      %i[
        id
        question_text
        created_by_id
        supplier_id
        product_id
      ]
    end

    def answer_attributes
      %i[
        id
        answer_text
        question_id
        user_id
      ]
    end
  end
end
