HackUnderflow.Views.UserIndex = Backbone.View.extend({
  template: JST["users/index"],

  render: function() {
    var html = this.template({
      users: this.collection
    });

    this.$el.html(html);
    return this;
  }
});