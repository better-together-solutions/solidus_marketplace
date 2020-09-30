# frozen_string_literal: true

require 'cancan'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::PermissionSets::Supplier::QuestionAbility do
  let(:ability) { Spree::Ability.new(user) }
  let(:supplier) { create(:supplier) }
  let(:supplier_role) { build(:role, name: 'supplier_admin') }
  let(:user) { create(:user, supplier: supplier) }
  subject { ability }
  let(:resource) { Spree::Question }

  before(:each) do
    user.spree_roles << supplier_role
    described_class.new(ability).activate!
  end

  it 'allow manage questions' do
    expect(ability).to be_able_to :manage, resource
  end
end
