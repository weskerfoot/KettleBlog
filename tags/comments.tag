<comments>
  <div if={loading}
       class="loading comments-loader">
  </div>
  <comment
    if={!loading}
    each={comments}
    data={this}
  />
  <textarea onfocus={clearplaceholder}
            onblur={checkplaceholder}
            oninput={echo}
            __disabled={disabled}
            class={"form-input comments centered " + maxed}
            name="textarea"
            rows="10"
            cols="50"
            maxlength={maxlength}
            >
      { placeholder }
  </textarea>
  <div if={warn} class="toast toast-danger maxwarn centered">
    <button
      onclick={closewarning}
      class="btn btn-clear float-right">
    </button>
    You've reached the max comment size
  </div>

comments = [];
maxlength = 700;

placeholder = "Comment here!";
focused = false;
maxed = false;
warn = false;
disabled = "";
loading = true;

clearplaceholder() {
  if (!this.focused) {
    this.update({
      "placeholder" : "",
      "focused"     : true
      })
  }
}

checkplaceholder() {
  if (this.textarea.value.trim().length == 0) {
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
  if (this.textarea.value.length >= maxlength) {
    this.update({
      "maxed" : "maxinput",
      "warn"  : true
    });
  }
  else {
    this.update({
      "maxed" : false,
      "warn"  : false
    });
    window.setTimeout(this.closewarning, 5000);
  }
}

var self = this;

getComments(pid) {
  fetch("/comments/"+pid)
    .then(
      function(resp) {
        return resp.text();
      })
    .then(
      function(body) {
        self.update(
          {
            "comments" : JSON.parse(body),
            "loading"  : false
          });
      });
}

this.on("mount",
  function() {
    this.getComments(self.opts.pid);
  });

<script>
</script>
</comments>
