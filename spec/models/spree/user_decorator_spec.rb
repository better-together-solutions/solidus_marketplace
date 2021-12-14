# frozen_string_literal: true

# rubocop:disable RSpec/DescribeClass
describe Spree.user_class do
  # rubocop:enable RSpec/DescribeClass
  let(:supplier_admin_role) { build(:role, name: 'supplier_admin') }
  let(:admin_role) { build :admin_role }
  let(:user) { build :user }

  it { is_expected.to respond_to(:supplier) }
  it { is_expected.to respond_to(:variants) }

  describe '#supplier?' do
    it 'returns true if user is a supplier' do
      user.supplier = build :supplier
      expect(user.supplier?).to eq true
    end

    it 'returns false if user is not a supplier' do
      expect(user.supplier?).to eq false
    end
  end

  describe '#supplier_admin?' do
    it 'returns true if user has supplier admin role' do
      user.spree_roles << supplier_admin_role
      expect(user.supplier_admin?).to eq true
    end

    it "returns false if user doesn't have a supplier admin role" do
      expect(user.supplier_admin?).to eq false
    end
  end

  describe '#market_maker?' do
    it 'returns true if user has an admin role' do
      user.spree_roles << admin_role
      expect(user.market_maker?).to eq true
    end

    it "returns false if user doesn't have an admin role" do
      expect(user.market_maker?).to eq false
    end
  end

  describe '#admin_role?' do
    it 'returns false if user is not an admin' do
      expect(user.admin_role?).to eq false
    end

    it 'returns true if user is an admin' do
      user.spree_roles << admin_role
      expect(user.admin_role?).to eq true
    end
  end
end
