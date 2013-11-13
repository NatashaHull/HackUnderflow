HackUnderflow.Models.Answer = Backbone.Model.extend({
  urlRoot: function() {
    if(this.isNew()) {
      return "/questions/" + this.get("question_id") + "/answers";
    } else {
      return "/answers";
    }
  },

  user: function() {
    return HackUnderflow.users.get(this.get("user_id"));
  },

  upvote: function(callback) {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/answers/" +  that.get("id") + "/upvote",
      success: function() {
        callback();
      }
    });
  },

  downvote: function(callback) {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/answers/" +  that.get("id") + "/downvote",
      success: function() {
        callback();
      }
    });
  },

  setComments: function(comments) {
    this.comments = new HackUnderflow.Collections.Comments(comments, {parse: true});
    return this.comments;
  },

  parse: function(resp, options) {
    this.setComments(resp.comments);
    delete resp.comments;
    return resp;
  },

  toJSON: function(options) {
    var json = _.extend({}, this.attributes);
    if(this.comments) {
      json.comments = this.comments.toJSON();
    }
    delete json.vote_counts;
    delete json.question_title;
    return json;
  }
});