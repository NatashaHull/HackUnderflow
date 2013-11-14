HackUnderflow.Models.EditSuggestion = Backbone.Model.extend({
  urlRoot: "/edit_suggestions",

  setEditable: function(resp) {
    if(resp.editable_type === "Question") {
      this.editable = HackUnderflow.questions.get(resp.editable_id);
    } else {
      this.editable = new HackUnderflow.Models.Answer(resp.editable);
    }
  },

  parse: function(resp, options) {
    console.log(resp);
    this.setEditable(resp);
    delete resp.editable;
    return resp;
  },

  toJSON: function(options) {
    var json = _.extend({}, this.attributes);
    delete json.question_title;
    return json;
  }
});