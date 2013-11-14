HackUnderflow.Views.QuestionNew = Backbone.View.extend({
  template: JST["questions/new"],

  events: {
    "submit form": "submit"
  },

  render: function() {
    var html = this.template({
      question: this.model
    });

    this.$el.html(html);
    return this;
  },

  submit: function(event) {
    var that = this;
    event.preventDefault();
    var form = $(event.currentTarget);
    var questionData = form.serializeJSON();
    that.model.set(questionData);
    that.model.save(null, {
      success: function() {
        that.collection.add(that.model);
        HackUnderflow.currentUser.questions.add(that.model);
        console.log("Success!!!!!");
        Backbone.history.navigate("/questions/"+that.model.get("id"));
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