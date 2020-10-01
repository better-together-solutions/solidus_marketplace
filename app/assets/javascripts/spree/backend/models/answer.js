Spree.Models.Answer = Backbone.Model.extend({
  paramRoot: 'answer',
  urlRoot: function() {
    return Spree.pathFor('api/questions/' + this.get('question_id') + '/answers');
  }
});
