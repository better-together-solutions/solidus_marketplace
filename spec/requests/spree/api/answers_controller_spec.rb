# frozen_string_literal: true

require 'spec_helper'

describe Spree::Api::AnswersController, type: :request do
  let(:user) { create(:supplier_admin) }
  let(:supplier) { create(:supplier, admins: [user]) }
  let!(:question) { create(:question, supplier: supplier) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:params) {
    {
      answer: {
        answer_text: 'bar',
        question_id: question.id
      }
    }
  }

  before do
    user.generate_spree_api_key!
  end

  describe '#index' do
    it 'return answers for question' do
      get "/api/questions/#{question.id}/answers",
        headers: { Authorization: "Bearer #{user.spree_api_key}" }
      expect(json_response['answers'].count).to eq(1)
    end
  end

  describe '#show' do
    it 'return correctly answer' do
      get "/api/questions/#{question.id}/answers/#{answer.id}",
        headers: { Authorization: "Bearer #{user.spree_api_key}" }

      expect(json_response['answer_text']).to eq 'foo'
    end
  end

  describe '#create' do
    it 'succesful create' do
      expect do
        post "/api/questions/#{question.id}/answers",
          headers: { Authorization: "Bearer #{user.spree_api_key}" },
          params: params
      end.to change { Spree::Answer.count }.by(1)
    end

    context 'with user_id param' do
      it 'use request user_id for answer' do
        other_user = create(:user)
        params[:answer][:user_id] = other_user.id
        post "/api/questions/#{question.id}/answers",
          headers: { Authorization: "Bearer #{user.spree_api_key}" },
          params: params
        expect(json_response['user']['email']).to eq(user.email)
      end
    end
  end

  describe '#update' do
    it 'successful update' do
      put "/api/questions/#{question.id}/answers/#{answer.id}",
        headers: { Authorization: "Bearer #{user.spree_api_key}" },
        params: params.merge(answer: { answer_text: 'baz' })
      expect(json_response['answer_text']).to eq('baz')
    end
  end

  describe '#destroy' do
    it 'successful destroy' do
      expect do
        delete "/api/questions/#{question.id}/answers/#{answer.id}",
          headers: { Authorization: "Bearer #{user.spree_api_key}" }
      end.to change { Spree::Answer.count }.by(-1)
    end
  end
end
