<editor>
  <loading if={this.loading}></loading>
  <div class="centered container">
    <div class="columns">
      <div class="column col-6">
        <div>
          <span>
            {!this.isNewPost ? this.currentPost().title : "No Title"} by {!this.isNewPost ? this.currentPost().author : "No Author"}
          </span>
        </div>
        <div class="centered container">
          <div class="columns">
            <div class="column col-6">
              <button
                style={{"float" : "right"}}
                class="btn btn-primary branded"
                onclick={goLeft}
              >
                Prev
              </button>
            </div>
            <div class="column col-6">
              <button
               style={{"float" : "left"}}
               class="btn btn-primary branded"
               onclick={goRight}
              >
               Next
              </button>
            </div>
          </div>
        </div>
        <p>
          <span>title</span><input ref="title">
          <span>author</span><input ref="author"></input>
          <span>tags</span><input ref="tags"></input>
          <span>Editing post {!this.isNewPost ? this._id : ""}</span>
        <p>
          <button
            class="btn btn-primary branded"
            onclick={deletePost(!this.isNewPost ? this._id : false)}
          >
            Delete Post
          </button>
          <button
            class="btn btn-primary branded"
            onclick={newPost}
          >
            New Post
          </button>
        </p>
          <textarea onfocus={clearplaceholder}
                    onblur={checkplaceholder}
                    oninput={echo}
                    rows="10"
                    cols="30"
                    __disabled={""}
                    class="editor form-input centered"
                    ref="textarea">
            { placeholder }
          </textarea>
          <button onclick={submit}
                  class="btn post-submit centered branded">
            Submit Post
          </button>
        </p>
      </div>

      <div class="column col-6">
        <raw content="{this.converter.makeHtml(this.converted)}"></raw>
      </div>
    </div>
  </div>
<script type="es6">
import './loading.tag';
import './raw.tag';
import { default as showdown } from 'showdown';
import querystring from 'querystring';
import Z from './zipper.js';

this.loading = false;
this.querystring = querystring;

this.converted = "<h3>Nothing here </h3>";
this.converter = new showdown.Converter();

this.placeholderText = "Write a post!";
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

self.currentPost = () => {
  return Z.focus(self.currentPosts, self.defaultPost);
}

self.goRight = () => {
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

self.goLeft = () => {
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

self.clearplaceholder = () => {
  if (!this.focused) {
    this.update({
      "placeholder" : "",
      "focused"     : true
      })
  }
}

self.checkplaceholder = () => {
  if (this.refs.textarea.value.trim().length == 0) {
    this.update({
      "placeholder" : this.placeholderText,
      "focused"     : false
    });
  }
}

self.echo = (ev) => {
  this.update({
      "converted" : this.refs.textarea.value.trim()
    });
}

self.newPost = () => {
  this.refs.title.value = "";
  this.refs.author.value = "";
  this.refs.textarea.value = "";

  /* must overwrite the current _id */
  /* otherwise it overwrites the current post */
  this._id = false;

  this.isNewPost = true;
  this.echo();
  this.update();
}

self.submit = () => {
  self.update({"loading" : true});
  var post = {
      "title" : this.refs.title.value,
      "author" : this.refs.author.value,
      "content" : this.refs.textarea.value,
      "tags" : this.refs.tags.value,
      "csrf_token" : this.opts.csrf_token
  };

  if (this._id) {
  /* If the post has an _id then it exists and we are editing it */
    post["_id"] = this._id;
  }

  var postQuery = self.querystring.stringify(post);

  var headers = {
    "headers" : {
      "Content-Type" : "application/x-www-form-urlencoded",
      "X-CSRFToken" : this.opts.csrf_token
    }
  };

  axios.post(`/blog/insert/programming`, postQuery, headers)
  .then(function(resp) {
    /* Refresh the current list of posts */
    /* This post has been added, so insert it in the current position */

    console.log("the post was successfully added");

    self.update({"loading" : false});
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

self.loadPost = (_id) => {
  return function() {
    console.log("started loading");
    if (!_id) {
      console.log("couldn't load the post");
      return false;
    }
    self.update({"loading" : true});
    axios.get(`/blog/getrawpost/${_id.slice(-8)}`)
    .then(function(resp) {
      self.update({"loading" : false});
      self.refs.textarea.value = resp.data.content;
      self.refs.title.value = resp.data.title;
      self.refs.author.value = resp.data.author;
      self.refs.tags.value = resp.data.categories;
      self._id = resp.data._id;
      self.focused = true;
      self.isNewPost = false;
      console.log("loaded")

      self.converted = resp.data.content
      self.update();
    })
    .catch(function(err) {
      console.log(err);
    })
  };
}

self.deletePost = (_id) => {
  return function() {
    if (!_id) {
      return false;
    }
    self.update({"loading" : true});
    axios.get(`/blog/deletepost/${self._id}`)
      .then(function(resp) {
        console.log(resp);
        self.listPosts();
        self.update({"loading" : false});
    })
    .catch(function(err) {
      console.log(err);
    })
  };
}

self.listPosts = () => {
  console.log("trying to get a list of all posts");
  axios.get("/blog/allposts")
  .then(function(resp) {
    var postsList = Z.extend(Z.empty, resp.data);
    var currentPost = Z.focus(postsList, self.defaultPost);

    console.log(resp);

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

self.on("mount", self.listPosts);

</script>
</editor>
