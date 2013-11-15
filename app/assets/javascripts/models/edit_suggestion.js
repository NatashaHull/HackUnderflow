HackUnderflow.Models.EditSuggestion = Backbone.Model.extend({
  urlRoot: "/edit_suggestions",

  user: function() {
    return HackUnderflow.users.get(this.get("user_id"));
  },

  acceptEdit: function(callback) {
    var that = this;
    var url = "/edit_suggestions/" + that.id + "/accept.json";
    $.ajax({
      type: "PUT",
      url: url,
      success: function() {
        var user = that.user();
        user.set("points", user.get("points") + 2);
        callback();
      }
    });
  },

  rejectEdit: function(callback) {
    var that = this;
    $.ajax({
      type: "DELETE",
      url: "/edit_suggestions/" + that.id + "/reject.json",
      success: callback
    });
  },

  setEditable: function(resp) {
    if(resp.editable_type === "Question") {
      this.editable = new HackUnderflow.Models.Question(resp.editable);
    } else {
      this.editable = new HackUnderflow.Models.Answer(resp.editable);
    }
  },

  parse: function(resp, options) {
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