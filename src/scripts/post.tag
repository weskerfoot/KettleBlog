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
    <loading if={loading}></loading>
    <div class="text-break">
      <div class={"" + (loading ? "invisible" : "fadeIn")}>

        <social
          show={!loading}
          ref="social"
          title={title}
          postid={_id}
        >
        </social>
        <p class="post-content centered text-break">
          <raw
            content="{ content }"
          >
          </raw>
        </p>
        <div class="divider"></div>
      </div>
      <categories></categories>
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
import './postcontrols.tag';
import './categories.tag';
import route from 'riot-route';

var self = this;

const hashLength = 8;

self.route = route;

self.loading = false;
self.category = "programming";

self._id = self.opts.state._id.slice(-hashLength);
self.author = self.opts.state.author;
self.title = self.opts.state.title;
self.content = self.opts.state.initial;
self.prevloading = "";
self.nextloading = "";
self.swipe = false;
self.start = false;
self.end = false;

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

  /* Do not route to this post if we're already on the same route */
  if (window.location.pathname !== `/blog/posts/${self._id}`) {
    self.route(`/posts/${self._id}`);
  }

  self.opts.state._id = self._id;
  self.opts.state.title = self.title;
  self.opts.state.initial = self.content;
  self.opts.state.author = self.author;

  self.swipe = !self.swipe;
  self.loading = false;
  self.prevloading = "";
  self.nextloading = "";
  window.RiotControl.trigger("postswitch", {"title" : self.title});

  self.parent.update();

  self.refs.social.updateButton(self._id, self.title);

  self.one("updated", self.toTop);
  self.update();
}

getPost(_id) {
  self.update({"loading" : true});
  window.cached(`/blog/getpost/${_id.slice(-hashLength)}`)
  .then((resp) => resp.text())
  .then((resp) => {
    self.updatePost(JSON.parse(resp))
  })
}

nextPost(_id) {
  self.update({"loading" : true});
  window.cached(`/blog/switchpost/${_id.slice(-hashLength)}/${self.category}`)
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
  window.cached(`/blog/prevpost/${_id.slice(-hashLength)}/${self.category}`)
  .then((resp) => resp.text())
  .then((resp) => {
    self.updatePost(JSON.parse(resp))
  })
}

self.on("mount", () => {
  self.getPost(self._id);
});

</script>
</post>
