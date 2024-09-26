// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "trix"
import "@rails/actiontext"

// for allowing to add class disabled to links and make them unclickable
document.querySelectorAll('a.disabled').forEach(link => {
    link.href = '#';
    link.addEventListener('click', event => {
        event.preventDefault();
    });
});