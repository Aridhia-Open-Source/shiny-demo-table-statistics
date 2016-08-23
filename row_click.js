

$(document).ready(function() {
  var vars = {};
  
  $('#myTable').find('tbody tr').each(function(row) {
    var id = $(this).attr('id');
    vars['row' + id] = 0;
    Shiny.onInputChange('row' + id, vars['row' + id]);
    //input['row' + id] = 0;
    $(this).click(function() {
      alert('Was ' + vars['row' + id]);
      alert('clicked a row ' + id);
      vars['row' + id] = (vars['row' + id] + 1) % 2;
      Shiny.onInputChange('row' + id, vars['row' + id]);
      alert('Now ' + vars['row' + id]);
    });
  });
});

