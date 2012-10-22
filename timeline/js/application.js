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
  var previousMonth = null;
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

  $('div.season').remove(); // remove all instances of .season so we don't get duplicates

  $("article.post").each(function() {
    var datetime = $(this).find("time").attr("datetime").split('-'); // split into [year, month, day]
    var currentMonth = datetime[1];
    var currentYear  = datetime[0];

    // Find current Season
    if ((currentMonth != previousMonth) && (previousMonth != null)) {
      var currentMonthSeason  = calendar[currentMonth - 1][1];
      var previousMonthSeason = calendar[previousMonth - 1][1];

      // Generate Year change for Winter Season: "2012-2013"
      if ((currentMonthSeason == "winter") && (currentMonth == 12)){
        var previousYear = currentYear;
        var upcomingYear = parseInt(currentYear) + 1;
            currentYear  = previousYear + '–' + upcomingYear;

      } else if (currentMonthSeason == "winter") {
        var previousYear = parseInt(currentYear) - 1;
        var upcomingYear = currentYear;
            currentYear  = previousYear + '–' + upcomingYear;
      };

      // Insert Season into DOM
      if (currentMonthSeason != previousMonthSeason) {
        $(this).before('<div class="season ' + currentMonthSeason + '"><h2>' + currentMonthSeason + '<span class="year">' + currentYear + '</span></h2></div>');
      };
    }

    previousMonth = currentMonth
  });

};

$(document).ready(function () {

  $.tumbox;
  insertSeasons();
  getImageColor();

  // Hijack infinite scroll & run getImageColor again
  XMLHttpRequest.prototype.originalSend=XMLHttpRequest.prototype.send;
  XMLHttpRequest.prototype.send=function(s){
    this.addEventListener('load',function(){

      $.tumbox;
      insertSeasons();
      getImageColor();

    },false);
    this.originalSend(s);
  }
});
