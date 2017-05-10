<post>
  <div class="postnav centered">
    <button class={"btn btn-primary " + (this.pid <= 1 ? "disabled" : " ") + this.prevloading}
            onclick={this.prev}
    >
      Last One
    </button>
    <button class={"btn btn-primary " + (this.nomore ? "disabled" : " ") + this.nextloading}
            onclick={this.next}
    >
      Next One
    </button>
  </div>

  <h4 class="post centered" if={this.nomore}>
    No More Posts!
  </h4>
  <div if={!(this.loading || this.nomore)}
       class="post centered"
  >
    <h4>{ this.title }</h4>
    <h5>Posted by { this.author }</h5>
    <p class="post-content centered text-break">
      { this.content }
    </p>
    <div class="divider"></div>
  </div>

<script>

import 'whatwg-fetch';
import route from 'riot-route'
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
    route(`/post/${self.pid}`);
    self.update();
  }
}

next(ev) {
  ev.preventDefault();
  if (self.nextloading || self.prevloading) {
    return;
  }
  self.nextloading = " loading";
  if (!self.nomore) {
    self.pid++;
    route(`/post/${self.pid}`);
    self.update();
  }
}

setPost(pid) {
  console.log(pid);
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
          console.log(postcontent);
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
this.on("mount", () => {
  route("/", () => { route("/post/1") });
  route("/post/*", this.setPost);
  console.log("starting the router");
  route.start(true);
});

</script>
</post>
