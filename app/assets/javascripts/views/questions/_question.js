HackUnderflow.Views.QuestionDetailQuestion = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.model.comments, "add", this.render);
  },

  template: JST["questions/_question"],

  events: {
    "click .comment-link": "renderCommentForm"
  },

  render: function() {
    renderedContent = this.template({
      question: this.model,
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
  }
});