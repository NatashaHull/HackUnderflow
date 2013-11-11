HackUnderflow.Collections.Questions = Backbone.Collection.extend({
  url: "/questions",

  model: HackUnderflow.Models.Question,

  parse: function(response) {
    this.page = response.page;
    this.total_pages = response.total_pages;
    return response.models;
  }
});