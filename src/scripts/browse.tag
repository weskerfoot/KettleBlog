<browse>
  <menu
    name="Categories"
    items={opts.state.categories}
    onfilter={filterCategories}
  >
  </menu>
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
import './menu.tag';
import route from 'riot-route';
import { default as RiotControl } from 'riotcontrol';

var self = this;

self.route = route;

self.openPost = (id) => {
  return ((ev) => {
    console.log(id);
    console.log(RiotControl.trigger);
    RiotControl.trigger("openpost", id);
  });
};

self.cardStyle = {
  "margin" : "auto"
};

self.filterCategories = (category) => {
  return ((ev) => {
    ev.preventDefault();
    return self.route(`browse/${category}`);
  });
};

</script>
</browse>
