# frozen_string_literal: true

json.answers(@answers) do |answer|
  json.partial!('spree/api/answers/answer', answer: answer)
end
json.partial! 'spree/api/shared/pagination', pagination: @answers
