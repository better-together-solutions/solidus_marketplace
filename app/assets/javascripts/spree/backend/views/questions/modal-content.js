//= require spree/backend/templates/questions/modal-content
//= require spree/backend/views/answers/new
//= require spree/backend/views/answers/answer-list

Spree.Views.Questions.ModalContent = Backbone.View.extend({
  initialize: function(options){
    this.render();
  },
  template: HandlebarsTemplates['questions/modal-content'],

  render: function() {
    this.$el.html(this.template());
    const collection = this.model.get('answers');

    new Spree.Views.Answers.AnswerList({
      el: $('.answers'),
      parent: this.model,
      collection: collection
    });
    new Spree.Views.Answers.New({
      el: $('.new-answer'),
      collection: collection
    });
  }
});
