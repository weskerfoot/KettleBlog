function(head, req) {
  var row, results;
  var results = [];
  var categories = (req.query.categories !== undefined ? JSON.parse(req.query.categories) : []);
  var num = req.query.num;

  while (results.length < num && (row = getRow())) {
    if (categories.length == 0 ||
        categories.some(function(c) { return row.value.categories.indexOf(c) !== -1; })) {
      results.push([row.value.categories, row.value]);
    }
  }
  return JSON.stringify({q : req.query.categories, results : results});
}
