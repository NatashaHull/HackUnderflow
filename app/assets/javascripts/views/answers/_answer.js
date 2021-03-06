HackUnderflow.Views.QuestionDetailAnswer = Backbone.View.extend({
  initialize: function(options) {
    this.question = options.question;
    this.listenTo(this.model.comments, "add", this.render);
  },

  template: JST["answers/_answer"],

  events: {
    "click .comment-link": "renderCommentForm",
    "click .arrow-up": "upvote",
    "click .voted-up": "upvote",
    "click .arrow-down": "downvote",
    "click .voted-down": "downvote",
    "click .edit-link": "assessEditRequest",
    "click .not-accepted-answer": "accept"
  },

  render: function() {
    var renderedContent = this.template({
      question: this.question,
      answer: this.model,
      current_user: HackUnderflow.currentUser
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
    if(!HackUnderflow.currentUser ||
      HackUnderflow.currentUser.escape("points") < 50) {
      this._showError();
      return;
    }
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

  upvote: function(event) {
    var that = this;
    $target = $(event.currentTarget);
    var vote = this.model.vote();
    this.model.upvote(function() {
      if(vote.isNew() || vote.get("direction") === "down") {
        that._add_vote(vote, "up", 1);
        var user = that.model.user();
        user.set("points", user.get("points") + 10);
      } else {
        that.model.set("vote_counts", (that.model.get("vote_counts") - 1));
        HackUnderflow.currentUser.votes.remove(vote);
      }
      that.render();
    });
  },

  downvote: function(event) {
    var that = this;
    $target = $(event.currentTarget);
    var vote = this.model.vote();
    this.model.downvote(function() {
      if(vote.isNew() || vote.get("direction") === "up") {
        that._add_vote(vote, "down", -1);
      } else {
        that.model.set("vote_counts", (that.model.get("vote_counts") + 1));
        HackUnderflow.currentUser.votes.remove(vote);
      }
      that.render();
    });
  },

  assessEditRequest: function() {
    if(this._editing) {
      this._editing = false;
      this.sendUpdate();
    } else if(HackUnderflow.currentUser &&
      ((HackUnderflow.currentUser.id === this.model.escape("user_id")) ||
      (HackUnderflow.currentUser.escape("points") > 2000))) {
      this.replaceBodyWithForm();
      this._editing = true;
    } else {
      this._showError();
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
    this.$(".answer-body").html(replacementEl);
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
          HackUnderflow.flash = "<p>Your Edit has been suggested!</p>";
        } else {
          that.question.answers.add(model);
        }
      }
    });
  },

  accept: function() {
    var that = this;
    event.preventDefault();
    this.model.accept(function() {
      that.model.set("accepted", true);
      that.question.set("accepted-answer", that.model);
      Backbone.history.navigate(
        "/questions/" + that.question.id,
        { trigger: true }
      );
    });
  },

  _add_vote: function(vote, dir, vector) {
    vote.set("direction", dir);
    num = vote.isNew() ? 1 : 2;
    num *= vector;
    if(vote.isNew()) vote.set("id", this._minimumId()+1);
    this.model.set("vote_counts", (this.model.get("vote_counts")+num));
    HackUnderflow.currentUser.votes.add(vote);
  },

  _minimumId: function() {
    var lastVote = HackUnderflow.currentUser.votes.last();
    return lastVote ? lastVote.get("id") : 0;
  },

  _showError: function() {
    if(this._message) return;
    this._message = true;
    if(HackUnderflow.currentUser) {
      var message = "You don't have enough points to edit other people's answers!";
    } else {
      var message = "You must be logged in to do this!";
    }
    this.$(".answer-links").prepend("<p>" + message + "</p>");
  }
});