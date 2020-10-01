//= require spree/backend/views/answers/answer-item

Spree.Views.Answers.AnswerList = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.collection, 'add', this.add);
    this.listenTo(this.collection, 'reset', this.reset);
  },

  add: function(answer) {
    var view = new Spree.Views.Answers.AnswerItem({model: answer});
    view.render();
    this.$el.append(view.el);
  },

  reset: function() {
    const add = this.add;
    this.collection.each(function(answer) {
      add(answer)
    })
  }
});
