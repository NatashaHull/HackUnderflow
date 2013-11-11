window.HackUnderflow = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    HackUnderflow.questions = new HackUnderflow.Collections.Questions();
    HackUnderflow.questions.fetch({
      success: function() {
        new HackUnderflow.Routers.ApplicationRouter($("#content"));
        Backbone.history.start();
      }
    });
  }
};
