import { Controller } from "@hotwired/stimulus"
import Typed from 'typed.js';

// Connects to data-controller="typed"
export default class extends Controller {
  static targets =["test"]

  connect() {
    console.log("heyy")
  }

  display(event){
    console.log(event.currentTarget)
    event.currentTarget.style.display="none"
    if (this.testTarget){
      this.testTarget.style.display="flex"
    }
    const typed = new Typed('.text', {
      strings: ['Receiving your photo...^400', ' Building data...^400', 'Cleaning up...^400'],
      typeSpeed: 100,
    });
  }
}
