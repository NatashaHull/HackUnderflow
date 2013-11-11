HackUnderflow.Models.User = Backbone.Model.extend({
  urlRoot: "/users",

  setQuestions: function(questions) {
    this.questions = new HackUnderflow.Collections.Questions(questions);
    return this.questions;
  },

  setAnswers: function(answers) {
    this.answers = new HackUnderflow.Collections.Answers(answers);
    return this.answers;
  },

  setAcceptedEditSuggestions: function(accepted_edit_suggestions) {
    this.accepted_edit_suggestions =
      new HackUnderflow.Collections.AcceptedEditSuggestions(
        accepted_edit_suggestions
      );
    return this.accepted_edit_suggestions;
  },

  setPendingEditSuggestions: function(pending_edit_suggestions) {
    this.pending_edit_suggestions =
      new HackUnderflow.Collections.PendingEditSuggestions(
        pending_edit_suggestions
      );
    return this.pending_edit_suggestions;
  },

  setSuggestedEdits: function(suggested_edits) {
    this.suggested_edits =
      new HackUnderflow.Collections.SuggestedEdits(
        suggested_edits
      );
    return this.suggested_edits;
  },

  parse: function(resp, options) {
    this.setQuestions(resp.questions);
    this.setAnswers(resp.answers);
    this.setAcceptedEditSuggestions(resp.accepted_edit_suggestions);
    this.setPendingEditSuggestions(resp.pending_edit_suggestions);
    this.setSuggestedEdits(resp.suggested_edits);
    delete resp.questions;
    delete resp.answers;
    delete resp.accepted_edit_suggestions;
    delete resp.pending_edit_suggestions;
    delete resp.suggested_edits;
    return resp;
  },

  toJSON: function(options) {
    var json = _.extend({}, this.attributes);
    delete json.gravatar_url;
    return json;
  }
});