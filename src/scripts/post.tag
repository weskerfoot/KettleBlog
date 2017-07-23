<post>
  <div class="posts-box post centered">
    <div
      data-is="postcontrols"
      prevloading={this.prevloading}
      prev={this.prev}
      atstart={this.start}
      atend={this.end}
      nextloading={this.nextloading}
      next={this.next}
    >
    </div>
    <div class="text-break animated fadeIn">
      <loading if={this.loading}></loading>
      <div
        class={this.loading ? "invisible" : ""}
      >
        <social ref="social" postid={this.opts.state._id}>
        </social>
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
      atstart={this.start}
      atend={this.end}
      nextloading={this.nextloading}
      next={this.next}
    >
    </div>
  </div>
<script>

import './raw.tag';
import './social.tag';
import 'whatwg-fetch';
import { default as R } from 'ramda';
import { default as showdown } from 'showdown';
import { default as jquery } from 'jquery';

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
self.content = "";
self.swipe = false;
self.loading = self.opts.state.loaded;

this.start = false;
this.end = false;

const hashLength = 8;

prev(ev) {
  ev.preventDefault();
  self.end = false;
  if (self.prevloading || self.nextloading) {
    return;
  }
  self.prevloading = " loader-branded";
  self.prevPost(self._id, "fadeIn");
}

next(ev) {
  ev.preventDefault();
  self.start = false;
  if (self.nextloading || self.prevloading) {
    return;
  }
  self.nextloading = " loader-branded";
  self.nextPost(self._id, "fadeIn");
}

toTop() {
  jquery('html, body').stop().animate({
     scrollTop: jquery(".navigate").offset().top-15
  }, 1000);
}

updatePost(postcontent) {
  if (postcontent == "end" || postcontent == "start") {
    self.prevloading = "";
    self.nextloading = "";
    self.swipe = !self.swipe;
    self.loading = false;
    self[postcontent] = true;
    if (postcontent == "start") {
      self.start = true;
    }
    else if (postcontent == "end") {
      self.end = true;
    }
    self.update();
    return;
  }
  self._id = postcontent._id.slice(-hashLength);
  self.author = postcontent.author;
  self.content = postcontent.content;
  self.title = postcontent.title;
  self.swipe = !self.swipe;
  self.loading = false;
  self.one("updated", self.toTop);
  self.prevloading = "";
  self.nextloading = "";
  self.route(`/posts/${self._id}`);

  self.refs.social.updateButton(self._id);

  self.one("updated", self.toTop);
  self.update();
}

nextPost(_id) {
  fetch(`/blog/switchpost/${_id.slice(-hashLength)}`)
  .then((resp) => resp.text())
  .then((resp) => {
    var content = JSON.parse(resp);
    if (content._id.slice(-hashLength) == self._id) {
      /* Reached the end of the iterator */
      self.update({
        end : true,
        loading : false,
        prevloading : "",
        nextloading : ""
      });
      return;
    }
    self.updatePost(content)
  })
}

prevPost(_id) {
  fetch(`/blog/prevpost/${_id.slice(-hashLength)}`)
  .then((resp) => resp.text())
  .then((resp) => {
    var content = JSON.parse(resp);
    self.updatePost(JSON.parse(resp))
  })
}

getPost(_id) {
  var url;
  if (_id !== undefined && _id) {
    url = `/blog/getpost/${_id.slice(-hashLength)}`;
  }
  else {
    url = "/blog/switchpost/";
  }
  fetch(url)
  .then((resp) => resp.text())
  .then((resp) => { self.updatePost(JSON.parse(resp)) })
}

this.getPost(this.opts.state._id, "fadeIn");

</script>
</post>
