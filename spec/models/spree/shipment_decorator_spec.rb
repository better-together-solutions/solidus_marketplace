# frozen_string_literal: true

describe Spree::Shipment do
  describe 'Scopes' do
    let!(:supplier) { create(:supplier) }
    let(:stock_location1) { supplier.stock_locations.first }
    let(:stock_location2) { create(:stock_location, supplier: supplier) }
    let(:shipment1) { create(:shipment) }
    let(:shipment2) { create(:shipment, stock_location: stock_location1) }
    let(:shipment3) { create(:shipment) }
    let(:shipment4) { create(:shipment, stock_location: stock_location2) }
    let(:shipment5) { create(:shipment) }
    let(:shipment6) { create(:shipment, stock_location: stock_location1) }

    it '#by_supplier' do
      expect(described_class.by_supplier(supplier.id)).
        to match_array([shipment2, shipment4, shipment6])
    end
  end

  describe '#after_ship' do
    let(:supplier) { create(:supplier_with_commission) }
    let(:shipment) { create(:shipment, stock_location: supplier.stock_locations.first) }

    it 'captures payment if balance due' do
      skip 'TODO make it so!'
    end

    xit 'should track commission for shipment' do
      allow(shipment).to receive(:final_price_with_items).and_return(10.0)
      shipment.send(:after_ship)
      expect(shipment.reload.supplier_commission.to_f).to be(1.5)
    end
  end

  describe '#final_price_with_items' do
    let(:shipment) { build(:shipment) }

    it 'returns correct prices' do
      allow(shipment).to receive(:item_cost).and_return(50.0)
      allow(shipment).to receive(:final_price).and_return(5.5)
      expect(shipment.final_price_with_items.to_f).to be(55.5)
    end
  end
end
