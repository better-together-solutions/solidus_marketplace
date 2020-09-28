# frozen_string_literal: true

module Spree
  class Answer < Spree::Base
    belongs_to :question, class_name: 'Spree::Question'
    belongs_to :user, class_name: Spree::UserClassHandle.new
  end
end
