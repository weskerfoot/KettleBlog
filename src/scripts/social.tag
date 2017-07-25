<social>
  <raw ref="button" content={this.tweetHtml}>
  </raw>
<script>

import './raw.tag';
var self = this;

self.tweetHtml = "";

self._id = "";

updateButton(_id, title) {
  if (_id == undefined) {
    _id = self.opts.postid;
  }
  if (_id != self._id) {

    self.tweetHtml = `<a style="display:none;" class="twitter-share-button" data-text="${title} by @weskerfoot" data-show-count="false" data-url="https://primop.me/${_id}" ref="tweet">Tweet ${_id}</a>`;
    self._id = _id;
    self.update();
  }
}

self.on("updated", () => {
  if (window.twttr.widgets !== undefined) {

    window.twttr.widgets.load();
  }
});

</script>
</social>
