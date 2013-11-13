HackUnderflow.Views.QuestionDetailAnswer = Backbone.View.extend({
  template: JST["answers/_answer"],

  render: function() {
    renderedContent = this.template({
      answer: this.model,
      current_user: null
    });

    this.$el.html(renderedContent);
    this.renderUserInfo();
    return this;
  },

  renderUserInfo: function() {
    infoView = new HackUnderflow.Views.UserInfo({
      model: this.model
    });
    var renderedUserInfo = infoView.render().$el;
    this.$(".user-info").html(renderedUserInfo);
  }
});