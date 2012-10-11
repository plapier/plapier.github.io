$(document).ready(function () {
  setTimeout(function() {
    $("article.photo").each(function() {
        var images = $(this).find("section.post-content img");
        var dominantColor = getDominantColor(images);
        $(this).find("section.post-meta h2").css('color', 'rgba('+ dominantColor +', 1)');
    });
  }, 1000);
});
