$(window).load(function () {
      $.getJSON('http://anyorigin.com/get?url=http%3A//zesty-life.tumblr.com/&callback=?', function(data){
  $("article.photo").each(function() {
      var images = $(this).find("section.post-content img");
      var dominantColor = getDominantColor(images);
      $(this).find("section.post-meta h2").css('color', 'rgba('+ dominantColor +', 1)');
  });
      
      });
});
