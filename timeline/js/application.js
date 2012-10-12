$(window).load(function () {
  $("article.photo").each(function() {
    var images = $(this).find("section.post-content img");
    var image_url = images.attr("src");
    var dominantColor = getDominantColor(images);
    $.getImageData({
      url: image_url,
      success: function(image){
        // Do something with the now local version of the image
        alert(image);
      },
      error: function(xhr, text_status){
        // Handle your error here
      }
    });
    $(this).find("section.post-meta h2").css('color', 'rgba('+ dominantColor +', 1)');
  });
});
