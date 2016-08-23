
/*
$(function() {
    $("tr[class=tr1]").find("td[class=extra]").hide();
    $("th[class=extra]").hide();
    $("table").click(function(event) {
        event.stopPropagation();
        var $target = $(event.target);
        $target.closest("td[class=extra]").show();
        //$target.slideUp();
        $target.closest("tr").prev().find("td:first").html("+");
    });
});
*/

$(document).ready(function () {

  //grab all header rows
  $('table[class=my_table]').find('thead th').each(function (column) {
    $(this).addClass('sortable').click(function () {
      var findSortKey = function ($cell) {
        return $cell.find('.sort-key').text().toUpperCase()+ ' ' + $cell.text().toUpperCase();
      };
      var sortDirection = $(this).is('.sorted-asc') ? -1 : 1;
      var $rows = $('table[class=my_table]').find('tbody tr').get();
      var bob = 0;
      //loop through all the rows and find
      $.each($rows, function (index, row) {
        row.sortKey = findSortKey($(row).children('td').eq(column));
      });

      //compare and sort the rows alphabetically or numerically
      $rows.sort(function (a, b) {                       
        if (a.sortKey.indexOf('-') == -1 && (!isNaN(a.sortKey) && !isNaN(a.sortKey))) {
          //Rough Numeracy check                          
          if (parseInt(a.sortKey) < parseInt(b.sortKey)) {
            return -sortDirection;
          }
          if (parseInt(a.sortKey) > parseInt(b.sortKey)) {                                
            return sortDirection;
          }
        } else {
          if (a.sortKey < b.sortKey) {
            return -sortDirection;
          }
          if (a.sortKey > b.sortKey) {
            return sortDirection;
          }
        }
        return 0;
      });

      //add the rows in the correct order to the bottom of the table
      $.each($rows, function (index, row) {
        $('tbody').append(row);
        row.sortKey = null;
      });

      //identify the column sort order
      $('th').removeClass('sorted-asc sorted-desc');
      var $sortHead = $('th').filter(':nth-child(' + (column + 1) + ')');
      sortDirection == 1 ? $sortHead.addClass('sorted-asc') : $sortHead.addClass('sorted-desc');

      //identify the column to be sorted by
      $('td').removeClass('sorted').filter(':nth-child(' + (column + 1) + ')').addClass('sorted');
    });
  });
});
        
        
        
        
