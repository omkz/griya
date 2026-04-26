import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gallery"
export default class extends Controller {
    static targets = ["main", "thumbnail"]
    static classes = ["active"]

    select(event) {
        // 1. Get the source from the clicked thumbnail
        const newSrc = event.currentTarget.dataset.src

        // 2. Update the main image
        if (this.hasMainTarget) {
            this.mainTarget.src = newSrc
        }

        // 3. Update active state styles
        this.thumbnailTargets.forEach(thumb => {
            thumb.classList.remove(...this.activeClasses)
        })
        event.currentTarget.classList.add(...this.activeClasses)
    }
}
