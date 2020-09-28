# frozen_string_literal: true

module Spree
  class Question < Spree::Base
    has_many :answers, dependent: :destroy
    belongs_to :created_by, class_name: Spree::UserClassHandle.new
    belongs_to :supplier, class_name: 'Spree::Supplier'
    belongs_to :product, class_name: 'Spree::Product', optional: true
  end
end
