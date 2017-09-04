<projects>
    <div class="projects-box">
      <div class="columns">
        <div class="column col-8">
          <h4 class="float-right">
            Some Projects I Work On
          </h4>
        </div>
        <div class="column col-4">
          <figure
            if={!loading}
            class="float-left avatar my-avatar avatar-lg"
          >
            <img src={this.project().owner.avatar_url}></img>
          </figure>
        </div>
      </div>

      <loading if={loading}></loading>
      <div if={!loading} class="text-break">
        <div if={this.swipe} class={"card animated "+this.transition}>
          <div class="card-header">
            <h3 class="card-title project-title">{ this.project().name }</h3>
            <h5 class="project-description">{ this.project().description }</h5>
          </div>
          <div class="card-body">
            <div class="tile">
              <div class="tile-content">
                <p class="tile-title">Written primarily in { this.project().language} </p>
                <p class="tile-subtitle">Started on {moment(this.project().created_at).format("MMMM Do YYYY") }</p>
              </div>
              <div class="tile-action">
              <a
                target="_blank"
                href={this.project().html_url}>
                  <button class="btn btn-primary branded">
                    See on github
                  </button>
              </a>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="controls container">
        <div class="columns">
          <div class="column col-6">
            <button
              onclick={this.prev}
              class="btn btn-lg nav-button float-right branded"
            >
              <i class="fa fa-arrow-left" aria-hidden="true"></i>
            </button>
          </div>
          <div class="column col-6">
            <button
              onclick={this.next}
              class="btn btn-lg nav-button float-left branded"
            >
              <i class="fa fa-arrow-right" aria-hidden="true"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
    </div>
<script>
import './loading.tag';
import Z from './zipper.js';
import moment from 'moment/min/moment.min';
import pathEq from 'ramda/src/pathEq';
var cycle_timeout = 12;

var self = this;

self.loading = true;
self.transition = "";
self.swipe = true;
self.moment = moment;
self.projects = Z.empty;

var empty_project = {
  "name" : "",
  "html_url": "",
  "description" : "",
  "language": ""
};

project() {
  return Z.focus(self.projects, empty_project);
}

next() {
  self.update({"swipe" : false});
  self.projects = Z.goRight(self.projects);
  console.log(self.project());
  self.update(
    {
      "transition" : "flipInX",
      "swipe" : true
    }
  );
}

prev() {
  self.update({"swipe" : false});
  self.projects = Z.goLeft(self.projects);
  self.update(
    {
      "transition" : "flipInX",
      "swipe" : true
    }
  );
}

function loaduser() {
  /* https://api.github.com/users/${self.username}/repos?sort=updated&direction=desc */
  window.cached("/blog/ghprojects")
    .then((resp) => resp.json())
    .then((resp) => {
      self.projects = Z.fromList(
                              resp.filter(
                                pathEq(["fork"], false)));

      self.loading = false;
      self.update();
    });
}

function loopProjects() {
  if (self.projects) {
    self.next();
  }
  window.setTimeout(loopProjects, cycle_timeout*1000);
}

self.on("mount", loaduser);

/* window.setTimeout(loopProjects, cycle_timeout*1000); */

</script>
</projects>
