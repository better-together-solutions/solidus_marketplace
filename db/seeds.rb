# frozen_string_literal: true

%w(
  marketplace_roles
).each do |seed|
  Rails.logger.debug "Loading seed file: #{seed}"
  require_relative "default/spree/#{seed}"
end
