HackUnderflow.Views.ObjVotes = Backbone.View.extend({
  initialize: function(options) {
    this.objType = options.objType;
  },

  template: JST["shared/_object_votes"],

  render: function() {
    renderedContent = this.template({
      object: this.model,
      voted: this.voted()
    });

    this.$el.html(renderedContent);
    return this;
  },

  voted: function() {
    if(HackUnderflow.currentUser) {
      var votes = HackUnderflow.currentUser.votes;
      if(HackUnderflow.currentUser) {
        for(var i = 0; i < votes.length; i++) {
          var vote = votes.at(i);
          if(vote.get("voteable_id") == this.model.get("id") &&
            vote.get("voteable_type") === this.objType) {
            return vote.get("direction");
          }
        }
      }
    }
  }
});