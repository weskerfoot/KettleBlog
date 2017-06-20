<editor>
  <div class="centered container">
    <div class="columns">
      <div class="column col-6">
        <div>
          <span>
            {!this.isNewPost ? this.currentPost().title : "No Title"} by {!this.isNewPost ? this.currentPost().author : "No Author"}
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
          <span>Editing post {!this.isNewPost ? this._id : ""}</span>
        <p>
          <button
            class="btn btn-primary"
            onclick={deletePost(!this.isNewPost ? this._id : false)}
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

this._id = false;

this.isNewPost = false;

this.defaultPost = {
  "_id" : "",
  "title" : "",
  "author" : ""
};


var self = this;


currentPost() {
  return Z.focus(self.currentPosts, self.defaultPost);
}

goRight() {
  console.log("trying to update with the previous post");
  console.log(this.currentPost()._id);
  self.update(
    {
      "currentPosts" : Z.goRight(self.currentPosts),
      "isNewPost" : false
    }
  );
  self.one("updated", self.loadPost(this.currentPost()._id));
}

goLeft() {
  console.log("trying to update with the next post");
  console.log(this.currentPost()._id);
  self.update(
    {
      "currentPosts" : Z.goLeft(self.currentPosts),
      "isNewPost" : false
    }
  );
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
  this._id = false;
  /* must overwrite the current _id */
  /* otherwise it overwrites the current post */
  this.isNewPost = true;
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

  if (this._id) {
    post["_id"] = this._id;
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
    /* self.listPosts(); */

    /* This post has been added, so insert it in the current position */

    console.log("the post was successfully added");

    if (self.isNewPost) {
      /* only happen for new posts */
      post["_id"] = resp.data[0];
      self.update(
        {
          "currentPosts" : Z.insert(post, self.currentPosts),
          "isNewPost" : false,
          "_id" : post["_id"]
        }
      );
    }
  })
  .catch(function(err) {
    console.log(err);
  })
}

loadPost(_id) {
  return function() {
    if (!_id) {
      console.log("couldn't load the post");
      return false;
    }
    axios.get(`/blog/getpost/${_id}`)
    .then(function(resp) {
      self.refs.textarea.value = resp.data.content;
      self.refs.title.value = resp.data.title;
      self.refs.author.value = resp.data.author;
      self.focused = true;
      self.isNewPost = false;

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
    if (!_id) {
      return false;
    }
    axios.get(`/blog/deletepost/${self._id}`)
      .then(function(resp) {
        console.log(resp);
        self.listPosts();
    })
    .catch(function(err) {
      console.log(err);
    })
  };
}

listPosts() {
  axios.get("/blog/allposts")
  .then(function(resp) {
    var postsList = Z.extend(Z.empty, resp.data);
    console.log(`trying to load post with id ${Z.focus(postsList, self.defaultPost)._id}`);
    var currentPost = Z.focus(postsList, self.defaultPost);
    var isNewPost;

    if (currentPost == self.defaultPost) {
      self.newPost();
    }
    else {
      self.one("updated", self.loadPost(currentPost._id));
    }

    self.update(
      {
        "currentPosts" : postsList,
        "_id" : currentPost._id
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
