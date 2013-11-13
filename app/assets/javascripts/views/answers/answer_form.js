HackUnderflow.Views.AnswersForm = Backbone.View.extend({
  template: JST["answers/_form"],

  render: function() {
    renderedContent = this.template({
      answer: this.model,
      current_user: null
    });

    this.$el.html(renderedContent);
    return this;
  }
});