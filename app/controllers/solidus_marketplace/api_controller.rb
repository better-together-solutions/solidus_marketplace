# frozen_string_literal: true

module SolidusMarketplace
  class ApiController < ::Spree::Api::ResourceController
    helper SolidusMarketplace::ApiHelpers
  end
end

