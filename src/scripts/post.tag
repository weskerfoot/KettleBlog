<post>
  <div class="postnav centered">
    <button class={"btn btn-primary " + (this.pid <= 1 ? "disabled" : " ") + this.prevloading} onclick={this.prev}>Last One</button>
    <button class={"btn btn-primary " + (this.nomore ? "disabled" : " ") + this.nextloading} onclick={this.next}>Next One</button>
  </div>

  <h4 class="post centered" if={nomore}>
    No More Posts!
  </h4>

  <div if={!(this.loading || this.nomore)} class="post centered">
    <h4>{ opts.title }</h4>
    <h5>Posted by { opts.creator }</h5>
    <p class="post-content centered text-break">
      { this.content }
    </p>

    <div class="divider"></div>
    <comments pid={this.pid}>
    </comments>
  </div>

<script>

import 'whatwg-fetch';
import route from 'riot-route'
import { default as R } from 'ramda';

var self = this;

this.loading = false;
this.prevloading = "";
this.nextloading = "";

this.nomore = false
this.pid = 1;
this.content = "";

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
    self.setPost(self.pid);
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
    self.setPost(self.pid);
    self.update();
  }
}

setPost(pid) {
  this.update();
  this.loading = true;
  fetch(`/blog/switchpost/${pid}`)
    .then((resp) => resp.text())
    .then(
      (body) => {
        if (body === "false") {
          self.nomore = true;
          route("/");
          self.update()
        }
        else {
          self.content = body;
          route(`/${pid}`);
        }

        self.loading = false;
        self.prevloading = "";
        self.nextloading = "";
        self.update();
      });
}

this.on("mount", () => { this.setPost(self.pid) });

</script>
</post>
