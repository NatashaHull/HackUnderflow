HackUnderflow.Models.Question = Backbone.Model.extend({
  urlRoot: "/questions",

  user: function() {
    return HackUnderflow.users.get(this.get("user_id"));
  },

  upvote: function(callback) {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/questions/" +  that.id + "/upvote",
      success: function() {
        //Change Once I handle logged in users
        callback();
      }
    });
  },

  downvote: function(callback) {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/questions/" +  that.id + "/downvote",
      success: function() {
        //Change Once I handle logged in users
        callback();
      }
    });
  },

  setAnswers: function(answers) {
    this.answers = new HackUnderflow.Collections.Answers(answers, {parse: true});
    return this.answers;
  },

  setComments: function(comments) {
    this.comments = new HackUnderflow.Collections.Comments(comments, {parse: true});
    return this.comments;
  },

  parse: function(resp, options) {
    this.setAnswers(resp.answers);
    this.setComments(resp.comments);
    delete resp.answers;
    delete resp.comments;
    return resp;
  },

  toJSON: function(options) {
    var json = _.extend({}, this.attributes);
    json.answers = this.answers.toJSON();
    json.comments = this.comments.toJSON();
    delete json.accepted_answer;
    delete json.vote_counts;
    return json;
  }
});