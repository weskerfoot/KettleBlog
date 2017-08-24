function(head, req) {
  var row, results;
  results = [];
  categories = (req.query.categories !== undefined ? JSON.parse(req.query.categories) : []);
  while (row = getRow()) {
    if (categories.length == 0 ||
        categories.some(function(c) { return row.key.indexOf(c) !== -1; })) {
      results.push([row.key, row.id]);
    }
  }
  return JSON.stringify({q : req.query.categories, results : results});
}
