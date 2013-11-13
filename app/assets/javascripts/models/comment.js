HackUnderflow.Models.Comment = Backbone.Model.extend({
  user: function() {
    HackUnderflow.users.get(this.user_id);
  }
});