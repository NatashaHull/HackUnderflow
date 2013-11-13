HackUnderflow.Views.QuestionDetailAnswer = Backbone.View.extend({
  template: JST["answers/_answer"],

  render: function() {
    renderedContent = this.template({
      answer: this.model,
      current_user: null
    });

    this.$el.html(renderedContent);
    return this;
  }
});