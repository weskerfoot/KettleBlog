<comments>
  <div if={loading} class="loading comments-loader"></div>
  <comment if={!loading} each={R.sortBy(R.prop("time"), R.values(this.comments))} data="{this}"></comment>
  <textarea onfocus={clearplaceholder}
            onblur={checkplaceholder}
            oninput={echo}
            __disabled={disabled}
            class={"form-input comments centered " + this.maxed}
            ref="textarea"
            rows="10"
            cols="50"
            maxlength={this.maxlength}>
      { placeholder }
  </textarea>
  <button onclick={submit} class="btn comment-submit">
    Submit Comment
  </button>
  <div if={this.warn} class="toast toast-danger maxwarn centered">
    <button
      onclick={this.closewarning}
      class="btn btn-clear float-right">
    </button>
    Your comment is too long!
  </div>
<script>
import 'whatwg-fetch';
import { default as R } from 'ramda';
this.R = R;

this.comments = [];
this.maxlength = 700;

this.placeholder = "Comment on this post";
this.focused = false;
this.maxed = "";
this.warn = false;
this.disabled = "";
this.loading = true;

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
      "placeholder" : "Comment here!",
      "focused"     : false
    });
  }
}

closewarning() {
  this.update({"warn" : false});
}

echo(ev) {
  if (this.refs.textarea.value.length >= this.maxlength) {
    this.update({
      "maxed" : "maxinput",
      "warn"  : true
    });
  }
  else {
    this.update({
      "maxed" : "",
      "warn"  : false
    });
    window.setTimeout(this.closewarning, 15000);
  }
}

var self = this;

getComments(pid) {
  fetch("/blog/comments/"+pid)
    .then(
      function(resp) {
        return resp.text();
      })
    .then(
      function(body) {
        var parsed =JSON.parse(body);
        parsed.map(function(comment) { self.comments[comment["id"]] = comment; } );
        self.update();
        self.update(
          {
            "loading"  : false
          });
      });
}

submit() {
  var id = Math.random();
  this.comments[id] = {
      "author" : "name",
      "text" : this.refs.textarea.value,
      "delete" : (() => { delete self.comments[id]; self.update(); })
    };
  this.update();
}

this.on("mount",
  function() {
    this.getComments(self.opts.pid);
  });
</script>
</comments>
