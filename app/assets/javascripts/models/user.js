HackUnderflow.Models.User = Backbone.Model.extend({
  urlRoot: "/users",

  setQuestions: function(questions) {
    this.questions = new HackUnderflow.Collections.Questions(questions);
    return this.questions;
  },

  setAnswers: function(answers) {
    this.answers = new HackUnderflow.Collections.Answers(
      answers,
      { parse:true }
    );
    return this.answers;
  },

  setAcceptedEditSuggestions: function(accepted_edit_suggestions) {
    this.accepted_edit_suggestions =
      new HackUnderflow.Collections.AcceptedEditSuggestions(
        accepted_edit_suggestions,
        { parse:true }
      );
    return this.accepted_edit_suggestions;
  },

  setPendingEditSuggestions: function(pending_edit_suggestions) {
    this.pending_edit_suggestions =
      new HackUnderflow.Collections.PendingEditSuggestions(
        pending_edit_suggestions,
        { parse:true }
      );
    return this.pending_edit_suggestions;
  },

  setSuggestedEdits: function(suggested_edits) {
    this.suggested_edits =
      new HackUnderflow.Collections.SuggestedEdits(
        suggested_edits,
        { parse:true }
      );
    return this.suggested_edits;
  },

  setVotes: function(votes) {
    this.votes = new HackUnderflow.Collections.Votes(
      votes,
      { parse:true }
    );
  },

  parse: function(resp, options) {
    this.setQuestions(resp.questions);
    this.setAnswers(resp.answers);
    this.setAcceptedEditSuggestions(resp.accepted_edit_suggestions);
    this.setPendingEditSuggestions(resp.pending_edit_suggestions);
    this.setSuggestedEdits(resp.suggested_edits);
    this.setVotes(resp.votes);
    delete resp.questions;
    delete resp.answers;
    delete resp.accepted_edit_suggestions;
    delete resp.pending_edit_suggestions;
    delete resp.suggested_edits;
    delete resp.votes;
    return resp;
  },

  toJSON: function(options) {
    var json = _.extend({}, this.attributes);
    delete json.gravatar_url;
    return json;
  }
});