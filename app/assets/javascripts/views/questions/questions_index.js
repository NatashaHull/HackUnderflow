HackUnderflow.Views.QuestionIndex = Backbone.View.extend({
  template: JST["questions/index"],

  render: function() {
    var html = this.template({
      questions: this.collection
    });

    this.listenForScroll();
    this.$el.html(html);
    return this;
  },

  listenForScroll: function () {
    $(window).off("scroll"); // remove past view's listeners
    var throttledCallback = _.throttle(this.nextPage.bind(this), 200);
    $(window).on("scroll", throttledCallback);
  },

  nextPage: function () {
    var self = this;
    if ($(window).scrollTop() > $(document).height() - $(window).height() - 100) {
      if (self.collection.page_number < self.collection.total_pages) {
        self.collection.fetch({
          data: { page: self.collection.page_number + 1 },
          remove: false,
          wait: true,
          success: function () {
            self.render();
          }
        });
      }
    }
  }
});