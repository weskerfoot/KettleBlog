<social>
  <div class="social-wrapper">
      <div class="btn-group">
        <raw ref="twitter-button" content={this.tweetHtml}>
        </raw>
        <raw ref="facebook-button" content={this.fbHtml}>
        </raw>
      </div>
  </div>
<script>

import './raw.tag';
var self = this;

self.tweetHtml = "";

self._id = "";
self.old_id = self._id;

updateButton(_id, title) {
  if (_id == undefined) {
    _id = self.opts.postid;
  }
  if (_id != self._id) {

    self.tweetHtml = `<a style="display:none;" data-size="small" class="twitter-share-button btn" data-text="${title}" data-via="weskerfoot" data-show-count="false" data-url="https://primop.me/blog/#!posts/${_id}" ref="tweet">Tweet ${_id}</a>`;
    self.fbHtml = `<div class="fb-share-button" data-href="https://primop.me/blog/#!posts/${_id}" data-layout="button_count"></div>`;
    self._id = _id;
    self.update();
  }
}

self.on("updated", () => {
  if (window.twttr.widgets !== undefined) {
    window.twttr.widgets.load();
  }

  if (FB.XFBML.parse !== undefined) {
    FB.XFBML.parse();
  }
  self.old_id = self._id;
});

shouldUpdate() {
  return self.old_id != self.parent._id
}

</script>
</social>
