// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "flowbite"
import "controllers"

// close main menu on background click or scroll
const mainMenuElement = document.getElementById('main-menu');
const mainMenuToggle = document.getElementById('main-menu-button');
var mainMenuCollapse = null;
if (mainMenuToggle != null && mainMenuElement != null) {
  mainMenuCollapse = new Collapse(mainMenuElement, {triggerEl: mainMenuToggle});
  // close main menu if clicked anywhere in window
  window.addEventListener("click", function (event) {
    mainMenuCollapse.collapse();
  });
  // close main menu on scroll
  window.addEventListener("scroll", function (event) {
    mainMenuCollapse.collapse();
  });
  // except the toggle button, which should be able to expand menu
  mainMenuToggle.addEventListener("click", function (event) {
    languageMenuCollapse?.collapse();
    event.stopImmediatePropagation();
  });
}

// close language menu on background click or scroll
const languageMenuElement = document.getElementById('language-menu');
const languageMenuToggle = document.getElementById('language-menu-button');
var languageMenuCollapse = null;
if (languageMenuToggle != null && languageMenuElement != null) {
  languageMenuCollapse = new Collapse(languageMenuElement, { triggerEl: languageMenuToggle });
  // close language menu if clicked anywhere in window
  window.addEventListener("click", function (event) {
    languageMenuCollapse.collapse();
  });
  // close language menu on scroll
  window.addEventListener("scroll", function (event) {
    languageMenuCollapse.collapse();
  });
  // except the toggle button, which should be able to expand menu
  languageMenuToggle.addEventListener("click", function (event) {
    mainMenuCollapse?.collapse();
    event.stopImmediatePropagation();
  });
}
