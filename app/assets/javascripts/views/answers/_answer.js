HackUnderflow.Views.QuestionDetailAnswer = Backbone.View.extend({
  initialize: function(options) {
    this.listenTo(this.model.comments, "add", this.render);
  },

  template: JST["answers/_answer"],

  events: {
    "click .comment-link": "renderCommentForm",
    "click .arrow-up": "voteUp",
    "click .voted-up": "voteUp",
    "click .arrow-down": "voteDown",
    "click .voted-down": "voteDown"
  },

  render: function() {
    var renderedContent = this.template({
      answer: this.model,
      current_user: null
    });

    this.$el.html(renderedContent);
    this.renderUserInfo();
    this.renderVotesInfo();
    return this;
  },

  renderUserInfo: function() {
    var infoView = new HackUnderflow.Views.UserInfo({
      model: this.model
    });
    var renderedUserInfo = infoView.render().$el;
    this.$(".user-info").html(renderedUserInfo);
  },

  renderVotesInfo: function() {
    var infoView = new HackUnderflow.Views.ObjVotes({
      model: this.model,
      objType: "Answer"
    });
    var renderedUserInfo = infoView.render().$el;
    this.$(".arrows").prepend(renderedUserInfo);
  },

  renderCommentForm: function() {
    var that = this;
    var commentForm = new HackUnderflow.Views.CommentForm({
      model: new HackUnderflow.Models.Comment({
        "commentable_id": that.model.get("id"),
        "commentable_type": "Answer"
      }),
      collection: that.model.comments
    });
    var renderedCommentForm = commentForm.render().$el;
    this.$(".comments").append(renderedCommentForm);
  },

  voteUp: function(event) {
    var that = this;
    $target = $(event.currentTarget);
    var vote = this.model.vote();
    this.model.upvote(function() {
      if(vote.isNew() || vote.get("direction") === "down") {
        vote.set("direction", "up");
        if(vote.isNew()) vote.set("id", that.minimumId()+1);
        that.model.set("vote_counts", (that.model.get("vote_counts") + 1));
        HackUnderflow.currentUser.votes.add(vote);
      } else {
        that.model.set("vote_counts", (that.model.get("vote_counts") - 1));
        HackUnderflow.currentUser.votes.remove(vote);
      }
      that.render();
    });
  },

  voteDown: function() {
    var that = this;
    $target = $(event.target);
    var vote = this.model.vote();
    this.model.downvote(function() {
      if(vote.isNew() || vote.get("direction") === "up") {
        vote.set("direction", "down");
        if(vote.isNew()) vote.set("id", that.minimumId()+1);
        that.model.set("vote_counts", (that.model.get("vote_counts") - 1));
        HackUnderflow.currentUser.votes.add(vote);
      } else {
        that.model.set("vote_counts", (that.model.get("vote_counts") + 1));
        HackUnderflow.currentUser.votes.remove(vote);
      }
      that.render();
    });
  },

  minimumId: function() {
    var lastVote = HackUnderflow.currentUser.votes.last();
    return lastVote ? lastVote.get("id") : 0;
  }
});