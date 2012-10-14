$(window).load(function () {
  $("article.photo").each(function() {
    var image_url = $(this).find("section.post-content img").attr("src");
    var small_image_url= image_url.replace('500.jpg','100.jpg');
    var currentId = $(this).attr("id");

    $.getImageData({
      url: small_image_url,
      success: function(image){
        // Do something with new local version of the image
        var dominantColor = getDominantColor(image);
        $('#' + currentId + " section.post-meta h2").css('color', 'rgba('+ dominantColor +', 1)');
      },
      error: function(xhr, text_status){
        console.log("Failed on " + small_image_url);
      }
    });
  });
});
