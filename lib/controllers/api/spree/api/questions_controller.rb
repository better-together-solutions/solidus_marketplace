# frozen_string_literal: true

module Spree
  module Api
    class QuestionsController < ::SolidusMarketplace::ApiController
      private

      def permitted_question_attributes
        permitted_attributes.question_attributes
      end
    end
  end
end
