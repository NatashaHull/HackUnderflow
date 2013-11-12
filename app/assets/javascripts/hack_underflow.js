window.HackUnderflow = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    var that = this;
    HackUnderflow.questions = new HackUnderflow.Collections.Questions();
    HackUnderflow.questions.fetch({
      success: function() {
        that.setupUsers();
      }
    });
  },

  setupUsers: function() {
    HackUnderflow.users = new HackUnderflow.Collections.Users();
    HackUnderflow.users.fetch({
      success: function() {
        new HackUnderflow.Routers.ApplicationRouter($("#content"));
        Backbone.history.start();
      }
    });
  }
};
