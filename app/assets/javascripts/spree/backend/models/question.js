//=require spree/backend/collections/answers

Spree.Models.Question = Backbone.Model.extend({
  urlRoot: Spree.pathFor('api/questions'),

  relations: {
    'answers': Spree.Collections.Answers
  }
});

Spree.Models.Question.fetch = function(id, opts) {
  const options = (opts || {});
  const model = new Spree.Models.Question({
    id: id,
    answers: []
  });
  model.fetch(options);
  return model;
}
