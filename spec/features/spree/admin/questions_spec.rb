# frozen_string_literal: true

require 'spec_helper'

describe 'Questions admin page', type: :feature, js: true do
  let(:user) { create(:supplier_admin) }
  let(:supplier) { create(:supplier, admins: [user]) }
  let!(:question) { create(:question, supplier: supplier, question_text: 'How much?') }
  let!(:answer) { create(:answer, question: question, user: user, answer_text: 'Answer0') }

  def login_user(user, password = 'secret')
    visit spree.admin_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Login'
  end

  before do
    login_user(user)
    visit spree.admin_questions_path
  end

  it 'render supplier questions' do
    expect(page).to have_content('How much?')
  end

  context 'with modal' do
    before do
      click_on('Reply')
    end

    it 'show answers' do
      expect(page).to have_content('Answer0')
    end

    it 'allow reply question' do
      find('.answer-input').fill_in with: 'Answer1'
      click_on('Create')
      expect(page).to have_content('Answer1')
    end
  end
end
