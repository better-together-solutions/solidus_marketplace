# frozen_string_literal: true

module Spree
  module Api
    class AnswersController < ::SolidusMarketplace::ApiController
      before_action :normalize_params, only: %i[create]

      private

      def permitted_answer_attributes
        permitted_attributes.answer_attributes
      end

      def normalize_params
        params[:answer][:user_id] = current_api_user.id
      end
    end
  end
end
