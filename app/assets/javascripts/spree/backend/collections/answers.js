//= require spree/backend/models/answer

Spree.Collections.Answers = Backbone.Collection.extend({
  model: Spree.Models.Answer,

  url: function() {
    return this.parent.url() + '/answers';
  }
});
