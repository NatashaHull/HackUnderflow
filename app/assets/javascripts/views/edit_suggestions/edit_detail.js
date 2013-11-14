HackUnderflow.Views.EditDetail = Backbone.View.extend({
  template: JST["edit_suggestions/detail"],

  events: {
    "submit .accept-form": "accept",
    "submit .reject-form": "reject"
  },

  render: function() {
    var html = this.template({
      suggestion: this.model,
      current_user: HackUnderflow.currentUser
    });
    this.$el.html(html);
    return this;
  },

  accept: function(event) {
    var that = this;
    event.preventDefault();
    console.log(that.model.acceptEdit);
    this.model.acceptEdit(function() {
      that.model.set("accepted", true);
      var user = HackUnderflow.users.get(that.model.get("user_id"));
      user.accepted_edit_suggestions.add(that.model);
      var $success = $("<ul>");
      $success.prepend("<li>This edit has been accepted!</li>");
      that.$el.prepend($success);
    });
  },

  reject: function() {
    var that = this;
    event.preventDefault();
    console.log(that.model.rejectEdit);
    this.model.rejectEdit(function() {
      var $success = $("<ul>");
      $success.prepend("<li>This edit has been rejected! (and no longer exists)</li>");
      that.$el.prepend($success);
    });
  },
});