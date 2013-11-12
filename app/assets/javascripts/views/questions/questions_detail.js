HackUnderflow.Views.QuestionDetail = Backbone.View.extend({
  template: JST["questions/detail"],

  render: function() {
    var html = this.template({
      question: this.model
    });

    this.$el.html(html);
    return this;
  }
});