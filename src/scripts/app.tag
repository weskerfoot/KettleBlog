<app>
  <div
    style={
            {
              "border-bottom" : showBorder ? "solid 1px" : "none",
              "opacity" : showBorder ? "0.7" : "1",
              "background-color" : showBorder ? "white" : "white"
            }
          }
    class="header"
  >
    <section style={{"margin-top" : "0px"}} class="text-center nav navbar centered navbar-section">
      <h4 class="blog-title">{ currentPage }</h4>
    </section>
  </div>
  <div class="app-body">

    <section class="text-center nav navbar centered navbar-section">
      <sidebar
        if={this.active.get("posts")}
        name="Filter By Category"
        items={state.categories}>
      </sidebar>
    </section>

    <div id="menu"
      class={"show-md show-sm show-xs navigate-small dropdown dropdown-right " + (menuActive ? "active" : "")}
    >
      <button onclick={menuOn} class="mobile-navigate btn btn-link navigate-item dropdown-toggle" tabindex="0">
        <i class="bar-menu fa fa-bars" aria-hidden="true"></i>
      </button>
      <!-- menu component -->
      <ul
        show={menuActive}
        class="mobile-menu tab tab-block menu">
        <li
          each="{page in ['posts', 'projects', 'links', 'about']}"
          class={"navigate-tab tab-item " + (parent.active.get(page) ? "active" : "")}
          data-is="navtab"
          active={parent.active.get(page)}
          to={parent.to(page)}
          title={page}
          onclick={parent.menuOff}
        >
        </li>
      </ul>
    </div>

    <ul class="hide-md hide-sm hide-xs navigate tab tab-block">
      <li
        each="{page in ['posts', 'projects', 'links', 'about']}"
        class={"navigate-tab tab-item " + (parent.active.get(page) ? "active" : "")}
        data-is="navtab"
        active={parent.active.get(page)}
        to={parent.to(page)}
        title={page}
      >
      </li>
    </ul>
    <div class="projects-content">
      <projectsview
        class=""
        if={active.get("projects")}
        state={state}
        ref="projectsview"
      >
      </projectsview>
    </div>

    <div class="content">
      <postsview
        state={state}
        if={active.get("posts")}
        ref="postsview"
      >
      </postsview>
      <about
        if={active.get("about")}
      >
      </about>
      <links
        state={state}
        if={active.get("links")}
      >
      </links>
      <browse
        state={state}
        if={active.get("browse")}
      >
      </browse>
    </div>
  </div>
<script>
import './sidebar.tag';
import './navtab.tag';
import './projectsview.tag';
import './postsview.tag';
import './about.tag';
import './links.tag';
import './browse.tag';

import route from 'riot-route';
import lens from './lenses.js';
import { throttle } from 'lodash-es';

const hashLength = 8;

var self = this;

self.showBorder = false;
self.route = route;
self.riot = riot;
self.menuActive = false;
self.currentPage = self.opts.title;

self.decode = (x) => JSON.parse(decodeURIComponent(x));

window.addEventListener("scroll",
  throttle((ev) => {
    self.update({"showBorder" : window.pageYOffset != 0});
  },
  400)
);

document.addEventListener("click", function(event) {
  if(!event.target.closest('#menu')) {
    if (self.menuActive) {
      self.menuOff();
    }
  }
});

window.RiotControl.on("postswitch",
  (ev) => {
    self.update(
      {
        "currentPage" : ev.title
      })
    }
);

self.state = {
    "page" : self.opts.page,
    "results" : self.decode(self.opts.results),
    "start" : self.opts.start,
    "category_filter" : self.decode(self.opts.category_filter),
    "_id" : self.opts.postid.slice(-hashLength),
    "author" : self.opts.author,
    "title" : self.opts.title,
    "loaded" : false,
    "initial" : document.getElementsByTagName("noscript")[0].textContent,
    "links" : self.decode(self.opts.links),
    "categories" : self.decode(self.opts.categories)
};

self.active = lens.actives({
  "projects" : false,
  "posts" : false,
  "links" : false,
  "about" : false,
  "browse" : false
});

menuOn(ev) {
  ev.preventDefault();
  console.log("clicked it");
  self.menuActive = true;
  self.update();
}

menuOff(ev) {
  if (ev !== undefined) {
    ev.preventDefault();
  }
  self.menuActive = false;
  self.update();
}

function activate(page) {
  return function() {
    if (page !== "posts") {
      document.title = page.slice(0,1).toUpperCase()+page.slice(1,page.length);
      self.currentPage = document.title;
    }
    else {
      self.currentPage = self.state.title;
    }
    self.active = lens.setActive(self.active, page);
    self.update();
  };
}

var projects = activate("projects");
var about = activate("about");
var links = activate("links");
var browse = activate("browse");

function posts(_id) {
  if (self.state._id != _id) {
    self.state._id = _id;
  }
  activate("posts")();
  self.update();
}

to(name) {
  return (function(e) {
    /* This may or may not be used as an event handler */
    if (e !== undefined) {
      e.preventDefault();
      this.menuOff(e);
    }
    console.log("routing to " + name);
    if (name == "posts") {
      this.route(`${name}/${self.state._id}`);
    }
    else {
      this.route(name);
    }
    return;
  }).bind(this);
}

self.on("mount", () => {
  window.RiotControl.addStore(new riot.observable());
  RiotControl.on("openpost",
    (id) => {
      console.log("caught the event in the app tag");
      console.log(`the id is ${id}`);
      posts(id);
    }
  );

  self.route.base('/blog/')
  self.route("/", () => { self.route(`/posts/${self.state._id}`); });
  self.route("/posts", () => { self.route(`/posts/${self.state._id}`); });
  self.route("posts/*", posts);
  self.route("posts", (() => {posts(self.state._id)}));
  self.route("projects", projects);
  self.route("about", about);
  self.route("links", links);
  self.route("browse", browse);
  self.route("browse/*", browse);
  self.route("browse/*/*", browse);
  route.start(true);
});

self.on("unmount", () => {
  RiotControl.off("openpost");
  RiotControl.off("postswitch");
})

</script>
</app>
