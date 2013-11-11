HackUnderflow.Models.EditSuggestions = Backbone.Model.extend({
  toJSON: function(options) {
    var json = _.extend({}, this.attributes);
    delete json.question_title;
    return json;
  }
});