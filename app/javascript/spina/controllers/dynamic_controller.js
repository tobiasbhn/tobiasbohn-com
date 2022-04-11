import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["parts", "select"]

  connect() {
    this.hideAllParts()
    this.updateSelects()
  }

  updateSelects() {
    this.selectTargets.forEach((select) => {
      this.partsTargets.forEach((part) => {
        if (part.dataset.partId == select.dataset.partId) {
          let isTarget = part.dataset.type == select.value
          part.hidden = !isTarget
        }
      })
    })
  }

  hideAllParts() {
    this.partsTargets.forEach((part) => {
      part.hidden = true
    })
  }
}
