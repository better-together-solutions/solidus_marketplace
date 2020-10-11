# frozen_string_literal: true

describe 'Reports', type: :feature, js: true do
  stub_authorization!

  describe 'Earnings' do
    it 'renders correctly' do
      visit spree.earnings_admin_reports_path
      expect(page).to have_content(I18n.t('spree.earnings'))
    end
  end
end
