$(document).ready(function() {
  $("#profile-answers-0").removeClass("hidden");
  $('.more-button').on("click", function(e) {
    var $userAttr = $(e.currentTarget).parent();
    var objClass = $userAttr.attr("class");
    var objNum = parseInt($userAttr.attr("data-id"));
    var last = parseInt($userAttr.attr("data-last"));
    showNextItem(objClass, objNum, last);
  });

  var showNextItem = function(objClass, num, last) {
    if(num === last) {
      var nextItemId = objClass + "-" + 0;
    } else {
      var nextItemId = objClass + "-" + (num+1);
    }

    var currentItemId = objClass + "-" + num;
    $("#" + currentItemId).addClass("hidden");
    $("#" + nextItemId).removeClass("hidden");
  }
});