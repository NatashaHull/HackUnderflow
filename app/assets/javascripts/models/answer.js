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

  accept: function(callback) {
    var that = this;
    var url = "/answers/" + that.id + "/accept.json";
    $.ajax({
      type: "PUT",
      url: url,
      success: function() {
        var user = that.user();
        user.set("points", user.get("points") + 2);
        callback();
      }
    });
  },

  vote: function() {
    var vote = HackUnderflow.currentUser.votes.findWhere({
      "voteable_id": this.get("id"),
      "voteable_type": "Answer"
    });
    if(vote) {
      return vote;
    } else {
      return new HackUnderflow.Models.Vote({
        "voteable_id": this.get("id"),
        "voteable_type": "Answer"
      });
    }
  },

  upvote: function(callback) {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/answers/" +  that.get("id") + "/upvote.json",
      success: callback
    });
  },

  downvote: function(callback) {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/answers/" +  that.get("id") + "/downvote.json",
      success: callback
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