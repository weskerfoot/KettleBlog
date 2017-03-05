<comment>
  <div class="comment centered">
    <div class="card">
      <div class="card-header">
        <h4 class="card-title">Comment posted by {author}</h4>
      </div>
      <div class="card-body comment-body">
        { text }
      </div>
      <button if={delete !== undefined} onclick={delete} class="btn">
        Delete this comment
      </button>
    </div>
  </div>
<script>
</script>
</comment>
