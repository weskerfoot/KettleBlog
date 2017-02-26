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
    <h5>By { opts.creator }</h5>
    <p class="post-content centered text-break">{ this.content }</p>

    <div class="divider"></div>
    <comments pid={pid}>
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
  console.log("next event fired");
  ev.preventDefault();
  if (self.nextloading || self.prevloading) {
    return;
  }
  self.nextloading = " loading";
  console.log(self.pid);
  console.log(self.nomore);
  if (!self.nomore) {
    self.pid++;
    self.setPost(self.pid);
    self.update();
  }
}

this.setPost = function(pid) {
  console.log("trying to change the post");
  console.log(fetch);
  this.update();
  console.log("updated");
  this.loading = true;
  fetch("/blog/switchpost/"+pid)
    .then(
      function(resp) {
        console.log("got a response");
        return resp.text();
      })
    .then(
      function(body) {
        if (body === "false") {
          self.nomore = true;
          route("/");
          self.update()
        }
        else {
          self.content = R.join(" ")(R.repeat(body, 20));
          route("/"+pid);
        }

        self.loading = false;
        self.prevloading = "";
        self.nextloading = "";
        self.update();
      });
}

this.on("mount", function() { this.setPost(self.pid) });

</script>
</post>
