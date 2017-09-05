<browse>
  <div class="browse-content container">
    <div
      style={navStyle}
      class="container"
    >
      <div
        if={opts.state.pagenum > 0 ||
            opts.state.results.length == pagesize}
        class="columns"
      >
        <div class="col-4">
          <button
            disabled={(opts.state.pagenum == 0) || loading}
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
            disabled={((opts.state.results.length != pagesize) ||
                        loading ||
                        disabled)}
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
      <div
        style={sidebarStyle}
        class="column hide-xs hide-sm hide-md col-2"
      >
        <categoryfilter
          name="Post Categories"
          category={opts.state.category_filter}
          items={opts.state.categories}
          onfilter={filterCategories}
        >
        </categoryfilter>
      </div>
      <div class="column col-sm-12 col-10">
        <loading if={loading}></loading>
        <div
          if={!loading}
          style={cardStyle}
          class="animated fadeIn card post-card"
          each={result in opts.state.results}
        >
          <div class="card-header">
            <h2 class="card-title">
              { result[1].title }
            </h2>
          </div>
          <div class="card-body">
            <div
              data-is="raw"
              class="summary"
              content="{ converter.makeHtml(result[1].content)}"
            >
            </div>
            <button
              class="btn btn-link readmore"
              style={linkStyle}
              onclick={openPost(result[1].id)}
            >
              Read More
            </button>
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
self.disabled = false;
self.converter = new showdown.Converter();
self.pagesize = 4;

self.openPost = (id) => {
  return ((ev) => {
    RiotControl.trigger("openpost", id);
  });
};

self.cardStyle = {
  "margin" : "auto",
  "margin-top" : "13px"
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

self.sidebarStyle = {
  "margin-right" : "-40px"
};

self.filterCategories = (category) => {
  return ((ev) => {
    if (ev !== undefined) {
      ev.preventDefault();
    }

    self.route(`browse/${category}`);
    self.update({
      "disabled" : false,
      "loading" : true
    });
    self.opts.state.pagenum = 0;
    self.opts.state.category_filter = category;
    self.opts.state.category_tag = category;

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

    window.cached(endpoint)
    .then((resp) => { return resp.json() })
    .then((results) => {
      self.opts.state.pagenum--;
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

    window.cached(endpoint)
    .then((resp) => { return resp.json() })
    .then((results) => {
      if (results.length > 0) {
        self.opts.state.results = results;
        self.opts.state.pagenum++;
      }
      else {
        self.disabled = true;
      }
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

self.addEls = () => {
  var summaries = document.getElementsByClassName("summary");
  for(var i = 0; i < summaries.length; i++) {
    var paragraphs = summaries[i].getElementsByTagName("p");
    var paragraph = paragraphs[paragraphs.length-1];
    paragraph.textContent = paragraph.textContent+"…";
    paragraph.className = "blurmore";
  }
};

self.on("mount", () => {
  self.on("updated", self.addEls);
  if (!self.opts.state.category_filter &&
      !self.opts.state.category_tag &&
      self.opts.state.results.length == 0) {
    self.getInitial();
  }
  else if (self.opts.state.category_tag) {
    self.filterCategories(self.opts.state.category_tag)();
  }
  else if ((self.opts.state.results.length > 0) &&
            !self.opts.state.category_tag) {
    self.addEls();
    return;
  }
  else {
    self.filterCategories(self.opts.state.category_filter)();
  }
});

</script>
</browse>
