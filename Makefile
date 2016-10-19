default:
	sass blog.scss > styles/blog.min.css
	riot tags/ scripts/tags.js

watch:
	while true; do make ; inotifywait -qre close_write .; done
