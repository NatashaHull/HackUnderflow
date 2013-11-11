HackUnderflow.Collections.Questions = Backbone.Collection.extend({
  url: "/questions",

  model: HackUnderflow.Models.Question,

  parse: function(response) {
    this.page_number = (parseInt(response.page) || 1);
    this.total_pages = response.total_pages;
    return response.models;
  }
});