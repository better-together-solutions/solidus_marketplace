# frozen_string_literal: true

require 'cancan'

module Spree
  module PermissionSets
    module Supplier
      class QuestionAbility < PermissionSets::Base
        def activate!
          can :manage, Spree::Question, supplier_id: user.supplier_id
          can :manage, Spree::Answer, question_id: question_ids
        end

        private

        def question_ids
          user.supplier.questions.pluck(:id)
        end
      end
    end
  end
end
