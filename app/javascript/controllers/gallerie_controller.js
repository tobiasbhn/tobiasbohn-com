import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image"]
  static values = { index: Number }

  connect() {
    this.indexValue = 0
    this.updateDisplay(this.data.get("id"))
  }

  nextImage() {
    this.indexValue = this.indexValue++
    this.updateDisplay()
  }

  prevImage() {
    this.indexValue = this.indexValue--
    this.updateDisplay()
  }

  showImage(event) {
    this.indexValue = event.currentTarget.dataset.index
    this.updateDisplay(event.currentTarget.dataset.id)
  }

  updateDisplay(objectId) {
    this.imageTargets.forEach((img) => {
      if (img.dataset.id == objectId) {
        if (img.dataset.index == this.indexValue) {
          img.style.display = "initial"
        } else {
          img.style.display = "none"
        }
      }
    })
  }
}
