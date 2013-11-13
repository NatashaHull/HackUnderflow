HackUnderflow.Models.Comment = Backbone.Model.extend({
  user: function() {
    return HackUnderflow.users.get(this.get("user_id"));
  }
});