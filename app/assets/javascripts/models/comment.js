HackUnderflow.Models.Comment = Backbone.Model.extend({
  urlRoot: function() {
    if(this.get("commentable_type") === "Questions") {
      return "/questions/" + this.get("commentable_id") + "/comments";
    } else {
      return '/answers/' + this.get("commentable_id") + "/comments";
    }
  },

  user: function() {
    return HackUnderflow.users.get(this.get("user_id"));
  }
});