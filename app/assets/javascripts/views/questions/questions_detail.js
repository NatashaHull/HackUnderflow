HackUnderflow.Views.QuestionDetail = Backbone.View.extend({
  initialize: function(options) {
    this.listenTo(this.model.answers, "add remove sync", this.render);
    this.views = [];
  },

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
    this.$(".question").append(renderedQuestion);
    this.views.push(questionView);
  },

  renderAnswers: function() {
    var that = this;
    answers = that.sortAnswers();
    answers.forEach(function(answer) {
      answerView = new HackUnderflow.Views.QuestionDetailAnswer({
        model: answer
      });

      renderedAnswer = answerView.render().$el;
      that.$(".answers").append(renderedAnswer);
      that.views.push(answerView);
    });
  },

  renderAnswersForm: function() {
    answerFormView = new HackUnderflow.Views.AnswersForm({
      model: new HackUnderflow.Models.Answer({
        "question_id": this.model.get("id")
      }),
      collection: this.model.answers
    });

    renderedAnswerForm = answerFormView.render().$el;
    this.$(".new-answers-form").append(renderedAnswerForm);
    this.views.push(answerFormView);
  },

  remove: function() {
    this.$el.html("");
    this.stopListening();
    this.views.forEach(function(view) {
      view.remove();
    });
  }
});