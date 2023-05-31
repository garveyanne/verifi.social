import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "blurrButton" ];
  showReVerifi() {
    console.log('button click');
  }
  connect() {
    console.log('controller connecting');
  }
}
