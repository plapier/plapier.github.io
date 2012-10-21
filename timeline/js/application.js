getImageColor = function () {
  $("article.photo").each(function() {
    var currentId = $(this).attr("id");

    if ( $(this).find("h2").attr("style")) {
    }
    else {
      var image_url = $(this).find("section.post-content img").attr("src");
      var small_image_url = image_url.replace('500.jpg','100.jpg');

      $.getImageData({
        url: small_image_url,
        success: function(image){
          // Do something with new local version of the image
          // var dominantColor = getDominantColor(image);
          // $('#' + currentId + " section.post-meta h2").css('color', 'rgba('+ dominantColor +', 1)');
          var paletteArray = createPalette(image, 2);
          paletteArray.sort(function() { return 0.5 - Math.random() });
          $('#' + currentId + " section.post-meta h2").css('color', 'rgba('+ paletteArray[0] +', 1)');
        },
        error: function(xhr, text_status){
          console.log("Failed on " + small_image_url);
        }
      });
    }
  });
};

insertSeasons = function () {
  var calendar =[
    [01, "winter"],
    [02, "winter"],
    [03, "spring"],
    [04, "spring"],
    [05, "spring"],
    [06, "summer"],
    [07, "summer"],
    [08, "summer"],
    [09, "fall"],
    [10, "fall"],
    [11, "fall"],
    [12, "winter"]];

  var previousMonth = null;
  $('div.season').remove();

  $("article.post").each(function() {
    var datetime = $(this).find("time").attr("datetime").split('-');
    var currentMonth = datetime[1];
    // currentId = $(this).attr("id");
    // console.log(currentId);

    if ((currentMonth != previousMonth) && (previousMonth != null)) {
      // console.log("True! " + currentMonth + " < " + previousMonth );
      var currentMonthSeason = calendar[currentMonth - 1][1];
      var previousMonthSeason = calendar[previousMonth - 1][1];

      if (currentMonthSeason != previousMonthSeason) {
        // console.log(this);
        $(this).before('<div class="season ' + currentMonthSeason + '"><h2>' + currentMonthSeason + '</h2></div>');
      };
      // console.log(previousMonthSeason + " " + currentMonthSeason);
    }

    else {
      // console.log("False " + currentMonth + " = " + previousMonth );
    }
    previousMonth = currentMonth
  });

};

$(document).ready(function () {

  // Run getImageColor function on load
  // var currentId = null;
  insertSeasons();
  getImageColor();

  // Hijack infinite scroll & run getImageColor again
  XMLHttpRequest.prototype.originalSend=XMLHttpRequest.prototype.send;
  XMLHttpRequest.prototype.send=function(s){
    this.addEventListener('load',function(){

      insertSeasons();
      getImageColor();

    },false);
    this.originalSend(s);
  }
});
