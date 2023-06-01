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
      strings: ['Receiving your photo...^900','Breaking down your image ...^900', ' Building data...^900', 'Cleaning up...^900'],
      typeSpeed: 100,
      backSpeed: 80,
    });
  }
}
