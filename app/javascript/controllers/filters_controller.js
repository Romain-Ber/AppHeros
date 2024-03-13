import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filters"
export default class extends Controller {
  static targets=["bar", "button"]

  resetFilters(event) {
    this.barTargets.forEach(bar => {
      bar.classList.remove("d-none")
    })
    this.activateButton(event)
  }

  maxPlayer(event) {
    // console.log(event.currentTarget)
    const count = parseInt(event.currentTarget.getAttribute("data-count"))
    // console.log(count)
    this.barTargets.forEach(bar => {
      const barCount = parseInt(bar.getAttribute("data-count"))
      if (barCount < count) {
        bar.classList.add("d-none")
      } else {
        bar.classList.remove("d-none")
      }
    })
    this.activateButton(event)
  }

  minPlayer(event) {
    const count = parseInt(event.currentTarget.getAttribute("data-count"))
    this.barTargets.forEach(bar => {
      const barCount = parseInt(bar.getAttribute("data-count"))
      if (barCount > count) {
        bar.classList.add("d-none")
      } else {
        bar.classList.remove("d-none")
      }
    })
    this.activateButton(event)
  }

  proximity(event) {
    const bars = JSON.parse(event.currentTarget.getAttribute("data-proximity"))

    this.barTargets.forEach(bar => {
      // console.log(bar.getAttribute("data-id"))
      if (bars.includes(parseInt(bar.getAttribute("data-id")))) {
        bar.classList.remove("d-none")
      } else {
        bar.classList.add("d-none")
      }
    })
    this.activateButton(event)
  }

  activateButton(event) {
    console.log(window.location.href)
    this.buttonTargets.forEach(button => {
      if (button === event.currentTarget) {
        button.classList.add("active")
      } else {
        button.classList.remove("active")
      }
    })
  }
}
