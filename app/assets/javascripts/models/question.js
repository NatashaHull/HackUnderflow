HackUnderflow.Models.Question = Backbone.Model.extend({
  urlRoot: "/questions",

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