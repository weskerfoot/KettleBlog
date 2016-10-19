<post>
  <div class="post centered">
    <h4>{ opts.title }</h4>
    <h5>By { opts.creator }</h5>
    <p class="post-content centered text-break">{ content }</p>
    <comments>
    </comments>
  <button onclick={prev}>Previous Post</button>
  <button onclick={next}>Next Post</button>
  </div>

<script>
var self = this;
this.pid = 1;
content = "";

prev() {
  if (self.pid > 0) {
    self.pid--;
    self.setPost(self.pid);
    self.update();
  }
}

next() {
  self.pid++;
  self.setPost(self.pid);
  self.update();
}


this.setPost = function(pid) {
  fetch("/switchpost/"+pid)
    .then(
      function(resp) {
      return resp.text();
      })
    .then(
      function(body) {
        self.content = R.join(" ")(R.repeat(body, 20));
        self.update();
      });
}

this.on("mount", function() { this.setPost(self.pid) });

</script>
</post>
