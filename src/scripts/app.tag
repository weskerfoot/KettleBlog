<app>
  <div
    style={{"border-bottom" : showBorder ? "solid 1px" : "none" }}
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
        items={["Programming", "Books", "Philosophy"]}>
      </sidebar>
    </section>

    <div class={"show-md show-sm show-xs navigate-small dropdown dropdown-right " + (menuActive ? "active" : "")}>
      <button onclick={menuOn} class="mobile-navigate btn btn-link navigate-item dropdown-toggle" tabindex="0">
        <i class="bar-menu fa fa-bars" aria-hidden="true"></i>
      </button>
      <!-- menu component -->
      <ul
        show={menuActive}
        class="mobile-menu tab tab-block menu">
        <li
          each="{page in ['posts', 'projects', 'links', 'about']}"
          class={"navigate-tab tab-item animated fadeIn " + (this.parent.active.get(page) ? "active" : "")}
          data-is="navtab"
          active={this.parent.active.get(page)}
          to={this.parent.to(page)}
          title={page}
          onclick={this.parent.menuOff}
        >
        </li>
      </ul>
    </div>

    <ul class="hide-md hide-sm hide-xs navigate tab tab-block">
      <li
        each="{page in ['posts', 'projects', 'links', 'about']}"
        class={"navigate-tab tab-item animated fadeIn " + (this.parent.active.get(page) ? "active" : "")}
        data-is="navtab"
        active={this.parent.active.get(page)}
        to={this.parent.to(page)}
        title={page}
      >
      </li>
    </ul>
    <div class="projects-content">
      <loading if={!this.state.loaded}></loading>
      <projectsview
        class="animated fadeInDown"
        if={this.active.get("projects") && this.state.loaded}
        state={this.state}
        ref="projectsview"
      >
      </projectsview>
    </div>

    <div class="content">
      <postsview
        cached={this.cached}
        state={this.state}
        if={this.active.get("posts")}
        ref="postsview"
      >
      </postsview>
      <about
        if={this.active.get("about")}
      >
      </about>
      <links
        cached={this.cached}
        state={this.state}
        if={this.active.get("links")}
      >
      </links>
    </div>
  </div>
<script>
import './sidebar.tag';
import './navtab.tag';
import './projectsview.tag';
import './postsview.tag';
import './about.tag';
import './links.tag';
import './loading.tag';

import fetchCached from 'fetch-cached';
import Z from './zipper.js';
import pathEq from 'ramda/src/pathEq';
import route from 'riot-route';
import lens from './lenses.js';
import { throttle } from 'lodash-es';

var self = this;

self.cache = {};

self.throttle = throttle;

self.showBorder = false;

window.addEventListener("scroll",
  throttle((ev) => {
    self.update({"showBorder" : window.pageYOffset != 0});
  },
  400)
);

self.cached = fetchCached({
  fetch: fetch,
  cache: {
    get: ((k) => {
      return new Promise((resolve, reject) => {
        resolve(self.cache[k]);
      });
    }),
    set: (k, v) => { self.cache[k] = v; }
  }
});

self.route = route;
self.riot = riot;
self.menuActive = false;
self.currentPage = "";

RiotControl.on("postswitch",
  (ev) => {
    self.update(
      {
        "currentPage" : ev.title
      })
    }
  );

self.route.base('#!')

this.state = {
  "_id" : false,
  "projects" : Z.empty,
  "loaded" : false
};

this.active = lens.actives({
  "projects" : false,
  "posts" : false,
  "links" : false,
  "about" : false
});

menuOn(ev) {
  ev.preventDefault();
  console.log("clicked it");
  self.menuActive = true;
  self.update();
}

menuOff(ev) {
  ev.preventDefault();
  console.log("trying to close it");
  self.menuActive = false;
  self.update();
}

function activate(page) {
  return function() {
    if (page !== "posts") {
      document.title = `${page.slice(0,1).toUpperCase()}${page.slice(1,page.length)}`;
      self.currentPage = document.title;
    }
    console.log(`activating ${page}`);
    self.active = lens.setActive(self.active, page);
    self.update();
  };
}

var projects = activate("projects");
var about = activate("about");
var links = activate("links");

function posts(_id) {
  console.log(self.state);
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
    this.route(name);
    return;
  }).bind(this);
}

this.route("/", self.to("posts"));
this.route("posts/*", posts);
this.route("posts", (() => {posts(self.state._id)}));
this.route("projects", projects);
this.route("about", about);
this.route("links", links);

this.on("mount", () => {
  route.start(true);
});

function loaduser() {
  /* https://api.github.com/users/${self.username}/repos?sort=updated&direction=desc */
  self.cached(`/blog/projects`)
    .then((resp) => resp.json())
    .then((resp) => {
      self.state.projects = Z.fromList(
                              resp.filter(
                                pathEq(["fork"], false)));

      self.state.loaded = true;
      self.update();
    });
}

this.on("mount", loaduser);

</script>
</app>
