<projects>
    <div class="projects-box">
      <div
        class="columns"
      >
        <div class="column col-8">
          <h4 class="float-right">
            Projects I Work On
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
      <div
        if={!loading} class="text-break"
      >
        <div if={this.swipe} class={"projects-card card animated "+this.transition}>
          <div class="card-header">
            <h5
              class="show-sm show-xs project-title"
              style={
                {
                  "margin" : "auto",
                  "text-align" : "center"
                }
              }
            >
              { this.project().name }
            </h5>
            <h3
              class="hide-sm hide-xs project-title"
              style={
                {
                  "margin" : "auto",
                  "text-align" : "center"
                }
              }
            >
              { this.project().name }
            </h3>
            <h5 class="project-description">{ this.project().description }</h5>
          </div>
          <div class="card-body">
            <div class="tile">
              <div class="tile-content">
                <div class="container">
                  <div class="columns">
                    <div class="col-md-12">
                      <p class="tile-title">Written primarily in { this.project().language} </p>
                    </div>
                  </div>
                  <div class="columns">
                    <div class="col-md-12">
                      <p class="tile-subtitle">Started on {moment(this.project().created_at).format("MMMM Do YYYY") }</p>
                    </div>
                  </div>
                </div>
              </div>
              <div class="tile-action">
                <div class="container">
                  <div class="columns">
                    <div class="col-12">
                      <iframe
                        style={
                          {
                            "float" : "right",
                            "margin-bottom" : "8px"
                          }
                        }
                        src={"https://ghbtns.com/github-btn.html?user=weskerfoot&repo="+this.project().name+"&type=star&count=false&size=large"}
                        frameborder="0"
                        scrolling="0"
                        width="72px"
                        height="30px"
                      >
                      </iframe>
                    </div>
                    <div class="col-12">
                      <iframe
                        style={
                          {
                            "float" : "right"
                          }
                        }
                        src={"https://ghbtns.com/github-btn.html?user=weskerfoot&repo="+this.project().name+"&type=fork&count=false&size=large"}
                        frameborder="0"
                        scrolling="0"
                        width="72px"
                        height="30px"
                      >
                      </iframe>
                    </div>
                  </div>
                </div>
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
  self.update(
    {
      "transition" : "fadeInRight",
      "swipe" : true
    }
  );
}

prev() {
  self.update({"swipe" : false});
  self.projects = Z.goLeft(self.projects);
  self.update(
    {
      "transition" : "fadeInLeft",
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
