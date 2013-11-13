HackUnderflow.Views.QuestionDetailQuestion = Backbone.View.extend({
  template: JST["questions/_question"],

  render: function() {
    renderedContent = this.template({
      question: this.model,
      current_user: null
    });

    this.$el.html(renderedContent);
    return this;
  }
});