# frozen_string_literal: true

json.(answer, *answer_attributes)
json.user do
  json.partial!('spree/api/users/user', user: answer.user)
end
