import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "status"]

  start() {
    this.statusTarget.textContent = "Looking up mapped communities… Larger areas may take over a minute."
    this.element.setAttribute("aria-busy", "true")
  }

  finish() {
    this.element.removeAttribute("aria-busy")
  }
}
