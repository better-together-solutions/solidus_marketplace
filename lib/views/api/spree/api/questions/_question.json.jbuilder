# frozen_string_literal: true

json.(question, *question_attributes)
json.answers(question.answers) do |answer|
  json.partial!('spree/api/answers/answer', answer: answer)
end
