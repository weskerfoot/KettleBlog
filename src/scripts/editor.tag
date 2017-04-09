<editor>
  <div class="centered container">
    <div class="columns">
      <div class="column col-6">
        <textarea onfocus={clearplaceholder}
                  onblur={checkplaceholder}
                  oninput={echo}
                  __disabled={""}
                  class="form-input editor centered"
                  ref="textarea"
                  rows="10"
                  cols="50"
                  maxlength={this.maxlength}>
          { placeholder }
        </textarea>
        <button onclick={submit}
                class="btn post-submit centered">
          Submit Post
        </button>
      </div>
      <div class="column col-6">
        <raw content="{this.converted}"></raw>
      </div>
    </div>
  </div>
<script>
import './raw.tag';
import 'whatwg-fetch';
import { default as showdown } from 'showdown';
import { default as R } from 'ramda';
this.R = R;

this.converter = new showdown.Converter();
this.converted = "<h3>Nothing here yet</h3>";

this.placeholderText = "Write a post!"
this.placeholder = this.placeholderText;
this.focused = false;

clearplaceholder() {
  if (!this.focused) {
    this.update({
      "placeholder" : "",
      "focused"     : true
      })
  }
}

checkplaceholder() {
  if (this.refs.textarea.value.trim().length == 0) {
    this.update({
      "placeholder" : this.placeholderText,
      "focused"     : false
    });
  }
}

echo(ev) {
  this.update({"converted" : this.converter.makeHtml(this.refs.textarea.value)});
  console.log("tried updating the raw tag");
}

var self = this;

submit() {
  var post = {
      "author" : "name",
      "text" : this.refs.textarea.value
  };
  console.log("Submitting the post");
  console.log(post);
}
</script>
</editor>
