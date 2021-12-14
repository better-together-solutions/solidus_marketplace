# frozen_string_literal: true

describe Spree::StockLocation do
  subject(:stock_location) { create(:stock_location, backorderable_default: true) }

  it { is_expected.to respond_to(:supplier) }

  context 'when propagate variants' do
    let(:variant) { build(:variant) }
    let(:stock_item) { stock_location.propagate_variant(variant) }

    context 'with backorderable default' do
      before { stock_location.backorderable_default = true }

      xit 'passes backorderable default config' do
        expect(stock_item.backorderable).to eq true
      end
    end

    context 'without backorderable default' do
      before { stock_location.backorderable_default = false }

      xit 'not passes backorderable default config' do
        expect(stock_item.backorderable).to eq false
      end
    end

    context 'with non supplier variants' do
      before { stock_location.supplier_id = create(:supplier).id }

      it 'does not propagate' do
        expect(stock_item).to be_nil
      end
    end
  end
end
