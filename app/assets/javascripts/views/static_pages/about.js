HackUnderflow.Views.About = Backbone.View.extend({
  render: function() {
    this.$el.html(JST["static_pages/about"]());
    return this;
  }
});