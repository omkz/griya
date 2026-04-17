import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
    static targets = ["input", "container"]
    static values = {
        latitude: Number,
        longitude: Number
    }

    connect() {
        this.initMap()
    }

    initMap() {
        // Default to Yogyakarta if no coordinates
        const lat = this.latitudeValue || -7.7956
        const lon = this.longitudeValue || 110.3671

        this.map = L.map(this.containerTarget).setView([lat, lon], 12)

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(this.map)

        this.marker = L.marker([lat, lon], { draggable: true }).addTo(this.map)

        // Update input on marker drag
        this.marker.on('dragend', (e) => {
            this.updateInput(e.target.getLatLng())
        })

        // Move marker on map click
        this.map.on('click', (e) => {
            this.marker.setLatLng(e.latlng)
            this.updateInput(e.latlng)
        })

        // Sync input if coordinates exist initially
        if (this.latitudeValue && this.longitudeValue) {
            this.updateInput({ lat, lng: lon })
        }

        setTimeout(() => this.map.invalidateSize(), 150)
    }

    updateInput(latlng) {
        const { lat, lng } = latlng
        this.inputTarget.value = `POINT(${lng.toFixed(6)} ${lat.toFixed(6)})`
    }

    disconnect() {
        if (this.map) this.map.remove()
    }
}
