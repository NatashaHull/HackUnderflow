HackUnderflow.Views.QuestionDetail = Backbone.View.extend({
  template: JST["questions/detail"],

  render: function() {
    var html = this.template({
      question: this.model,
      current_user: null
    });
    this.$el.html(html);

    this.renderQuestion();
    this.renderAnswers();
    this.renderAnswersForm();
    return this;
  },

  sortAnswers: function() {
    var that = this;
    return that.model.answers.sortBy(function(answer) {
      if(answer.get("accepted")) {
        return -1000000000;
      } else {
        time = Date.now() - new Date(answer.get("updated_at"));
        time /= (1000 * 3600);
        return -1 * (answer.get("vote_counts") / (time+2));
      }
    });
  },

  renderQuestion: function() {
    var questionView = new HackUnderflow.Views.QuestionDetailQuestion({
      model: this.model
    });
    renderedQuestion = questionView.render().$el;
    this.$el.children(".question").append(renderedQuestion);
  },

  renderAnswers: function() {
    var that = this;
    answers = that.sortAnswers();
    answers.forEach(function(answer) {
      answerView = new HackUnderflow.Views.QuestionDetailAnswer({
        model: answer
      });

      renderedAnswer = answerView.render().$el;
      that.$el.children(".answers").append(renderedAnswer);
    });
  },

  renderAnswersForm: function() {
    var answerFormView = new HackUnderflow.Views.AnswersForm({
      model: new HackUnderflow.Models.Answer()
    });

    renderedAnswerForm = answerFormView.render().$el;
    this.$el.children(".new-answers-form").append(renderedAnswerForm);
  }
});