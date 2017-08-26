<browse>
  <div
    style={cardStyle}
    class="card content"
    each={result in opts.state.results}
  >
    <div class="card-header">
      <a
        onclick={openPost(result[1].id)}
      >
        <h3 class="card-title">
          { result[1].title } by { result[1].author }
        </h3>
      </a>
    </div>
    <div class="card-body">
    </div>
  </div>

<script type="es6">
import './raw.tag';
import route from 'riot-route';

var self = this;

self.route = route;

self.openPost = (id) => {
  return ((ev) => {
    console.log(id);
    console.log(window.RiotControl.trigger);
  });
};

window.RiotControl.on("openpost",
  (ev) => {
    console.log("caught the event");
  }
);


self.cardStyle = {
  "margin" : "auto"
};

</script>
</browse>
