HackUnderflow.Views.QuestionIndex = Backbone.View.extend({
  template: JST["questions/index"],

  render: function() {
    var html = this.template({
      questions: this.collection
    });

    this.$el.html(html);
    return this;
  }
});