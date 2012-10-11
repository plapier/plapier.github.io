$(document).ready(function () {
  $("article.photo").each(function() {
      var images = $(this).find("section.post-content img");
      var dominantColor = getDominantColor(images);

      $(this).find("section.post-meta h2").css('color', 'rgba('+ dominantColor +', 1)');
  });
});
