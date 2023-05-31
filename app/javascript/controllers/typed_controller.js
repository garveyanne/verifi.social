import { Controller } from "@hotwired/stimulus"
import Typed from 'typed.js';

// Connects to data-controller="typed"
export default class extends Controller {
  static targets=["test"]
  connect() {
    console.log("poo")
  }
  display(){
    this.testTarget.style.display="flex"
    const typed = new Typed('.text', {
      strings: ['Breaking down your photo ...', '&amp; Checking photo for high risk levels..', ' Building data...', 'Flagging areas with high risk...','Cleaning up...'],
      typeSpeed: 80,
    });
  }
}
