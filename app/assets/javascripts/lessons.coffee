# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/$ ->
$(document).on 'change', '#friends_select,#role', (evt) ->
    $.ajax 'update_languages',
      type: 'GET'
      dataType: 'script'
      data: {
        friendship_id: $("#friends_select option:selected").val(),
        role: $("#role option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic friend select OK!")
