<post>
  <div class="posts-box post centered">
    <div class="text-break animated fadeIn">
      <div
        if={this.swipe}
        class={`animated ${this.transition}`}
      >
        <div if={this.nomore}>
          <h4>No more posts!</h4>
        </div>

        <div if={!this.nomore}>
          <h4>{ this.title }</h4>
          <h5>Posted by { this.author }</h5>
          <p class="post-content centered text-break">
            { this.content }
          </p>
        </div>
        <div class="divider"></div>
      </div>
    </div>
    <div
      data-is="postcontrols"
      state={this.opts.state}
      prevloading={this.prevloading}
      prev={this.prev}
      nomore={this.nomore}
      nextloading={this.nextloading}
      next={this.next}
    >
    </div>
  </div>
<script>

import 'whatwg-fetch';
import { default as R } from 'ramda';
import './postcontrols.tag';

var self = this;

self.author = "";
self.title = "";
self.content = "";
self.prevloading = "";
self.nextloading = "";
self.transition = "";
self.nomore = false;
self.content = "";
self.swipe = true;

prev(ev) {
  ev.preventDefault();
  if (self.prevloading || self.nextloading) {
    return;
  }
  self.prevloading = " loading";

  if (self.opts.state.pid > 1) {
    self.opts.state.pid--;
    self.update();
  }
  self.update({"swipe" : false});
  self.setPost(self.opts.state.pid, "fadeInLeft");
}

next(ev) {
  ev.preventDefault();
  if (self.nextloading || self.prevloading) {
    return;
  }
  self.nextloading = " loading";
  if (!self.nomore) {
    self.opts.state.pid++;
    self.update();
  }
  self.update({"swipe" : false});
  self.setPost(self.opts.state.pid, "fadeInRight");
}

setPost(pid, transition) {
  this.opts.state.pid = pid;
  fetch(`/blog/switchpost/${this.opts.state.pid-1}`)
    .then((resp) => resp.text())
    .then(
      (body) => {
        if (body === "false") {
          self.nomore = true;
          self.prevloading = "";
          self.nextloading = "";
          self.swipe = true;
          self.transition = transition;
          self.update()
          return;
        }
        else {
          var postcontent = JSON.parse(body);
          if (postcontent.length == 0) {
            self.prevloading = "";
            self.nextloading = "";
            self.nomore = true;
            self.swipe = true;
            self.transition = transition;
            self.update();
            return;
          }
          self.author = postcontent[0].doc.author[0];
          self.content = postcontent[0].doc.content[0];
          self.title = postcontent[0].doc.title[0];
          self.transition = transition;
          self.swipe = true;
          self.nomore = false;
          self.update();
        }

        self.prevloading = "";
        self.nextloading = "";
        self.update();
      });
}

this.setPost(this.opts.state.pid);

</script>
</post>
