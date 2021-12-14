# frozen_string_literal: true

require 'cancan'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::PermissionSets::Supplier::StaffAbility do
  subject { ability }

  let(:ability) { Spree::Ability.new(user) }
  let(:supplier) { create(:supplier) }
  let(:supplier_staff_role) { build(:role, name: 'supplier_staff') }
  let(:user) { create(:user, supplier: supplier) }
  let(:token) { nil }
  let(:product) { create(:product) }
  let(:variant) { product.master }
  let(:other_supplier) { create(:supplier) }

  before do
    user.spree_roles << supplier_staff_role
    described_class.new(ability).activate!
  end

  context 'with Product' do
    context 'when requested by another suppliers user' do
      let(:other_resource) { create(:product) }

      before do
        other_resource.add_supplier!(create(:supplier))
        other_resource.reload
      end

      it { expect(ability).not_to be_able_to :read, other_resource }
      it { expect(ability).not_to be_able_to :admin, other_resource }
      it { expect(ability).not_to be_able_to :edit, other_resource }
    end

    context 'when requested by suppliers user' do
      let(:resource) { create(:product) }

      before do
        resource.add_supplier!(user.supplier)
        resource.reload
      end

      it { expect(ability).to be_able_to :read, resource }
      it { expect(ability).to be_able_to :admin, resource }
      it { expect(ability).to be_able_to :edit, resource }
    end
  end

  context 'with StockItem' do
    let(:resource) { Spree::StockItem }

    context 'when requested by another suppliers user' do
      let(:resource) {
        other_supplier.stock_locations.first.stock_items.first
      }

      before do
        variant.product.add_supplier! other_supplier
      end

      it { expect(ability).not_to be_able_to :admin, resource }
    end

    context 'when requested by suppliers user' do
      let(:resource) {
        user.supplier.stock_locations.first.stock_items.first
      }

      before do
        variant.product.add_supplier! user.supplier
      end

      it { expect(ability).to be_able_to :admin, resource }
    end
  end

  context 'with StockLocation' do
    context 'when requested by another suppliers user' do
      let(:resource) {
        other_supplier.stock_locations.first
      }

      before do
        variant.product.add_supplier! other_supplier
      end

      it { expect(ability).not_to be_able_to :read, resource }
    end

    context 'when requested by suppliers user' do
      let(:resource) {
        user.supplier.stock_locations.first
      }

      before do
        variant.product.add_supplier! user.supplier
      end

      it { expect(ability).to be_able_to :read, resource }
    end
  end
end
