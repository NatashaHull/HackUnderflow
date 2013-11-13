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

  upvote: function() {
    var that = this;
    $.ajax({
      type: "POST",
      url: "/answers/" +  that.id + "/upvote",
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
      url: "/answers/" +  that.id + "/downvote",
      success: function() {
        //Change Once I handle logged in users
        console.log("You just tried to vote this up!");
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