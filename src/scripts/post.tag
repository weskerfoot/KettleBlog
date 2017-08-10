<post>
  <div class="posts-box post centered">
    <div
      data-is="postcontrols"
      prevloading={prevloading}
      prev={prev}
      atstart={start}
      atend={end}
      nextloading={nextloading}
      next={next}
    >
    </div>
    <loading if={loading && opts.state.loaded}></loading>
    <div class="text-break">
      <div class={"animated " + (loading ? "invisible" : "fadeIn")}>

        <social
          show={!loading}
          ref="social"
          postid={opts.state._id}
        >
        </social>
        <p class="post-content centered text-break">
          <raw
            content="{ converter.makeHtml(content) }"
          >
          </raw>
        </p>
        <div class="divider"></div>
      </div>
    </div>
    <div
      data-is="postcontrols"
      prevloading={prevloading}
      prev={prev}
      atstart={start}
      atend={end}
      nextloading={nextloading}
      next={next}
    >
    </div>
  </div>
<script>
import './raw.tag';
import './social.tag';
import { default as showdown } from 'showdown';

import './postcontrols.tag';
import route from 'riot-route';

this.converter = new showdown.Converter();

var self = this;

self.route = route;

self.category = "programming";
self._id = "";
self.author = "";
self.title = "";
self.content = "";
self.prevloading = "";
self.nextloading = "";
self.content = "";
self.swipe = false;

self.on("mount", () => {
  self.loading = self.opts.state.loaded;
});

RiotControl.on("filtercategory",
  (ev) => {
    let category = ev.category.toLowerCase();
    console.log(category);
  });

self.start = false;
self.end = false;

const hashLength = 8;

prev(ev) {
  ev.preventDefault();
  self.end = false;
  if (self.prevloading || self.nextloading) {
    return;
  }
  self.prevloading = " loader-branded";
  self.prevPost(self._id);
}

next(ev) {
  ev.preventDefault();
  self.start = false;
  if (self.nextloading || self.prevloading) {
    return;
  }
  self.nextloading = " loader-branded";
  self.nextPost(self._id);
}

toTop() {
  window.scroll({
    top: 0,
    left: 0,
    behavior: 'smooth'
  });
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
  self.prevloading = "";
  self.nextloading = "";
  self.route("/posts/"+self._id);

  RiotControl.trigger("postswitch", {"title" : self.title});

  self.parent.update();

  self.refs.social.updateButton(self._id, self.title);

  self.one("updated", self.toTop);
  self.update();
}

nextPost(_id) {
  self.update({"loading" : true});
  self.opts.cached("/blog/switchpost/"+_id.slice(-hashLength)+"/"+self.category)
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
  self.update({"loading" : true});
  self.opts.cached("/blog/prevpost/"+_id.slice(-hashLength)+"/"+self.category)
  .then((resp) => resp.text())
  .then((resp) => {
    self.updatePost(JSON.parse(resp))
  })
}

getPost(_id) {
  self.update({"loading" : true});
  var url;
  if (_id !== undefined && _id) {
    url = "/blog/getpost/"+_id.slice(-hashLength)+"/"+self.category;
  }
  else {
    url = "/blog/switchpost/";
  }
  self.opts.cached(url)
  .then((resp) => resp.text())
  .then((resp) => { self.updatePost(JSON.parse(resp)) })
}

self.on("mount", () => {
  self.getPost(self.opts.state._id);
});

</script>
</post>
