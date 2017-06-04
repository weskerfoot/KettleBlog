import './grid.tag';
import './row.tag';
import './column.tag';
import { default as R } from 'ramda';

function chunk(n, xs) {
  /* Chunk a list into groups of n size */
  return R.unfold(
    (xs) => {
      if (R.length(xs) > 0) {
        return [{"row" : R.take(n, xs)}, R.drop(n, xs)];
      }
      return false;
    }, xs);
}
