function(head, req) {
  var row, results;
  var results = [];
  var categories = (req.query.categories !== undefined ? JSON.parse(req.query.categories) : []);
  var num = parseInt(req.query.num, 10);
  var getlast = req.query.getlast;
  var full_results;

  if (getlast == undefined) {
    while (results.length < num && (row = getRow())) {
      if (categories.length == 0 ||
          categories.some(function(c) { return row.value.categories.indexOf(c) !== -1; })) {
        results.push([row.value.categories, row.value]);
      }
    }
    full_results = results;
  }
  else {
    while (row = getRow()) {
      if (categories.length == 0 ||
          categories.some(function(c) { return row.value.categories.indexOf(c) !== -1; })) {
        results.push([row.value.categories, row.value]);
      }
    }
    full_results = results.slice(results.length-(num+1), results.length-1);
  }
  return JSON.stringify({q : req.query.categories, results : full_results});
}
