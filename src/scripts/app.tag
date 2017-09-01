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
    </section>

    <div id="menu"
      class={"show-md show-sm show-xs navigate-small dropdown dropdown-right " + (menuActive ? "active" : "")}
    >
      <button
        onclick={menuOn}
        class="mobile-navigate btn btn-link navigate-item dropdown-toggle branded"
        tabindex="0"
      >
        <i class="bar-menu fa fa-bars" aria-hidden="true"></i>
      </button>
      <!-- menu component -->
      <ul
        show={menuActive}
        class="mobile-menu tab tab-block menu">
        <li
          each="{page in ['browse', 'projects', 'links', 'about']}"
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
        each="{page in ['browse', 'projects', 'links', 'about']}"
        class={"navigate-tab tab-item " + (parent.active.get(page) ? "active" : "")}
        data-is="navtab"
        active={parent.active.get(page)}
        to={parent.to(page)}
        title={page}
      >
      </li>
    </ul>
    <div class="projects-content">
      <projects
        class=""
        if={active.get("projects")}
        state={state}
      >
      </projects>
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
import './projects.tag';
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

/* Mostly contains stuff that is preloaded depending on the page accessed initially */
/* Not meant as the ultimate source of truth for everything */
self.state = {
    "pagenum" : 0, /* the current page of posts in the browse tab */
    "browsed" : false, /* was a link clicked to a post yet? */
    "page" : self.opts.page,
    "results" : self.decode(self.opts.results),
    "category_filter" : self.decode(self.opts.category_filter),
    "category_tag" : false, /* used if browse page accessed by a category tag */
    "_id" : self.opts.postid.slice(-hashLength),
    "author" : self.opts.author,
    "title" : self.opts.title,
    "initial" : document.getElementsByTagName("noscript")[0].textContent,
    "links" : self.decode(self.opts.links),
    "categories" : self.decode(self.opts.categories),
    "post_categories" : self.decode(self.opts.post_categories)
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
    if (page == "browse") {
      document.title = "Wes Kerfoot";
      self.currentPage = document.title;
    }
    else if (page !== "posts") {
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
    if (name != "posts") {
      this.route(name);
    }
    return;
  }).bind(this);
}

self.on("mount", () => {
  window.RiotControl.on("openpost",
    (id) => {
      self.state.browsed = true;
      self.route(`/posts/${id}`);
    }
  );

  window.RiotControl.on("browsecategories",
    (category) => {
      self.state.category_tag = category;
      self.route(`/browse/${category}`);
    });

  window.RiotControl.on("postswitch",
    (ev) => {
      self.update(
        {
          "currentPage" : ev.title
        })
      }
  );

  self.route.base('/blog/')
  self.route("/", () => { self.route("/browse"); });
  self.route("/posts", () => { self.route(`/posts/${self.state._id}`); });
  self.route("posts/*", posts);
  self.route("posts", (() => {posts(self.state._id)}));
  self.route("projects", projects);
  self.route("about", about);
  self.route("links", links);
  self.route("browse/*/*", browse);
  self.route("browse/*", browse);
  self.route("browse", browse);
  route.start(true);
});

</script>
</app>
