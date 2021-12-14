# frozen_string_literal: true

describe Spree::Supplier do
  let(:supplier) { create(:supplier) }

  it { is_expected.to respond_to(:address) }
  it { is_expected.to respond_to(:products) }
  it { is_expected.to respond_to(:stock_locations) }
  it { is_expected.to respond_to(:variants) }

  describe '#deleted?' do
    it 'return false without deleted_at' do
      supplier.deleted_at = nil
      expect(supplier.deleted_at?).to be(false)
    end

    it 'return true with deleted_at' do
      supplier.deleted_at = Time.zone.now
      expect(supplier.deleted_at?).to be(true)
    end
  end

  describe '#create_stock_location' do
    before do
      supplier
    end

    it 'returns created stock location' do
      expect(Spree::StockLocation.count).to eq(1)
    end

    it 'set active created stock location' do
      expect(Spree::StockLocation.active.count).to eq(1)
    end

    it 'set same supplier address country for stock location country' do
      expect(Spree::StockLocation.first.country).to eql(supplier.address.country)
    end

    it 'set supplier in created stock location' do
      expect(Spree::StockLocation.first.supplier).to eql(supplier)
    end
  end

  xdescribe '#send_welcome' do
    let(:supplier) { build(:supplier) }
    let(:mail_message) { instance_double('Mail::Message') }

    before do
      allow(Spree::SupplierMailer).to receive(:welcome)
    end

    context 'with SolidusMarketplace::Config[:send_supplier_email] == false' do
      before do
        SolidusMarketplace::Config.send_supplier_email = false
      end

      it 'does not send' do
        expect(Spree::SupplierMailer).not_to have_received(:welcome).
          with(an_instance_of(Integer))
      end
    end

    context 'with SolidusMarketplace::Config[:send_supplier_email] == true' do
      before do
        SolidusMarketplace::Config.send_supplier_email = true
      end

      it 'sends welcome email' do
        expect(Spree::SupplierMailer).to have_received(:welcome)
          .with(an_instance_of(Integer))
      end
    end
  end

  describe '#set_commission' do
    before do
      SolidusMarketplace::Config.default_commission_flat_rate = 1
      SolidusMarketplace::Config.default_commission_percentage = 1
    end

    it 'returns correct flat_rate commission value' do
      expect(supplier.commission_flat_rate.to_f).to eq(1.0)
    end

    it 'returns correct percentage commission value' do
      expect(supplier.commission_percentage.to_f).to eq(10.0)
    end

    context 'with custom commission applied' do
      before do
        supplier.update(commission_flat_rate: 123,
          commission_percentage: 25)
      end

      it 'returns correct flat_rate commission value' do
        expect(supplier.commission_flat_rate).to eq(123.0)
      end

      it 'returns correct percentage commission value' do
        expect(supplier.commission_percentage).to eq(25.0)
      end
    end
  end

  describe '#shipments' do
    let(:stock_location1) { supplier.stock_locations.first }
    let(:stock_location2) { create(:stock_location, supplier: supplier) }
    let(:shipment1) { create(:shipment) }
    let(:shipment2) { create(:shipment, stock_location: stock_location1) }
    let(:shipment3) { create(:shipment) }
    let(:shipment4) { create(:shipment, stock_location: stock_location2) }
    let(:shipment5) { create(:shipment) }
    let(:shipment6) { create(:shipment, stock_location: stock_location1) }

    it 'returns shipments for suppliers stock locations' do
      expect(supplier.shipments).
        to match_array([shipment2, shipment4, shipment6])
    end
  end
end
