// function to update all links to preserve name
export const updateLinks = function (name) {
  // update all target links with name param (for redirect to pages without input field)
  var pageLinks = document.getElementsByClassName("update-user-name");
  for (var i = 0; i < pageLinks.length; i++) {
    var url = new URL(pageLinks[i]);
    if (name?.length > 0) {
      url.searchParams.set('name', name);
    } else {
      url.searchParams.delete('name');
    }
    pageLinks[i].href = url;
  }

  // update all other name-fillers
  var nameTargets = document.getElementsByClassName("fill-name");
  for (var i = 0; i < nameTargets.length; i++) {
    nameTargets[i].innerHTML = name;
  }
}

// trigger name update on page load
var url = new URL(window.location);
var nameParam = url.searchParams.get('name');
if (nameParam != null) {
  updateLinks(nameParam);
}
