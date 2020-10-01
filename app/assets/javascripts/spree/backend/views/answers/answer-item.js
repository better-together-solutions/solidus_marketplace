//= require spree/backend/templates/answers/answer-item

Spree.Views.Answers.AnswerItem = Backbone.View.extend({
  initialize: function(options) {
    this.listenTo(this.model, 'change', this.render);
  },

  template: HandlebarsTemplates['answers/answer-item'],

  render: function() {
    this.$el.html(this.template({
      answer: this.model.toJSON()
    }));
  }
});
