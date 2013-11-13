HackUnderflow.Views.AnswersForm = Backbone.View.extend({
  template: JST["answers/_form"],

  events:{
    "submit form": "addAnswer"
  },

  render: function() {
    renderedContent = this.template({
      answer: this.model,
      current_user: null
    });

    this.$el.html(renderedContent);
    return this;
  },

  addAnswer: function(event) {
    var that = this;
    event.preventDefault();
    var form = $(event.currentTarget);
    console.log("Add event triggered!");
    that.model.set("body", form.children("textarea").val());
    console.log(this.model);
    that.model.save(null, {
      success: function() {
        that.collection.add(that.model);
      },
      error: function() {
        alert("Something went wrong");
      }
    });
  }
});