import './grid.tag';
import './row.tag';
import './column.tag';
import unfold from 'ramda/src/unfold';
import take from 'ramda/src/take';
import drop from 'ramda/src/drop';
import length from 'ramda/src/length';

function chunk(n, xs) {
  /* Chunk a list into groups of n size */
  return unfold(
    (xs) => {
      if (length(xs) > 0) {
        return [{"row" : take(n, xs)}, drop(n, xs)];
      }
      return false;
    }, xs);
}
