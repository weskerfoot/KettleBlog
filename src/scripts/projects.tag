<projects>
    <div class="projects-box">
      <div class="columns">
        <div class="column col-8">
          <h3 class="float-right">My Projects</h3>
        </div>
        <div class="column col-4">
          <figure
            if={this.avatar_url}
            class="float-left avatar avatar-lg"
          >
            <img src={this.avatar_url}></img>
          </figure>
        </div>
      </div>

      <div class="text-break">
        <div if={this.swipe} class={`card animated ${this.transition}`}>
          <div class="card-header">
            <h4 class="card-title post-title">{ this.project().name }</h4>
            <h6 class="post-author">{ this.project().description }</h6>
          </div>
          <div class="card-body">
              <a
                target="_blank"
                href={this.project().html_url}>
                <button class="btn btn-small">
                    See on github
                </button>
              </a>
            <div class="project-content">
              <p>Written primarily in { this.project().language }</p>
              <p>Started on { moment(this.project().created_at).format("MMMM Do YYYY") }</p>
            </div>
          </div>
        </div>
      </div>
      <div class="controls container">
        <div class="columns">
          <div class="column col-6">
            <button
              onclick={this.prev}
              class="btn btn-lg nav-button float-right"
            >
              <i class="fa fa-arrow-left" aria-hidden="true"></i>
            </button>
          </div>
          <div class="column col-6">
            <button
              onclick={this.next}
              class="btn btn-lg nav-button float-left"
            >
              <i class="fa fa-arrow-right" aria-hidden="true"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
    </div>
<script>
import Z from './zipper.js';
import moment from 'moment';

var cycle_timeout = 12;

this.username = "Wes";
this.avatar_url = "";

var self = this;

self.transition = "";
self.swipe = true;
self.moment = moment;

this.on("mount",
  function() {
    self.avatar_url = self.project().owner.avatar_url;
    self.update();
  });

var empty_project = {
  "name" : "",
  "html_url": "",
  "description" : "",
  "language": ""
};

project() {
  return Z.focus(self.opts.state.projects, empty_project);
}

next() {
  self.update({"swipe" : false});
  self.opts.state.projects = Z.goRight(self.opts.state.projects);
  console.log(self.project());
  self.update(
    {
      "transition" : "fadeInRight",
      "swipe" : true
    }
  );
}

prev() {
  self.update({"swipe" : false});
  self.opts.state.projects = Z.goLeft(self.opts.state.projects);
  self.update(
    {
      "transition" : "fadeInLeft",
      "swipe" : true
    }
  );
}

function loopProjects() {
  if (self.opts.state.projects) {
    self.next();
  }
  window.setTimeout(loopProjects, cycle_timeout*1000);
}

/* window.setTimeout(loopProjects, cycle_timeout*1000); */

</script>
</projects>
