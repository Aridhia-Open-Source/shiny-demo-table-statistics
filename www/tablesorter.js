


Shiny.addCustomMessageHandler("tablesorter",
  function(message) {
    $("#" + message.id).tablesorter({headers: {3: {sorter: false}}});
  }
);

