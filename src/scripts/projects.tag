<projects>
    <div class="projects-box">
      <h3>My Projects</h3>
      <div class="text-break">
        <div if={this.swipe} class={`card animated ${this.transition}`}>
          <div class="card-header">
            <h4 class="card-title">{ this.project().name }</h4>
          </div>
          <div class="card-body">
            <a
              target="_blank"
              href={this.project().html_url}>
              See on github
            </a>
            <p>{ this.project().description }</p>
            <p>{ this.project().language }</p>
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

var cycle_timeout = 12;

this.username = "Wes";

var self = this;

self.transition = "";
self.swipe = true;

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
