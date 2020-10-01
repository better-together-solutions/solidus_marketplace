//= require spree/backend/templates/answers/new
//= require spree/backend/models/answer

Spree.Views.Answers.New = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.collection, 'update', this.render)
    this.render();
  },

  template: HandlebarsTemplates['answers/new'],

  events: {
    'click .submit': 'onSubmit'
  },

  onSubmit: function(e) {
    e.preventDefault();
    const input = $('.answer-input')
    const options = {
      success: this.onSuccess.bind(this),
      error: this.onError.bind(this)
    };
    this.collection.create({
      answer_text: input.val(),
      question_id: this.collection.parent.id
    }, options)
    input.val('');
  },

  onSuccess: function() {
    show_flash("success", Spree.translations.created_successfully);
  },

  onError: function(model, response, options) {
    show_flash("error", response.responseText);
  },

  render: function() {
    this.$el.html(this.template());
  }
});
