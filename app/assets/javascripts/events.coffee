# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.new_event_begin_date').datepicker({ dateFormat: 'dd/mm/yy' })

$ ->
  $('.new_event_end_date').datepicker({ dateFormat: 'dd/mm/yy' })