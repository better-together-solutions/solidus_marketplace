# frozen_string_literal: true

module Spree
  module Admin
    class QuestionsController < BaseController
      def index
        params[:q] ||= {}
        @search = Spree::Question.accessible_by(current_ability, :index)
          .ransack(params[:q])
        @questions = @search.result
          .page(params[:page])
          .per(params[:per_page] || Spree::Config[:orders_per_page])
      end
    end
  end
end
