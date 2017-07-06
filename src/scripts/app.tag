<app>
  <ul class="navigate tab tab-block">
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
      if={this.active.get("links")}
    >
    </links>
  </div>
<script>
import './navtab.tag';
import './projectsview.tag';
import './postsview.tag';
import './about.tag';
import './links.tag';
import './loading.tag';

import Z from './zipper.js';
import {default as R} from 'ramda';
import route from 'riot-route';
import lens from './lenses.js';

this.R = R;
this.route = route;
this.riot = riot;

this.state = {
  "pid" : 1,
  "projects" : Z.empty,
  "loaded" : false
};

this.active = lens.actives({
  "projects" : false,
  "posts" : false,
  "links" : false,
  "about" : false
});

var self = this;

function activate(page) {
  return function() {
    console.log(`activating ${page}`);
    self.active = lens.setActive(self.active, page);
    self.update();
  };
}

var projects = activate("projects");
var about = activate("about");
var links = activate("links");

function posts(pid) {
  console.log(self.state);
  self.state.pid = parseInt(pid, 10);
  activate("posts")();
  self.update();
}

to(name) {
  return (function(e) {
    /* This may or may not be used as an event handler */
    if (e !== undefined) {
      e.preventDefault();
    }
    this.route(name);
    return;
  }).bind(this);
}

this.route("/", self.to("posts"));
this.route("posts/*", posts);
this.route("posts", (() => {posts(self.state.pid)}));
this.route("projects", projects);
this.route("about", about);
this.route("links", links);

this.on("mount", () => {
  route.start(true);
});

function loaduser() {
  /* https://api.github.com/users/${self.username}/repos?sort=updated&direction=desc */
  axios.get(`/blog/projects`)
    .then(function(resp) {
      self.state.projects = Z.fromList(
                              resp.data.filter(
                                R.pathEq(["fork"], false)));

      self.state.loaded = true;
      self.update();
    });
}

this.on("mount", loaduser);

</script>
</app>
