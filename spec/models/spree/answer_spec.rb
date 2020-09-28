# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Answer, type: :model do
  describe 'associations' do
    it { is_expected.to respond_to(:question) }
    it { is_expected.to respond_to(:user) }
  end
end
