<decision>
  <h1 class="blog-title">IDK What this would do</h1>
  <h2 class="blog-title">Complete the current step before moving ahead</h2>
  <ul class="step">
    <li each={steps} data={this} class={"step-item"+ (active ? " active" : "")}>
      <a href="#" class="tooltip" data-tooltip={stepname}>{stepname}</a>
    </li>
  </ul>

<script>
this.steps = [];
</script>

</decision>
