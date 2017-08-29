<categories>
<div class="tags">
  <i class="fa fa-tag" aria-hidden="true"></i>
  <label
    each="{category in opts.names}"
    class="chip"
    onclick={browseCategories(category)}
  >
    {category}
  </label>
</div>
<script>
import route from 'riot-route';

var self = this;

self.route = route;

browseCategories(name) {
  return (ev) => {
    ev.preventDefault();
    window.RiotControl.trigger("browsecategories", name);
  };
}

</script>
</categories>
