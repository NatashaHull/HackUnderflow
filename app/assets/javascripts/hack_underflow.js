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
    var that = this;
    HackUnderflow.users = new HackUnderflow.Collections.Users();
    HackUnderflow.users.fetch({
      success: function() {
        that.setupCurrentUser();
      }
    });
  },

  setupCurrentUser: function() {
    var that = this;
    var currentUserId = $(".current-user").attr("href").split('/')[1];
    if(currentUserId) {
      HackUnderflow.currentUser = new HackUnderflow.Models.User({
        "id": currentUserId
      });
      
      HackUnderflow.currentUser.fetch({
        success: function() {
          that.startApp();
        }
      });
    } else {
      HackUnderflow.currentUser = null;
      that.startApp();
    }
  },

  startApp: function() {
    new HackUnderflow.Routers.ApplicationRouter($("#content"));
    Backbone.history.start();
  }
};
