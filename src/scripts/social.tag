<social>
  <raw ref="button" content={this.tweetHtml}>
  </raw>
<script>

import './raw.tag';
import { default as _ } from 'lodash';
import { default as jquery } from 'jquery';
var self = this;

self.tweetHtml = "";

self._id = "";

updateButton(_id) {
  if (_id == undefined) {
    _id = self.opts.postid;
  }
  if (_id != self._id) {

    self.tweetHtml = `<a style="display:none;" class="twitter-share-button" data-show-count="false" href="https://primop.me/${_id}" ref="tweet">Tweet ${_id}</a>`;
    self._id = _id;
    self.update();
  }
}

window.twttr.ready((twttr) => {
  console.log("initial load");
  self.updateButton(self.opts.postid);
});

self.on("updated", () => {
  if (window.twttr.widgets !== undefined) {

    window.twttr.widgets.load();
  }
});

</script>
</social>
