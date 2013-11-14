HackUnderflow.Views.QuestionDetailQuestion = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.model.comments, "add", this.render);
  },

  template: JST["questions/_question"],

  events: {
    "click .comment-link": "renderCommentForm",
    "click .arrow-up": "voteUp",
    "click .voted-up": "voteUp",
    "click .arrow-down": "voteDown",
    "click .voted-down": "voteDown"
  },

  render: function() {
    var renderedContent = this.template({
      question: this.model,
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
      objType: "Question"
    });
    var renderedUserInfo = infoView.render().$el;
    this.$(".arrows").html(renderedUserInfo);
  },

  renderCommentForm: function() {
    var that = this;
    var commentForm = new HackUnderflow.Views.CommentForm({
      model: new HackUnderflow.Models.Comment({
        "commentable_id": that.model.get("id"),
        "commentable_type": "Question"
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
        that._add_vote(vote, "up", 1);
      } else {
        that.model.set("vote_counts", (that.model.get("vote_counts")-1));
        HackUnderflow.currentUser.votes.remove(vote);
        console.log("removed up vote");
      }
      that.render();
    });
  },

  voteDown: function(event) {
    var that = this;
    $target = $(event.currentTarget);
    var vote = this.model.vote();
    this.model.downvote(function() {
      if(vote.isNew() || vote.get("direction") === "up") {
        that._add_vote(vote, "down", -1);
      } else {
        that.model.set("vote_counts", (that.model.get("vote_counts")+1));
        HackUnderflow.currentUser.votes.remove(vote);
        console.log("removed down vote");
      }
      that.render();
    });
  },

  _add_vote: function(vote, dir, vector) {
    vote.set("direction", dir);
    num = vote.isNew() ? 1 : 2;
    num *= vector;
    if(vote.isNew()) vote.set("id", this.minimumId()+1);
    this.model.set("vote_counts", (this.model.get("vote_counts")+num));
    HackUnderflow.currentUser.votes.add(vote);
  },

  minimumId: function() {
    var lastVote = HackUnderflow.currentUser.votes.last();
    return lastVote ? lastVote.get("id") : 0;
  }
});