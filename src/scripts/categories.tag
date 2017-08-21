<categories>
<div class="tags">
  <i class="fa fa-tag" aria-hidden="true"></i>
  <label
    each="{category in categories}"
    class="chip"
  >
    {category}
    <button class="btn btn-clear"></button>
  </label>
</div>

<script>

var self = this;

self.categories = ["programming", "python"];

</script>
</categories>
