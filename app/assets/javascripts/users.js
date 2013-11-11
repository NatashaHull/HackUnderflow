$(document).ready(function() {
  $("#profile-answers-0").removeClass("hidden");
  $('.more-button').on("click", function(e) {
    var $userAttr = $(e.currentTarget).parent();
    objClass = $userAttr.attr("class");
    objNum = parseInt($userAttr.attr("data-id"));
    showNextItem(objClass, objNum);
  });

  var showNextItem = function(objClass, num) {
    currentItemId = objClass + "-" + num;
    nextItemId = objClass + "-" + (num+1);
    $("#" + currentItemId).addClass("hidden");
    $("#" + nextItemId).removeClass("hidden");
  }
});