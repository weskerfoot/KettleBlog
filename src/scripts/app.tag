<app>
  <ul class="navigate tab tab-block">
    <li class={"navigate-tab tab-item " + (this.active.posts ? "active" : "")}>
      <a
        class={"navigate-item " + (this.active.posts ? "tab-active" : "")}
        onclick={to(`posts/${this.state.pid}`)}
        href="#"
      >
        Posts
      </a>
    </li>
    <li class={"navigate-tab tab-item animated fadeIn " + (this.active.projects ? "active" : "")}>
      <a
        class={"navigate-item " + (this.active.projects ? "tab-active" : "")}
        onclick={to("projects")}
        href="#"
      >
        Projects
      </a>
    </li>
  </ul>
  <div class="projects-content">
    <loading if={!this.state.loaded}></loading>
    <projectsview
      class="animated fadeInDown"
      if={this.active.projects && this.state.loaded}
      state={this.state}
      ref="projectsview"
    >
    </projectsview>
  </div>
  <div class="content">
    <postsview
      state={this.state}
      if={this.active.posts}
      ref="postsview"
    >
    </postsview>
  </div>
<script>
import './projectsview.tag';
import './postsview.tag';
import './loading.tag';
import Z from './zipper.js';

import route from 'riot-route';
this.route = route;
this.riot = riot;

this.state = {
  "pid" : 1,
  "projects" : Z.empty,
  "loaded" : false
};

this.active = {
  "projects" : false,
  "posts" : false
};

var self = this;

function projects() {
  self.active.projects = true;
  self.active.posts = false;
  self.update();
}

function posts(pid) {
  self.active.posts = true;
  self.state.pid = parseInt(pid, 10);
  self.active.projects = false;
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

this.route("posts", self.to(`posts/${self.state.pid}`));
this.route("posts/*", posts);
this.route("/", self.to("posts"));
this.route("projects", projects);

this.on("mount", () => {
  route.start(true);
});

function loaduser() {
  /* https://api.github.com/users/${self.username}/repos?sort=updated&direction=desc */
  axios.get(`/blog/projects`)
    .then(function(resp) {
      self.state.projects = Z.fromList(resp.data);
      self.state.loaded = true;
      self.update();
    });
}

this.on("mount", loaduser);

</script>
</app>
