HackUnderflow.Views.UserDetail = Backbone.View.extend({
  template: JST["users/detail"],

  events: {
    "click .more-button": "getNextInfo"
  },

  render: function() {
    var html = this.template({
      user: this.model
    });

    this.$el.html(html);
    return this;
  },

  showFirstItems: function() {
    $("#profile-questions-0").removeClass("hidden");
    $("#profile-answers-0").removeClass("hidden");
    $("#profile-suggested-edits-0").removeClass("hidden");
    $("#profile-pending-edits-0").removeClass("hidden");
    $("#profile-accepted-edits-0").removeClass("hidden");
  },

  getNextInfo: function(e) {
    var $userAttr = $(e.currentTarget).parent();
    var objClass = $userAttr.attr("class");
    var objNum = parseInt($userAttr.attr("data-id"));
    var last = parseInt($userAttr.attr("data-last"));
    this.showNextItem(objClass, objNum, last);
  },

  showNextItem: function(objClass, num, last) {
    var nextItemId;
    if(num === last) {
      nextItemId = objClass + "-" + 0;
    } else {
      nextItemId = objClass + "-" + (num+1);
    }

    var currentItemId = objClass + "-" + num;
    $("#" + currentItemId).addClass("hidden");
    $("#" + nextItemId).removeClass("hidden");
  }
});