<social>
  <div class="social-wrapper btn-group">
      <div style={{"margin-right" : "1px"}}>
        <div onmouseover={test} data-is="raw" ref="twitter" content={this.tweetHtml}>
        </div>
      </div>
      <div style={{"margin-left" : "1px"}}>
        <div onmouseover={test} data-is="raw" ref="facebook" content={this.fbHtml}>
        </div>
      </div>
  </div>
<script>

import './raw.tag';
var self = this;

self.tweetHtml = "";
self.fbHtml = "";
self.preview = "https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Flocalhost%2Fblog%2F&ref_src=twsrc%5Etfw&text=My%20first%20Elixir%20program&tw_p=tweetbutton&url=https%3A%2F%2Fprimop.me%2Fblog%2F%23!posts%2F19045cf7&via=weskerfoot";

self._id = self.opts.postid;
self.title = self.opts.title;
self.old_id = false;

updateButton(_id, title) {
  console.log("trying to update buttons");
  document.title = title;
  if (_id == undefined) {
    _id = self.opts.postid;
  }
  self.tweetHtml = '<a style="display:none;" data-size="small" class="twitter-share-button btn" data-text="'+title+'" data-via="weskerfoot" data-show-count="false" data-url="https://primop.me/blog/#!posts/'+_id+'" ref="tweet">Tweet '+_id+'</a>';
  self.fbHtml = '<div class="fb-share-button" data-href="https://primop.me/blog/#!posts/'+_id+'" data-layout="button_count"></div>';
  self._id = _id;
  self.update();
}

loadButtons() {
  console.log("trying to load buttons");
  if (window.twttr.widgets !== undefined) {
    console.log("twitter was defined");
    window.twttr.widgets.load(self.refs.twitter.root);
  }

  if (FB !== undefined && FB.XFBML !== undefined) {
    FB.XFBML.parse(self.refs.facebook.root);
  }
  self.old_id = self._id;
}

self.on("updated", self.loadButtons);

self.on("mount", () => { self.updateButton(self._id, self.parent.title); });

test(ev) {
  ev.preventDefault()
}

self.one("updated", () => {
  self.updateButton(self._id, self.title);
  self.update({"old_id" : self._id});
  self.one("updated", () => {
    self.shouldUpdate = (() => {
      return self.old_id != self.parent._id;
    });
  });
});

</script>
</social>
