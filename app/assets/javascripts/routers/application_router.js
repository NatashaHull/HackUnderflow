HackUnderflow.Routers.ApplicationRouter = Backbone.Router.extend({
  initialize: function($rootEl) {
    this.$rootEl = $rootEl;
  },

  routes: {
    "": "questionsIndex",
    "questions": "questionsIndex",
    "users": "usersIndex",
    "about": "about"
  },

  questionsIndex: function() {
    var indexView = new HackUnderflow.Views.QuestionIndex({
      collection: HackUnderflow.questions
    });
    this._swapView(indexView);
  },

  usersIndex: function() {
    var that = this;
    if(HackUnderflow.users) {
      that._renderUsersIndex();
    } else {
      HackUnderflow.users = new HackUnderflow.Collections.Users();
      HackUnderflow.users.fetch({
        success: function() {
          that._renderUsersIndex();
        }
      });
    }
  },

  about: function() {
    this._swapView(new HackUnderflow.Views.About());
  },

  _swapView: function(view) {
    if(this._prevView) {
      this._prevView.remove();
    }

    this._prevView = view;
    this.$rootEl.html(view.render().$el);
  },

  _renderUsersIndex: function() {
    var indexView = new HackUnderflow.Views.UserIndex({
      collection: HackUnderflow.users
    });

    this._swapView(indexView);
  }
});