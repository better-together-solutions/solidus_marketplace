# frozen_string_literal: true

describe 'Admin - Marketplace Settings', type: :feature do
  let(:user) { create(:admin_user) }

  before do
    visit spree.admin_path
    within '[data-hook=admin_tabs]' do
      click_link 'Settings'
    end
    within 'ul[data-hook=admin_configurations_sidebar_menu]' do
      click_link 'Marketplace Settings'
    end

    uncheck 'send_supplier_email'
  end

  xit 'should be able to be updated default_commission_flat_rate' do
    fill_in 'default_commission_flat_rate', with: 0.30
    click_button 'Update'
    expect(find_field('default_commission_flat_rate').value.to_f).to be(0.3)
  end

  xit 'should be able to be updated default_commission_percentage' do
    fill_in 'default_commission_percentage', with: 10
    click_button 'Update'
    expect(find_field('default_commission_percentage').value.to_f).to be(10.0)
  end
end
