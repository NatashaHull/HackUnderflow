HackUnderflow.Views.QuestionDetailAnswer = Backbone.View.extend({
  template: JST["answers/_answer"],

  events: {
    // "click .arrow-up": "voteUp",
    // "click .voted-up": "voteUp",
    // "click .arrow-down": "voteDown",
    // "click .voted-down": "voteDown"
  },

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
  },

  // voteUp: function(event) {
  //   var that = this;
  //   $target = $(event.currentTarget);
  //   console.log(event.currentTarget);
  //   this.model.upvote(function() {
  //     if($target.attr("class") === "arrow-up") {
  //       that.model.set("vote_counts", (that.model.get("vote_counts") + 1));
  //     } else {
  //       that.model.set("vote_counts", (that.model.get("vote_counts") - 1));
  //     }
  //     that.render();
  //   });
  // },

  // voteDown: function() {
  //   var that = this;
  //   $target = $(event.target);
  //   this.model.downvote(function(model) {
  //     if($target.attr("class") === "voted-down") {
  //       that.model.set("vote_counts", (that.model.get("vote_counts") - 1));
  //       HackUnderflow.current_user.votes.add(model);
  //     } else {
  //       that.model.set("vote_counts", (that.model.get("vote_counts") + 1));
  //       HackUnderflow.current_user.votes.remove(model);
  //     }
  //     that.render();
  //   });
  // }
});