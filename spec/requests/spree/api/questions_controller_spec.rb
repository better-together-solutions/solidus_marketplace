# frozen_string_literal: true

require 'spec_helper'

describe Spree::Api::QuestionsController, type: :request do
  let(:user) { create(:supplier_admin) }
  let(:supplier) { create(:supplier, admins: [user]) }
  let!(:question) { create(:question, supplier: supplier) }
  let(:buyer) { create(:user) }

  before do
    user.generate_spree_api_key!
    buyer.generate_spree_api_key!
  end

  describe '#index' do
    it 'returns questions asked to supplier' do
      get '/api/questions',
        headers: { Authorization: "Bearer #{user.spree_api_key}" }
      expect(json_response['questions'].count).to eq(1)
    end
  end

  describe '#create' do
    context 'with valid params' do
      let(:valid_params) {
        {
          question: {
            question_text: 'foo?',
            supplier_id: supplier.id,
            created_by_id: buyer.id
          }
        }
      }

      it 'succesfully create question' do
        expect do
          post '/api/questions',
            params: valid_params,
            headers: { Authorization: "Bearer #{user.spree_api_key}" }
        end.to change { Spree::Question.count }.by(1)
      end
    end
  end

  describe '#update' do
    it 'update successfully' do
      question_text = 'bar?'
      put "/api/questions/#{question.id}",
        params: { question: { question_text: question_text } },
        headers: { Authorization: "Bearer #{user.spree_api_key}" }

      expect(json_response['question_text']).to eq(question_text)
    end
  end

  describe '#destroy' do
    it 'destroy successfully' do
      expect do
        delete "/api/questions/#{question.id}",
          headers: { Authorization: "Bearer #{user.spree_api_key}" }
      end.to change { Spree::Question.count }.by(-1)
    end
  end
end
