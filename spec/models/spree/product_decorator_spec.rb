# frozen_string_literal: true

describe Spree::Product do
  let!(:product) { create(:product) }
  let(:supplier1) { create(:supplier) }
  let(:supplier2) { create(:supplier) }

  describe '#add_supplier!' do
    context 'when passed a supplier' do
      it "adds the supplier to product's list of supppliers" do
        product.add_supplier!(supplier1)
        expect(product.reload.suppliers).to include(supplier1)
      end
    end

    context 'when passed a supplier_id' do
      it "adds the supplier to product's list of supppliers" do
        product.add_supplier!(supplier2.id)
        expect(product.reload.suppliers).to include(supplier2)
      end
    end
  end

  describe '#add_suppliers!' do
    before do
      product.add_suppliers!([supplier1.id, supplier2.id])
    end

    it "add supplier1 to the product's list of suppliers" do
      expect(product.reload.suppliers).to include(supplier1)
    end

    it "add supplier2 to the product's list of suppliers" do
      expect(product.reload.suppliers).to include(supplier2)
    end
  end

  describe '#remove_suppliers!' do
    before do
      product.add_suppliers!([supplier1.id, supplier2.id])
    end

    it "removes multiple suppliers from the product's list of suppliers" do
      product.remove_suppliers!([supplier1.id, supplier2.id])
      expect(product.suppliers).to be_empty
    end
  end

  describe '#supplier?' do
    it 'return false as default' do
      expect(product.supplier?).to eq false
    end

    it 'returns true if one or more suppliers are present' do
      product.add_supplier!(create(:supplier))
      expect(product.reload.supplier?).to eq true
    end
  end
end
