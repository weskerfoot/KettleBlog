<browse>
  <div>
    <div
      class="card"
      each={result in opts.state.results}
    >
      <div class="card-header">
        <a href={"/blog/posts/"+result[1].id}>
          <h3 class="card-title">
            { result[1].title } by { result[1].author }
          </h3>
        </a>
      </div>
      <div class="card-body">
        <raw content="{ result[1].content }"></raw>
      </div>
    </div>
  </div>

<script type="es6">
import './raw.tag';
import route from 'riot-route';

var self = this;
</script>
</browse>
