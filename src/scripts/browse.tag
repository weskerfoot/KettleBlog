<browse>
  <div class="browse-content container">
    <div class="columns">
      <div class="column hide-xs hide-sm hide-md col-3">
        <categoryfilter
          name="Categories"
          category={opts.state.category_filter}
          items={opts.state.categories}
          onfilter={filterCategories}
        >
        </categoryfilter>
      </div>
      <div class="column col-sm-12 col-9">
        <loading if={loading}></loading>
        <div
          if={!loading}
          style={cardStyle}
          class="card"
          each={result in opts.state.results}
        >
          <div class="card-header">
            <h3 class="card-title">
              { result[1].title } by { result[1].author }
            </h3>
          </div>
          <div class="card-body">
            <raw content="{ converter.makeHtml(result[1].content) }"></raw>
            <a
              style={linkStyle}
              onclick={openPost(result[1].id)}
            >
              Read More
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>

<script type="es6">
import './raw.tag';
import './categoryfilter.tag';
import './loading.tag';
import route from 'riot-route';
import { default as RiotControl } from 'riotcontrol';
import { default as showdown } from 'showdown';

var self = this;

self.route = route;
self.loading = false;
self.category = self.opts.state.category_filter;
self.converter = new showdown.Converter();

self.openPost = (id) => {
  return ((ev) => {
    self.route(`/posts/${id}`);
    RiotControl.trigger("openpost", id);
  });
};

self.cardStyle = {
  "margin" : "auto",
  "margin-top" : "8px"
};

self.linkStyle = {
  "cursor" : "pointer"
};

self.filterCategories = (category) => {
  return ((ev) => {
    ev.preventDefault();

    self.update({
      "loading" : true
    });
    self.opts.state.category_filter = category;

    self.route(`browse/${category}`);
    window.cached(`/blog/getbrowse/${category}/0`)
    .then((resp) => { return resp.json() })
    .then((results) => {
      self.opts.state.results = results;
      self.update({
        "loading" : false
      });
    });
  })
}

self.getInitial = () => {
    self.update({"loading" : true});
    window.cached(`/blog/getbrowse/0`)
    .then((resp) => { return resp.json() })
    .then((results) => {
      self.opts.state.results = results;
      self.update({
        "loading" : false
      });
    });
}

self.on("mount", () => {
  if (!self.opts.state.category_filter) {
    self.getInitial();
  }
});

</script>
</browse>
