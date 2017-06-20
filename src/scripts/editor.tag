<editor>
  <div class="centered container">
    <div class="columns">
      <div class="column col-6">
        <div>
          <span>
            {this.currentPost().title} by {this.currentPost().author}
          </span>
        </div>
        <button
          class="btn btn-primary"
          onclick={goLeft}
        >
          Prev
        </button>
        <button
          class="btn btn-primary"
          onclick={goRight}
        >
          Next
        </button>
        <p>
          <span>title</span><input ref="title">
          <span>author</span><input ref="author"></input>
          <span>Editing post {this.currentPost()._id}</span>
        <p>
          <button
            class="btn btn-primary"
            onclick={deletePost(this.currentPost()._id)}
          >
            Delete Post
          </button>
          <button
            class="btn btn-primary"
            onclick={newPost}
          >
            New Post
          </button>
        </p>
          <textarea onfocus={clearplaceholder}
                    onblur={checkplaceholder}
                    oninput={echo}
                    rows="10"
                    cols="10"
                    __disabled={""}
                    class="editor form-input centered"
                    ref="textarea">
            { placeholder }
          </textarea>
          <button onclick={submit}
                  class="btn post-submit centered">
            Submit Post
          </button>
        </p>
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
import Z from './zipper.js';

this.R = R;
this.querystring = querystring;

this.converter = new showdown.Converter();
this.converted = "<h3>Nothing here yet</h3>";

this.placeholderText = "Write a post!"
this.placeholder = this.placeholderText;
this.focused = false;

this.currentPosts = Z.empty;

var self = this;

currentPost() {
  var defaultPost = {
    "_id" : "",
    "title" : "",
    "author" : ""
  };

  return Z.focus(self.currentPosts, defaultPost);
}

goRight() {
  self.update({"currentPosts" : Z.goRight(self.currentPosts)});
  self.one("updated", self.loadPost(this.currentPost()._id));
}

goLeft() {
  self.update({"currentPosts" : Z.goLeft(self.currentPosts)});
  self.one("updated", self.loadPost(this.currentPost()._id));
}

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
                      this.refs.textarea.value.trim())
    });
}

newPost() {
  this.refs.title.value = "";
  this.refs.author.value = "";
  this.refs.textarea.value = "";
  this.echo();
  this.update();
}

submit() {
  var post = {
      "title" : this.refs.title.value,
      "author" : this.refs.author.value,
      "content" : this.refs.textarea.value,
      "csrf_token" : this.opts.csrf_token
  };

  if (this.currentPost()._id) {
    post["_id"] = this.currentPost()._id;
  }

  var postQuery = self.querystring.stringify(post);

  var headers = {
    "headers" : {
      "Content-Type" : "application/x-www-form-urlencoded",
      "X-CSRFToken" : this.opts.csrf_token
    }
  };

  axios.post("/blog/insert/", postQuery, headers)
  .then(function(resp) {
    /* Refresh the current list of posts */
    self.listPosts();
    console.log(Z.toJS(self.currentPosts));
  })
  .catch(function(err) {
    console.log(err);
  })
}

loadPost(_id) {
  return function() {
    axios.get(`/blog/getpost/${self.currentPost()._id}`)
    .then(function(resp) {

      self.refs.textarea.value = resp.data.content;
      self.refs.title.value = resp.data.title;
      self.refs.author.value = resp.data.author;
      self.focused = true;

      self.update();
      self.echo();
    })
    .catch(function(err) {
      console.log(err);
    })
  };
}

deletePost(_id) {
  return function() {
    axios.get(`/blog/deletepost/${self.currentPost()._id}`)
      .then(function(resp) {
        self.newPost();
        self.listPosts();
        console.log(Z.toJS(self.currentPosts));
    })
    .catch(function(err) {
      console.log(err);
    })
  };
}

listPosts() {
  axios.get("/blog/allposts")
  .then(function(resp) {
    self.update(
      {
        "currentPosts" : Z.extend(Z.empty, resp.data)
      }
    );
  })
  .catch(function(err) {
    console.log(err);
  })
}

self.listPosts();

</script>
</editor>
