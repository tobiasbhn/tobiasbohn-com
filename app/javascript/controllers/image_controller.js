import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  openZoom(event) {
    let target = document.getElementById(event.currentTarget.dataset.id)
    if (target != null) {
      target.style.display = "flex"
    }
  }

  closeZoom(event) {
    event.currentTarget.style.display = "none"
  }
}
