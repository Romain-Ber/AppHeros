import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { userId: Number }
  static targets = ["messages"]

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChallengeChannel", id: this.userIdValue },
      { received: data => this.messagesTarget.insertAdjacentHTML("afterbegin", data) }
    )
    console.log(`Subscribe to the Challenge with the id ${this.userIdValue}.`)
  }
}
