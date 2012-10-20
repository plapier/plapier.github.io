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

$(document).ready(function () {

var calendar =[
  [01, "Winter"],
  [02, "Winter"],
  [03, "Spring"],
  [04, "Spring"],
  [05, "Spring"],
  [06, "Summer"],
  [07, "Summer"],
  [08, "Summer"],
  [09, "Fall"],
  [10, "Fall"],
  [11, "Fall"],
  [12, "Winter"]];

  console.log(calendar);

  var postMonth = [];

  var winter = [12, 01, 02];
  var spring = [03, 04, 05];
  var summer = [06, 07, 08];
  var fall   = [09, 10, 11];
  var seasons = [winter, spring, summer, fall];
  // console.log(seasons);

  var previousMonth = null;

  $("article.post").each(function() {
    var currentId = $(this).attr("id");
    var datetime = $(this).find("time").attr("datetime").split('-');
    var currentMonth = datetime[1];
    if (currentMonth < previousMonth) {
      console.log("True! " + currentMonth + " < " + previousMonth );
      var currentMonthSeason = calendar[currentMonth - 1][1];
      var previousMonthSeason = calendar[previousMonth - 1][1];
      if (currentMonthSeason != previousMonthSeason) {
        console.log(this);
        // $(this).before('<section class="season">' + currentMonthSeason + '</section>');
      };

      console.log(previousMonthSeason + " " + currentMonthSeason);
      // console.log(calendar[0][0]);
    }

    else {
      console.log("False " + currentMonth + " = " + previousMonth );
    }
    previousMonth = currentMonth

    // for (var i = 0; i < items.length; i++) {
      // postMonth[1].push(currentId, datetime[1]);
    // }


    // console.log($.inArray(10, seasons[3]));

    // for (var i = 0; i < fall.length; i++) {
      // if (datetime[1] == fall[i]) {
        // console.log('Fall!');
      // }
    // }
  });




  // Run getImageColor function on load
  getImageColor();

  // Hijack infinite scroll & run getImageColor again
  XMLHttpRequest.prototype.originalSend=XMLHttpRequest.prototype.send;
  XMLHttpRequest.prototype.send=function(s){
    this.addEventListener('load',function(){

      getImageColor();

    },false);
    this.originalSend(s);
  }
});
