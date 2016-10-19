riot.tag2('comments', '<textarea class="form-input comments centered" name="textarea" rows="10" cols="50"> Comment here! </textarea>', '', '', function(opts) {
});

riot.tag2('post', '<div class="post centered"> <h4>{opts.title}</h4> <h5>By {opts.creator}</h5> <p class="post-content centered text-break">{content}</p> <comments> </comments> <button onclick="{prev}">Previous Post</button> <button onclick="{next}">Next Post</button> </div>', '', '', function(opts) {
var self = this;
this.pid = 1;
content = "";

this.prev = function() {
  if (self.pid > 0) {
    self.pid--;
    self.setPost(self.pid);
    self.update();
  }
}.bind(this)

this.next = function() {
  self.pid++;
  self.setPost(self.pid);
  self.update();
}.bind(this)

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

});

riot.tag2('posts', '<yield></yield>', '', '', function(opts) {
});
