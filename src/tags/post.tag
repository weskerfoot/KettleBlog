<post>
  <div class="postnav centered">
    <button class={"btn btn-primary " + (this.pid <= 1 ? "disabled" : " ") + this.prevloading} onclick={prev}>Previous Post</button>
    <button class={"btn btn-primary " + (this.nomore ? "disabled" : " ") + this.nextloading} onclick={next}>Next Post</button>
  </div>

  <h4 class="post centered" if={nomore}>
    No More Posts!
  </h4>

  <div if={!(loading || nomore)} class="post centered">
    <h4>{ opts.title }</h4>
    <h5>By { opts.creator }</h5>
    <p class="post-content centered text-break">{ content }</p>

    <div class="divider"></div>
    <comments pid={pid}>
    </comments>
  </div>

<script>
var self = this;

this.loading = false;
this.prevloading = "";
this.nextloading = "";

this.nomore = false
this.pid = 1;
content = "";

prev() {
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

next() {
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
  self.update();
  self.loading = true;
  fetch("/switchpost/"+pid)
    .then(
      function(resp) {
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
