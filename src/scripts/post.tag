<post>
  <div class="posts-box post centered">
    <div class="text-break animated fadeIn">
      <loading if={this.loading}></loading>
      <div
        class={this.loading ? "invisible" : ""}
      >
        <h4 class="post-title">{ this.title }</h4>
        <p class="post-content centered text-break">
          <raw content="{ this.converter.makeHtml(this.content) }"></raw>
        </p>
        <div class="divider"></div>
      </div>
    </div>
    <div
      data-is="postcontrols"
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

self._id = "";
self.author = "";
self.title = "";
self.content = "";
self.prevloading = "";
self.nextloading = "";
self.transition = "";
self.nomore = false;
self.content = "";
self.swipe = false;
self.loading = self.opts.state.loaded;

prev(ev) {
  ev.preventDefault();
  if (self.prevloading || self.nextloading) {
    return;
  }
  self.prevloading = " loader-branded";
  self.update({"swipe" : !self.swipe});
  self.prevPost(self._id, "fadeIn");
}

next(ev) {
  ev.preventDefault();
  if (self.nextloading || self.prevloading) {
    return;
  }
  self.nextloading = " loader-branded";
  if (!self.nomore) {
    self.update();
  }
  self.update({"swipe" : !self.swipe});
  self.nextPost(self._id, "fadeIn");
}

updatePost(body, transition) {
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
    if (!postcontent) {
      self.prevloading = "";
      self.nextloading = "";
      self.nomore = true;
      self.swipe = !self.swipe;
      self.transition = "";
      self.loading = false;
      self.update();
      return;
    }
    self._id = postcontent._id.slice(-8);
    self.author = postcontent.author;
    self.content = postcontent.content;
    self.title = postcontent.title;
    self.transition = transition;
    self.swipe = !self.swipe;
    self.nomore = false;
    self.loading = false;
    self.update();
  }

  self.prevloading = "";
  self.nextloading = "";
  self.route(`/posts/${self._id}`);
  self.update();
}

nextPost(_id, transition) {
  fetch(`/blog/switchpost/${_id.slice(-8)}`)
  .then((resp) => resp.text())
  .then((resp) => { self.updatePost(resp, transition) })
}

prevPost(_id, transition) {
  fetch(`/blog/prevpost/${_id.slice(-8)}`)
  .then((resp) => resp.text())
  .then((resp) => { self.updatePost(resp, transition) })
}

getPost(_id, transition) {
  var url;
  if (_id !== undefined && _id) {
    url = `/blog/getpost/${_id.slice(-8)}`;
  }
  else {
    url = "/blog/switchpost/";
  }
  fetch(url)
  .then((resp) => resp.text())
  .then((resp) => {self.updatePost(resp, transition) })
}

this.getPost(this.opts.state._id, "fadeIn");

</script>
</post>
