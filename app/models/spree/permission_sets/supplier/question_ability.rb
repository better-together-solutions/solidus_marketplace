# frozen_string_literal: true

require 'cancan'

module Spree
  module PermissionSets
    module Supplier
      class QuestionAbility < PermissionSets::Base
        def activate!
          can :manage, Spree::Question, supplier_id: user.supplier_id
        end
      end
    end
  end
end
