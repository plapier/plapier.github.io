$(window).load(function () {
  $("article.photo").each(function() {
    var image_url = $(this).find("section.post-content img").attr("src");
    var currentId = $(this).attr("id");

    $.getImageData({
      // url: "http://24.media.tumblr.com/tumblr_mbk0mtvzOM1riznzbo1_500.jpg",
      url: image_url,
      success: function(image){
        // Do something with the now local version of the image
        var dominantColor = getDominantColor(image);
        $('#' + currentId + " section.post-meta h2").css('color', 'rgba('+ dominantColor +', 1)');
      },
      error: function(xhr, text_status){
        // Handle your error here
      }
    });
  });
});
