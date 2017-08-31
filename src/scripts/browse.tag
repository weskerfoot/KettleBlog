<browse>
  <div class="browse-content container">
    <div
      style={navStyle}
      class="container"
    >
      <div class="columns">
        <div class="col-4">
          <button
            disabled={opts.state.pagenum == 0}
            class="btn btn-primary branded"
            style={prevStyle}
            onclick={getprev}
          >
            Previous
          </button>
        </div>
        <div class="col-4">
          <button
            class="btn btn-primary branded"
            disabled={opts.state.results.length != pagesize}
            style={nextStyle}
            onclick={getmore}
          >
            Next
          </button>
        </div>
        <div class="col-4"></div>
      </div>
    </div>
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
              href={"/blog/posts/"+result[1].id}
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
self.converter = new showdown.Converter();
self.pagesize = 4;

self.openPost = (id) => {
  return ((ev) => {
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

self.prevStyle = {
  "float" : "right"
}

self.nextStyle = {
  "float" : "left"
}

self.navStyle = {
  "margin-top" : "8px"
};

self.filterCategories = (category) => {
  return ((ev) => {
    if (ev !== undefined) {
      ev.preventDefault();
    }

    self.route(`browse/${category}`);
    self.update({
      "loading" : true
    });
    self.opts.state.pagenum = 0;
    self.opts.state.category_filter = category;

    window.cached(`/blog/getbrowse/${category}/${self.pagesize}/${self.startkey ? self.startkey : ""}`)
    .then((resp) => { return resp.json() })
    .then((results) => {
      self.opts.state.results = results;
      self.update({
        "loading" : false
      });
    });
  })
}

self.getPrev = (endkey) => {
    self.update({"loading" : true});
    var endpoint;

    if (self.opts.state.category_filter) {
      endpoint = `/blog/prevbrowse/${self.opts.state.category_filter}/${self.pagesize}/${endkey}`;
    }
    else {
      endpoint = `/blog/prevbrowse/${self.pagesize}/${endkey}`;
    }
    self.opts.state.pagenum--;

    window.cached(endpoint)
    .then((resp) => { return resp.json() })
    .then((results) => {
      self.opts.state.results = results;
      self.update({
        "loading" : false
      });
    });
}

self.getNext = (startkey) => {
    self.update({"loading" : true});
    var endpoint;

    if (self.opts.state.category_filter) {
      endpoint = `/blog/getbrowse/${self.opts.state.category_filter}/${self.pagesize}/${startkey}`;
    }
    else {
      endpoint = `/blog/getbrowselim/${self.pagesize}/${startkey}`;
    }
    self.opts.state.pagenum++;

    window.cached(endpoint)
    .then((resp) => { return resp.json() })
    .then((results) => {
      self.opts.state.results = results;
      self.update({
        "loading" : false
      });
    });
}

self.getInitial = () => {
  self.update({"loading" : true});
  self.opts.state.pagenum = 0;
  self.opts.state.category_filter = false;
  window.cached(`/blog/getbrowse/${self.pagesize}`)
    .then((resp) => { return resp.json() })
    .then((results) => {
      self.opts.state.results = results;
      self.update({
        "loading" : false
      });
    });
}

self.getmore = (ev) => {
  ev.preventDefault();
  self.getNext(self.opts.state.results.slice(-1)[0][1].id)
}

self.getprev = (ev) => {
  ev.preventDefault();
  self.getPrev(self.opts.state.results[0][1].id)
}

self.on("mount", () => {
  if (!self.opts.state.category_filter && !self.opts.state.category_tag) {
    self.getInitial();
  }
  else if (self.opts.state.category_tag) {
    self.filterCategories(self.opts.state.category_tag)();
  }
  else if (self.opts.state.category_filter) {
    self.filterCategories(self.opts.state.category_filter)();
  }
});

</script>
</browse>
