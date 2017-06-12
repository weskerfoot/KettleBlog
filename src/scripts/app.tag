<app>
  <ul class="navigate tab tab-block">
    <li class={"tab-item animated fadeIn " + (this.active.projects ? "active" : "")}>
      <a onclick={to("projects")} href="#">Projects</a>
    </li>
    <li class={"tab-item " + (this.active.posts ? "active" : "")}>
      <a onclick={to("posts")} href="#">Posts</a>
    </li>
  </ul>
  <div class="content">
    <loading if={!this.state.loaded}></loading>
    <projectsview
      class="animated fadeInDown"
      if={this.active.projects && this.state.loaded}
      state={this.state}
      ref="projectsview"
    >
    </projectsview>
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

this.route("posts",
  function() {
    self.active.posts = true;
    self.active.projects = false;
    self.update();
  });

this.route("projects",
  function() {
    self.active.projects = true;
    self.active.posts = false;
    self.update();
  });

to(name) {
  return (function(e) {
    e.preventDefault();
    this.route(name);
    return;
  }).bind(this);
}

this.on("mount", () => {
  route.start(true);
});

function loaduser() {
  /* https://api.github.com/users/${self.username}/repos?sort=updated&direction=desc */
  axios.get(`/blog/projects`)
    .then(function(resp) {
      self.state.projects = Z.fromList(resp.data);
      self.state.loaded = true;
      if (!self.active.posts) {
        self.active.projects = true;
      }
      self.update();
    });
}

this.on("mount", loaduser);

</script>
</app>
