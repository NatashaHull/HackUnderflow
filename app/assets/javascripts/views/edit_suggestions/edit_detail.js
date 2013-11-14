HackUnderflow.Views.EditDetail = Backbone.View.extend({
  template: JST["edit_suggestions/detail"],

  events: {
    // "click .": "accept",
    // "click .": "reject"
  },

  render: function() {
    var html = this.template({
      question: this.model,
    });
    this.$el.html(html);
    return this;
  },

  accept: function() {

  },

  reject: function() {

  }
});