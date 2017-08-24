<browse>
  <div>
  <ul>
    <li each={result in opts.state.results}>
      <h3>{ JSON.stringify(result) }</h3>
    </li>
  </ul>
  </div>

<script type="es6">
import route from 'riot-route';

var self = this;
</script>
</browse>
