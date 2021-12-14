# frozen_string_literal: true

describe Spree::Order do
  let!(:order) do
    order = create(:order_with_totals)
    order.line_items = [create(:line_item,
      variant: create(:variant_with_supplier)),
                        create(:line_item,
                          variant: create(:variant_with_supplier))]
    order.create_proposed_shipments
    order
  end

  describe '#finalize_with_supplier!' do
    before do
      allow(Spree::MarketplaceOrderMailer).to receive(:supplier_order)
    end

    after do
      SolidusMarketplace::Config.send_supplier_email = true
    end

    xit 'should deliver marketplace orders when SolidusMarketplace::Config[:send_supplier_email] == true' do
      order.shipments.each do |shipment|
        allow(Spree::MarketplaceOrderMailer)
          .to receive(:supplier_order)
          .with(shipment.id)
          .and_return(instance_double(Mail, deliver!: true))
      end

      order.finalize!
      order.reload

      order.shipments.each do |shipment|
        expect(shipment.line_items.first.variant.suppliers.first).to eql(shipment.supplier)
      end
    end

    xit 'should NOT deliver marketplace orders when SolidusMarketplace::Config[:send_supplier_email] == false' do
      SolidusMarketplace::Config.send_supplier_email = false

      order.finalize!
      order.reload

      order.shipments.each do |shipment|
        expect(shipment.line_items.first.variant.suppliers.first).to eql(shipment.supplier)
      end
    end
  end

  xdescribe '#supplier_total' do
    let!(:order) {
      create(:completed_order_from_supplier_with_totals,
        ship_address: create(:address))
    }
    let(:supplier) { order.suppliers.first }
    let(:expected_supplier_total) { Spree::Money.new(15.00) }

    context 'when passed a supplier' do
      it 'returns the total commission earned for the order for a given supplier' do
        expect(order.supplier_total(supplier)).to eq(expected_supplier_total)
      end
    end
  end
end
