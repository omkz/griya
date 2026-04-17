import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
    static values = {
        latitude: Number,
        longitude: Number,
        title: String
    }

    connect() {
        this.initMap()
    }

    initMap() {
        // Default to Yogyakarta if no coordinates
        const lat = this.latitudeValue || -7.7956
        const lon = this.longitudeValue || 110.3671

        this.map = L.map(this.element).setView([lat, lon], 15)

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(this.map)

        if (this.latitudeValue && this.longitudeValue) {
            L.marker([lat, lon]).addTo(this.map)
                .bindPopup(this.titleValue || "Lokasi Properti")
                .openPopup()
        }

        // Fix for Leaflet resizing issues in Turbo
        setTimeout(() => {
            this.map.invalidateSize()
        }, 100)
    }

    disconnect() {
        if (this.map) {
            this.map.remove()
        }
    }
}
