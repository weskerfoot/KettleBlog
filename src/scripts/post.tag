<post>
  <div class="posts-box post centered">
    <div class="text-break animated fadeIn">
      <loading if={this.loading}></loading>
      <div
        if={this.swipe && !this.loading}
        class={`animated ${this.transition}`}
      >
        <h4>{ this.title }</h4>
        <h5>Posted by { this.author }</h5>
        <p class="post-content centered text-break">
          <raw content="{ this.converter.makeHtml(this.content) }"></raw>
        </p>
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

import './raw.tag';
import 'whatwg-fetch';
import { default as R } from 'ramda';
import { default as showdown } from 'showdown';
import './postcontrols.tag';
import route from 'riot-route';

this.converter = new showdown.Converter();

var self = this;

self.route = route;

self.author = "";
self.title = "";
self.content = "";
self.prevloading = "";
self.nextloading = "";
self.transition = "";
self.nomore = false;
self.content = "";
self.swipe = false;
self.loading = !self.opts.state.loaded;

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
  self.update({"swipe" : !self.swipe});
  self.setPost(self.opts.state.pid, "fadeIn");
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
  self.update({"swipe" : !self.swipe});
  self.setPost(self.opts.state.pid, "fadeIn");
}

setPost(pid, transition) {
  self.update({"loading" : self.opts.state.loaded});
  fetch(`/blog/switchpost/${pid-1}`)
    .then((resp) => resp.text())
    .then(
      (body) => {
        if (body === "false") {
          self.nomore = true;
          self.prevloading = "";
          self.nextloading = "";
          self.loading = false;
          self.update()
          return;
        }
        else {
          var postcontent = JSON.parse(body);
          if (postcontent.length == 0) {
            self.prevloading = "";
            self.nextloading = "";
            self.nomore = true;
            self.swipe = !self.swipe;
            self.transition = "";
            self.opts.state.pid--;
            self.loading = false;
            self.update();
            return;
          }
          self.opts.state.pid = pid;
          self.author = postcontent[0].doc.author[0];
          self.content = postcontent[0].doc.content[0];
          self.title = postcontent[0].doc.title[0];
          self.transition = transition;
          self.swipe = !self.swipe;
          self.nomore = false;
          self.loading = false;
          self.update();
        }

        self.prevloading = "";
        self.nextloading = "";
        self.route(`/posts/${self.opts.state.pid}`);
        self.update();
      });
}

this.setPost(this.opts.state.pid);

</script>
</post>
