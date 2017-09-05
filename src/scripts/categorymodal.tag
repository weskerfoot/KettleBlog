<categorymodal>
  <button
    style={{"margin" : "auto"}}
    class="btn btn-primary branded show-md"
    onclick={activate}
  >
    Categories
  </button>
  <div
    class={"modal " + (active ? "active" : "")}
  >
    <div class="modal-overlay"></div>
    <div
      class="modal-container"
      id="categorymodal"
    >
      <div class="modal-header">
        <button
          class="btn btn-clear float-right"
          onclick={close}
        >
        </button>
        <div class="modal-title h5">
          Categories
        </div>
      </div>
      <div class="modal-body">
        <div class="content">
          <yield/>
        </div>
      </div>
      <div class="modal-footer">
      </div>
    </div>
  </div>
<script>
import { default as RiotControl } from 'riotcontrol';
var self = this;

self.active = false;

self.opened = false;

self.activate = (ev) => {
  ev.preventDefault();
  self.update({
    "active" : true
  });
}

self.close = (ev) => {
  ev.preventDefault();
  self.update({
    "active" : false,
    "opened" : false
  });
}

self.toggle = (ev) => {
  ev.preventDefault();
  self.update({"active" : !self.active});
}

self.on("mount", () => {
  RiotControl.on("closecategories", (ev) => {
    if (self.active && self.opened) {
      self.update({
        "active" : false,
        "opened" : false
      });
    }
    else if (self.active && !self.opened) {
      ev.preventDefault();
      self.update({"opened" : true});
    }
  });
});

</script>
</categorymodal>
