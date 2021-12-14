# frozen_string_literal: true

describe 'Admin - Suppliers', type: :feature, js: true do
  let(:country) { create(:country, name: 'United States') }
  let(:state) { create(:state, name: "Vermont", country: country) }
  let!(:supplier) { create(:supplier) }

  describe 'as an MarketMaker (aka admin)' do
    before do
      visit spree.admin_path
      within '[data-hook=admin_tabs]' do
        click_link 'Suppliers'
      end
    end

    xit 'should be able to create new supplier' do
      click_link 'New Supplier'
      check 'supplier_active'
      fill_in 'supplier[name]', with: 'Test Supplier'
      fill_in 'supplier[user_id]', with: '1'
      fill_in 'supplier[url]', with: 'http://www.test.com'
      fill_in 'supplier[commission_flat_rate]', with: '0'
      fill_in 'supplier[commission_percentage]', with: '0'
      fill_in 'supplier[address_attributes][firstname]', with: 'First'
      fill_in 'supplier[address_attributes][lastname]', with: 'Last'
      fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'supplier[address_attributes][city]', with: 'Test City'
      fill_in 'supplier[address_attributes][zipcode]', with: '55555'
      select2 'United States of America', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
      click_button 'Create'
      expect(page).to have_content('Supplier "Test Supplier" has been successfully created!')
    end

    xit 'should be able to delete supplier' do
      click_icon 'delete'
      page.driver.browser.switch_to.alert.accept
      within 'table' do
        expect(page).not_to have_content(supplier.name)
      end
    end

    xit 'should be able to edit supplier' do
      click_icon 'edit'
      check 'supplier_active'
      fill_in 'supplier[name]', with: 'Test Supplier'
      fill_in 'supplier[user_id]', with: '1'
      fill_in 'supplier[url]', with: 'http://www.test.com'
      fill_in 'supplier[commission_flat_rate]', with: '0'
      fill_in 'supplier[commission_percentage]', with: '0'
      fill_in 'supplier[address_attributes][firstname]', with: 'First'
      fill_in 'supplier[address_attributes][lastname]', with: 'Last'
      fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'supplier[address_attributes][city]', with: 'Test City'
      fill_in 'supplier[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
      click_button 'Update'
      expect(page).to have_content('Supplier "Test Supplier" has been successfully updated!')
    end
  end

  describe 'as a Supplier' do
    let!(:user) { create(:supplier_admin) }

    before do
      allow(Spree::Admin::SuppliersController).to receive_messages(try_spree_current_user: user)
      allow(Spree::OrdersController).to receive_messages(try_spree_current_user: user)
      visit spree.edit_admin_supplier_path(user.supplier)
    end

    ['Products', 'Stock', 'Stock Locations', 'Profile', 'Orders', 'Suppliers'].each do |link|
      xit "should see link to access to #{link}" do
        within '[data-hook=admin_tabs]' do
          expect(page).to have_link(link)
        end
      end
    end

    ['Overview', 'Reports', 'Configuration', 'Promotions'].each do |link|
      xit "should not see link to access to #{link}" do
        within '[data-hook=admin_tabs]' do
          expect(page).not_to have_link(link)
        end
      end
    end

    %w[
      supplier_active
      supplier_featured
      s2id_supplier_user_ids
      supplier_commission_flat_rate
      supplier supplier_commission_percentage
    ].each do |field|
      xit "should not be able to update #{field}" do
        expect(page).not_to have_css("##{field}")
      end
    end

    context 'when update' do
      before do
        fill_in 'supplier[name]', with: 'Test Supplier'
        fill_in 'supplier[email]', with: user.email
        fill_in 'supplier[url]', with: 'http://www.test.com'
        fill_in 'supplier[address_attributes][firstname]', with: 'First'
        fill_in 'supplier[address_attributes][lastname]', with: 'Last'
        fill_in 'supplier[address_attributes][address1]', with: '1 Test Drive'
        fill_in 'supplier[address_attributes][city]', with: 'Test City'
        fill_in 'supplier[address_attributes][zipcode]', with: '55555'
        select2 'United States', from: 'Country'
        select2 'Vermont', from: 'State'
        fill_in 'supplier[address_attributes][phone]', with: '555-555-5555'
        click_button 'Update'
      end

      xit 'have success message' do
        expect(page).to have_content('Supplier "Test Supplier" has been successfully updated!')
      end

      xit 'keep in edit supplier path' do
        expect(page).to have_current_path(spree.edit_admin_supplier_path(user.reload.supplier), ignore_query: true)
      end
    end
  end

  context 'with an User other than the suppliers' do
    let(:user) { create(:user, password: 'secret') }
    let(:supplier) { create(:supplier) }

    it 'is unauthorized' do
      visit spree.root_path
      click_link 'Login'
      fill_in 'spree_user[email]', with: user.email
      fill_in 'spree_user[password]', with: user.password
      click_button 'Login'
      visit spree.edit_admin_supplier_path(supplier)
      expect(page).to have_content('Authorization Failure')
    end
  end
end
