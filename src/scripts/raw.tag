<raw>
  <span></span>
  <script>
  updateContent() {
    this.root.innerHTML = opts.content;
  }

  this.on("update", function() {
    this.updateContent();
  });

  this.updateContent();
  </script>
</raw>
