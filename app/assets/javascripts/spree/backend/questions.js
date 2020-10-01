//= require spree/backend/models/question
//= require spree/backend/views/questions/modal-content

Spree.ready(function() {
  if ($('.question-modal-content').length) {
    $('.question-modal-content').each(function() {
      var el = $(this);
      var model = new Spree.Models.Question.fetch(el.data('question_id'));
      new Spree.Views.Questions.ModalContent({
        el: el,
        model: model
      });
    });
  }
});
