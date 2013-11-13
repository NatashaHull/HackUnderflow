HackUnderflow.Views.UserInfo = Backbone.View.extend({
  template: JST["shared/_obj_user_info"],

  render: function() {
    renderedContent = this.template({
      obj: this.model
    });

    this.$el.html(renderedContent);
    return this;
  }
});