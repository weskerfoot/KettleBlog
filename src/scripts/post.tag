<post>
  <h4 class="content-box centered" if={this.nomore}>
    No More Posts!
  </h4>
  <div
    if={!(this.loading || this.nomore)}
    class="content-box post centered"
  >
    <h4>{ this.title }</h4>
    <h5>Posted by { this.author }</h5>
    <p class="post-content centered text-break">
      { this.content }
    </p>
    <div class="divider"></div>
  </div>
  <div class="controls container">
    <div class="columns">
      <div class="column col-6">
        <button class={"btn btn-lg nav-button float-right " + (this.pid <= 1 ? "disabled" : " ") + this.prevloading}
                onclick={this.prev}
        >

          <i class="fa fa-arrow-left" aria-hidden="true"></i>
        </button>
      </div>
      <div class="column col-6">
        <button class={"btn btn-lg nav-button float-left  " + (this.nomore ? "disabled" : " ") + this.nextloading}
                onclick={this.next}
        >
          <i class="fa fa-arrow-right" aria-hidden="true"></i>
        </button>
      </div>
    </div>
  </div>
<script>

import 'whatwg-fetch';
import { default as R } from 'ramda';

var self = this;

self.author = "";
self.title = "";
self.content = "";
self.loading = false;
self.prevloading = "";
self.nextloading = "";

self.nomore = false;
self.content = "";

prev(ev) {
  ev.preventDefault();
  if (self.prevloading || self.nextloading) {
    return;
  }
  self.prevloading = " loading";
  if (self.nomore) {
    self.nomore = false;
  }
  if (self.pid > 1) {
    self.pid--;
    self.update();
  }
  self.setPost(self.pid);
}

next(ev) {
  ev.preventDefault();
  if (self.nextloading || self.prevloading) {
    return;
  }
  self.nextloading = " loading";
  if (!self.nomore) {
    self.pid++;
    self.update();
  }
  self.setPost(self.pid);
}

setPost(pid) {
  this.pid = pid;
  this.update();
  this.loading = true;
  fetch(`/blog/switchpost/${pid-1}`)
    .then((resp) => resp.text())
    .then(
      (body) => {
        if (body === "false") {
          self.nomore = true;
          self.update()
        }
        else {
          var postcontent = JSON.parse(body);
          if (postcontent.length == 0) {
            self.loading = false;
            self.prevloading = "";
            self.nextloading = "";
            self.author = "";
            self.content = "";
            self.title = "No more posts!";
            self.nomore = true;
            self.update();
            return;
          }
          self.author = postcontent[0].doc.author[0];
          self.content = postcontent[0].doc.content[0];
          self.title = postcontent[0].doc.title[0];
          self.update();
        }

        self.loading = false;
        self.prevloading = "";
        self.nextloading = "";
        self.update();
      });
}

this.setPost(this.opts.pid);

</script>
</post>
