# frozen_string_literal: true

json.questions(@questions) do |question|
  json.partial!('spree/api/questions/question', question: question)
end
json.partial! 'spree/api/shared/pagination', pagination: @questions
