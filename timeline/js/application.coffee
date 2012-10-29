getImageColor = ->
  $("article.photo").each ->
    currentId = $(this).attr("id");

    unless $(this).find("h2").attr("style")
      image_url = $(this).find("section.post-content img").attr("src")
      small_image_url = image_url.replace('500.jpg','100.jpg')

      $.getImageData
        url: small_image_url
        success: (image) ->
          # Do something with new local version of the image
          # var dominantColor = getDominantColor(image);
          # $('#' + currentId + " section.post-meta h2").css('color', 'rgba('+ dominantColor +', 1)');
          paletteArray = createPalette(image, 2)
          paletteArray.sort ->
            0.5 - Math.random()

          $("##{currentId} section.post-meta h2").css 'color', "rgba(#{paletteArray[0]}, 1)"

        error: (xhr, text_status) ->
          console.log("Failed on " + small_image_url);

insertSeasons = ->
  previousMonth = null
  calendar = [
    [1, "winter"],
    [2, "winter"],
    [3, "spring"],
    [4, "spring"],
    [5, "spring"],
    [6, "summer"],
    [7, "summer"],
    [8, "summer"],
    [9, "autumn"],
    [10, "autumn"],
    [11, "autumn"],
    [12, "winter"]]

  $('div.season').remove() # remove all instances of .season so we don't get duplicates

  $("article.post").each ->
    datetime = $(this).find("time").attr("datetime").split('-') # split into [year, month, day]
    currentMonth = datetime[1]
    currentYear  = datetime[0]

    # Find current Season
    if (currentMonth isnt previousMonth) and (previousMonth isnt null)
      currentMonthSeason  = calendar[currentMonth - 1][1]
      previousMonthSeason = calendar[previousMonth - 1][1]


      # Generate Year change for Winter Season: "2012-2013"
      if (currentMonthSeason is "winter") and (currentMonth is 12)
        previousYear = currentYear
        upcomingYear = parseInt(currentYear) + 1
        currentYear  = previousYear + '–' + upcomingYear

      else if currentMonthSeason is "winter"
        previousYear = parseInt(currentYear) - 1
        upcomingYear = currentYear
        currentYear  = previousYear + '–' + upcomingYear


      # Insert Season into DOM
      $(this).before """
      <div class="season #{currentMonthSeason}">
        <h2>#{currentMonthSeason} <span class="year">#{currentYear}</span></h2>
      </div>
      """ unless currentMonthSeason is previousMonthSeason

    previousMonth = currentMonth


$(document).ready ->
  insertSeasons()
  getImageColor()

  $(".fancybox").fancybox
    padding: 0
    openEffect: 'elastic'
    openSpeed : 150
    closeEffect: 'elastic'
    closeSpeed: 150
    closeClick: true

    helpers:
      title:
        type: 'outside'

  #Hijack infinite scroll & run getImageColor again
  XMLHttpRequest.prototype.originalSend=XMLHttpRequest.prototype.send
  XMLHttpRequest.prototype.send = (s) ->
    @addEventListener 'load', ( ->
      insertSeasons()
      getImageColor()
    ), false
    @originalSend(s)
