HackUnderflow.Views.QuestionDetailQuestion = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.model.comments, "add", this.render);
  },

  template: JST["questions/_question"],

  events: {
    "click .comment-link": "renderCommentForm",
    "click .arrow-up": "upvote",
    "click .voted-up": "upvote",
    "click .arrow-down": "downvote",
    "click .voted-down": "downvote",
    "click .edit-link": "assessEditRequest"
  },

  render: function() {
    var renderedContent = this.template({
      question: this.model
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

  upvote: function(event) {
    var that = this;
    $target = $(event.currentTarget);
    var vote = this.model.vote();
    this.model.upvote(function() {
      if(vote.isNew() || vote.get("direction") === "down") {
        that._add_vote(vote, "up", 1);
      } else {
        that.model.set("vote_counts", (that.model.get("vote_counts")-1));
        HackUnderflow.currentUser.votes.remove(vote);
      }
      that.render();
    });
  },

  downvote: function(event) {
    var that = this;
    var $target = $(event.currentTarget);
    var vote = this.model.vote();
    this.model.downvote(function() {
      if(vote.isNew() || vote.get("direction") === "up") {
        that._add_vote(vote, "down", -1);
      } else {
        that.model.set("vote_counts", (that.model.get("vote_counts")+1));
        HackUnderflow.currentUser.votes.remove(vote);
      }
      that.render();
    });
  },

  assessEditRequest: function() {
    if(this._editing) {
      this.sendUpdate();
    }

    if(HackUnderflow.currentUser &&
      (HackUnderflow.currentUser.id === this.model.escape("user_id")) ||
      (HackUnderflow.currentUser.escape("points") > 2000)) {
      this.replaceBodyWithForm();
      this._editing = true;
    }
  },

  replaceBodyWithForm: function() {
    var replacementView = new HackUnderflow.Views.QuestionNew({
      collection: HackUnderflow.questions,
      model: this.model
    });
    var replacementEl = replacementView.render().$("#body");
    replacementEl.removeAttr('id');
    replacementEl.addClass("inline");
    this.$(".question-body").html(replacementEl);
  },

  sendUpdate: function() {
    var that = this;
    var newBody = this.$(".inline").val();
    var currentModel = _.extend({}, that.model.attributes);
    that.model.set("body", newBody);
    that.model.save(null, {
      success: function(model) {
        if(model.get("editable_id")) {
          HackUnderflow.currentUser.pending_edit_suggestions.add(model);
          that.model.attributes = currentModel;
        }
        that._editing = false;
        that.render();
      }
    });
  },

  _add_vote: function(vote, dir, vector) {
    vote.set("direction", dir);
    var num = vote.isNew() ? 1 : 2;
    num *= vector;
    if(vote.isNew()) vote.set("id", this._minimumId()+1);
    this.model.set("vote_counts", (this.model.get("vote_counts")+num));
    HackUnderflow.currentUser.votes.add(vote);
  },

  _minimumId: function() {
    var lastVote = HackUnderflow.currentUser.votes.last();
    return lastVote ? lastVote.get("id") : 0;
  }
});