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

$(window).load(function () {

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
