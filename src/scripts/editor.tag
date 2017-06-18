<editor>
  <div class="centered container">
    <div class="columns">
      <div class="column col-6">
        <span>title</span><input ref="title">
        <span>author</span><input ref="author"></input>
        <textarea onfocus={clearplaceholder}
                  onblur={checkplaceholder}
                  oninput={echo}
                  rows="30"
                  cols="10"
                  __disabled={""}
                  class="editor form-input centered"
                  ref="textarea"
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
import querystring from 'querystring';
this.R = R;
this.querystring = querystring;

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
  this.update({
      "converted" : this.converter.makeHtml(
                      this.refs.textarea.value.trim()
                    )
    });
}

var self = this; /* Why do we need this??????????? */

submit() {
  var post = self.querystring.stringify({
      "title" : this.refs.title.value,
      "author" : this.refs.author.value,
      "content" : this.refs.textarea.value,
      "csrf_token" : this.opts.csrf_token
  });

  var headers = {
    "headers" : {
      "Content-Type" : "application/x-www-form-urlencoded",
      "X-CSRFToken" : this.opts.csrf_token
    }
  };

  axios.post("/blog/insert/", post, headers)
  .then(function(resp) {
    console.log(resp);
  })
  .catch(function(err) {
    console.log(err);
  })

  console.log("Submitting the post");
  console.log(post);
}

listPosts() {
  axios.get("/blog/allposts")
  .then(function(resp) {
    console.log(resp);
  })
  .catch(function(err) {
    console.log(err);
  })
}

self.listPosts();

</script>
</editor>
