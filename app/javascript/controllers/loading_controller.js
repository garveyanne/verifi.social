import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
export default class extends Controller {
  static targets = ['spinner']
  connect() {
    console.log("hi")
  }
  showSpinner(){
    this.spinnerTarget.classList.add("active")
  }
}
