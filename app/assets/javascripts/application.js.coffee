# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery_ujs
#= require_tree .

$(document).ready ->
  weddingDate = new Date('October 8, 2011 12:20:00 pm MST')
  highlightLastDay = (periods) ->
    if $.countdown.periodsToSeconds(periods) < 86400
      $(this).addClass('highlight')
  $('#countdown').countdown
    until: weddingDate
    onTick: highlightLastDay