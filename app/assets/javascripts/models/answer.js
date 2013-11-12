HackUnderflow.Models.Answer = Backbone.Model.extend({
  urlRoot: function() {
    if(this.isNew()) {
      return "/questions/" + this.question_id + "/answers";
    } else {
      return "/answers";
    }
  },

  user: function() {
    HackUnderflow.users.get(this.user_id);
  },

  setComments: function(comments) {
    this.comments = new HackUnderflow.Collections.Comments(comments);
    return this.comments;
  },

  parse: function(resp, options) {
    this.setComments(resp.comments);
    delete resp.comments;
    return resp;
  },

  toJSON: function(options) {
    var json = _.extend({}, this.attributes);
    json.comments = this.comments.toJSON();
    delete json.vote_counts;
    delete json.question_title;
    return json;
  }
});