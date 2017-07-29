<raw>
  <div></div>
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
