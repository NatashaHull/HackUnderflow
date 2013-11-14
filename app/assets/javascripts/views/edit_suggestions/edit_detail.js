HackUnderflow.Views.EditDetail = Backbone.View.extend({
  template: JST["edit_suggestions/detail"],

  events: {
    // "click .": "accept",
    // "click .": "reject"
  },

  render: function() {
    var html = this.template({
      suggestion: this.model,
      current_user: HackUnderflow.currentUser
    });
    this.$el.html(html);
    return this;
  },

  accept: function() {

  },

  reject: function() {

  }
});