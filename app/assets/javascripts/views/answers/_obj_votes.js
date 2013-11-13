HackUnderflow.Views.ObjVotes = Backbone.View.extend({
  template: JST["shared/_object_votes"],

  render: function() {
    renderedContent = this.template({
      object: this.model
    });

    this.$el.html(renderedContent);
    return this;
  }
});