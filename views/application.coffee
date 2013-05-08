$ ->
  $('#preset').change ->
    sel = $(@).find("option:selected");
    $('input#f_key').val(sel.attr('data-name'));
    $('input#f_val').val(sel.attr('data-value'));
    
    @
