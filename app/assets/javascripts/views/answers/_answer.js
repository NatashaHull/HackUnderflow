HackUnderflow.Views.QuestionDetailAnswer = Backbone.View.extend({
  template: JST["answers/_answer"],

  render: function() {
    renderedContent = this.template({
      answer: this.model,
      current_user: null
    });

    this.$el.html(renderedContent);
    this.renderUserInfo();
    this.renderVotesInfo();
    return this;
  },

  renderUserInfo: function() {
    infoView = new HackUnderflow.Views.UserInfo({
      model: this.model
    });
    var renderedUserInfo = infoView.render().$el;
    this.$(".user-info").html(renderedUserInfo);
  },

  renderVotesInfo: function() {
    infoView = new HackUnderflow.Views.ObjVotes({
      model: this.model
    });
    var renderedUserInfo = infoView.render().$el;
    this.$(".arrows").prepend(renderedUserInfo);
  }
});