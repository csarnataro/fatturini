# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready =>
  $('#invoice_client_id').change (event, data) ->
    default_term = ""
    $.get("/clients/" + $(event.currentTarget).val() + "/defaults.json", {}, (response)->
      default_term = response.default_term
      default_footer = response.footer_id
      default_notes = response.default_notes
      if default_term != null
        $('#invoice_term').val(default_term)
      if default_footer != null
        $('#invoice_footer_id').val(default_footer)
      if default_notes != null
        $('#invoice_notes').val(default_notes)

    , "json")

$('#invoice_print_button').click -> 
  alert $('#invoice_status').val()
  if $('#invoice_status').val() == 'draft'
    window.location.reload(false)
