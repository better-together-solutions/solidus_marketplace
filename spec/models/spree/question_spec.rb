# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Question, type: :model do
  describe 'associations' do
    it { is_expected.to respond_to(:answers) }
    it { is_expected.to respond_to(:created_by) }
    it { is_expected.to respond_to(:supplier) }
    it { is_expected.to respond_to(:product) }
  end
end
