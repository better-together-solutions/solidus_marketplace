# frozen_string_literal: true

describe 'Admin - Product Stock Management', type: :feature, js: true do
  let(:user) { create(:supplier_admin) }
  let(:supplier1) { user.supplier }
  let(:supplier2) { create(:supplier) }
  let(:product) do
    product = create(:product)
    product.add_supplier!(supplier1)
    product
  end
  let(:stock_location) { create(:stock_location, name: 'Big Store', supplier: user.supplier) }

  describe 'as Admin' do
    xit 'should display all existing stock item locations' do
      login_user create(:admin_user)
      visit spree.stock_admin_product_path(product)

      within '.stock_location_info' do
        expect(page).to have_content(supplier1.name)
      end
    end
  end

  describe 'as Supplier' do
    before do
      visit '/admin/products'
      click_link 'Stock Locations'
    end

    context 'when visit product path' do
      before do
        visit spree.stock_admin_product_path(product)
      end

      xit 'should display suppliers stock locations' do
        within '.stock_location_info' do
          expect(page).to have_content(supplier1.name)
        end
      end

      xit 'should not display suppliers from other stock locations' do
        within '.stock_location_info' do
          expect(page).not_to have_content(supplier2.name)
        end
      end
    end

    context 'when create a new stock location' do
      before do
        visit spree.new_admin_stock_location_path
        fill_in "Name", with: "London"
        check "Active"
        click_button "Create"
      end

      xit { expect(page).to have_content("successfully created") }
      xit { expect(page).to have_content("London") }
    end

    xit "can delete an existing stock location", js: true do
      visit current_path

      within_row(2) { click_icon :delete }
      page.driver.browser.switch_to.alert.accept
      # Wait for API request to complete.
      sleep(1)
      visit current_path

      expect(find('#listing_stock_locations')).not_to have_content("NY Warehouse")
    end

    context "when update an existing stock location" do
      before do
        visit current_path

        within_row(1) { click_icon :edit }
        fill_in "Name", with: "London"
        click_button "Update"
      end

      xit { expect(page).to have_content("successfully updated") }
      xit { expect(page).to have_content("London") }
    end

    xit "can deactivate an existing stock location" do
      visit current_path

      within_row(1) { click_icon :edit }
      uncheck "Active"
      click_button "Update"

      expect(find('#listing_stock_locations')).to have_content("Inactive")
    end
  end
end
