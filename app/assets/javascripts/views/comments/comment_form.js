HackUnderflow.Views.CommentForm = Backbone.View.extend({
  template: JST["comments/form"],

  events:{
    "submit form": "addComment"
  },

  render: function() {
    renderedContent = this.template({
      comment: this.model
    });

    this.$el.html(renderedContent);
    return this;
  },

  addComment: function(event) {
    var that = this;
    event.preventDefault();
    var form = $(event.currentTarget);
    that.model.set("body", form.children("textarea").val());
    that.model.save(null, {
      success: function() {
        that.$el.html("");
        that.collection.add(that.model);
      },
      error: function(model, errors) {
        var valErrors = errors.responseJSON;
        var $errors = $("<ul>");
        valErrors.forEach(function(error) {
          $errors.prepend("<li>" + error + "</li>");
        });
        that.$el.prepend($errors);
      }
    });
  }
});