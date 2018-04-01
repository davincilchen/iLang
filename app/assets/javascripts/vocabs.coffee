# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
EnableFlipButton = ->
  $('#flip-flashcard').prop 'disabled', false
  $('#flip-flashcard').css 'color', 'white'
  return
  
DisableFlipButton = ->
  $('#flip-flashcard').prop 'disabled', true
  $('#flip-flashcard').css 'color', 'grey'
  return

$(document).on 'turbolinks:load', ->
  $('.flascard-item').each (e) ->
    if e != 0
      $(this).hide()
    return
  $('#next-flashcard').click ->
    EnableFlipButton()
    if $('.flascard-item:visible').next().length != 0
      $('.flascard-item:visible').next().show().prev().hide()
    else
      $('.flascard-item:visible').hide()
      $('.flascard-item:first').show()
    true
  $('#previous-flashcard').click ->
    EnableFlipButton()
    if $('.flascard-item:visible').prev().length != 0
      $('.flascard-item:visible').prev().show().next().hide()
    else
      $('.flascard-item:visible').hide()
      $('.flascard-item:first').show()
    true
  $('#flip-flashcard').on 'click', (event) ->
    console.log 'the button is clicked'
    $('.flascard-item:visible .flashcard-value p').css 'display', 'block'
    DisableFlipButton()
    return
  return