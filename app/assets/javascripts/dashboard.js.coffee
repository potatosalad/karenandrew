$(document).ready ->

  if $('body.dashboard').length

    xhr = $.get('/images.json')
    xhr.done (data) ->
      images = data.images.sort ->
        return 0.5 - Math.random()
      if Modernizr.canvas
        $('#kenburns').kenburns
          images: images
      else
        slide_images = $.map images, (image) ->
          return { src: image }
        $('#slides').crossSlide({
          sleep: 7
          fade:  1
        }, slide_images)