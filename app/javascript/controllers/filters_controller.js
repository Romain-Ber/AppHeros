import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filters"
export default class extends Controller {
  static targets=["bar"]
  connect() {

  }

  resetFilters() {
    this.barTargets.forEach(bar => {
      bar.classList.remove("d-none")
    })
  }

  applicateFilter() {
    this.barTargets.forEach(bar => {
      bar.classList.
    })
  }
}
