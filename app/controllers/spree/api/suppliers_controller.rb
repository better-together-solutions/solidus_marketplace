# frozen_string_literal: true

module Spree
  module Api
    class SuppliersController < Spree::Api::BaseController
      def index
        @suppliers = if params[:ids]
                       Spree::Supplier.accessible_by(current_ability, :read).
                         where(id: params[:ids].split(',')).order(:name)
                     else
                       Spree::Supplier.accessible_by(current_ability, :read).
                         order(:name).ransack(params[:q]).result
                     end

        @suppliers = paginate(@suppliers)
        respond_with(@suppliers)
      end
    end
  end
end
