# frozen_string_literal: true

describe Spree::Stock::Splitter::Marketplace do
  subject(:splitter) { described_class.new(stock_location) }

  let(:stock_location) { create(:stock_location) }
  let(:supplier1) { create(:supplier, stock_locations: [stock_location]) }
  let(:supplier2) { create(:supplier, stock_locations: [stock_location]) }
  let(:variant) do
    variant = create(:variant)
    variant.product.add_supplier!(supplier1)
    variant.reload.supplier_variants.find_by(supplier_id: supplier1.id).
      update(cost: 5)
    variant.product.add_supplier!(supplier2)
    variant.reload.supplier_variants.find_by(supplier_id: supplier2.id).
      update(cost: 6)
    variant
  end

  it 'splits packages for suppliers to ship' do
    package = Spree::Stock::Package.new(stock_location)
    2.times { package.add build(:inventory_unit, variant: variant) }
    packages = splitter.split([package])
    expect(packages.count).to eq(2)
  end
end
