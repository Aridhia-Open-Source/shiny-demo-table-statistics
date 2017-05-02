

Shiny.addCustomMessageHandler("row_click",
  function(message) {
    var vars = {};
    
    $("#" + message.id).find('tbody tr').each(function(row) {
      var id = $(this).attr('id');
      vars['row' + id] = 0;
      Shiny.onInputChange('row' + id, vars['row' + id]);
      $(this).click(function(event) {
        var clickedClass = event.target.className;
        // don't do anything if action button/link is clicked
        if(clickedClass != 'action-button shiny-bound-input') {
        vars['row' + id] = (vars['row' + id] + 1) % 2;
        Shiny.onInputChange('row' + id, vars['row' + id]);
        }
      });
  });
  }
);
