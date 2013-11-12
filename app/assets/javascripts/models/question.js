HackUnderflow.Models.Question = Backbone.Model.extend({
  urlRoot: "/questions",

  user: function() {
    HackUnderflow.users.get(this.user_id);
  },

  upvote: function() {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/questions/" +  that.id + "/upvote",
      success: function() {
        //Change Once I handle logged in users
        console.log("You just tried to vote this up!");
      }
    });
  },

  downvote: function() {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/questions/" +  that.id + "/downvote",
      success: function() {
        //Change Once I handle logged in users
        console.log("You just tried to vote this up!");
      }
    });
  },

  setAnswers: function(answers) {
    this.answers = new HackUnderflow.Collections.Answers(answers);
    return this.answers;
  },

  setComments: function(comments) {
    this.comments = new HackUnderflow.Collections.Comments(comments);
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