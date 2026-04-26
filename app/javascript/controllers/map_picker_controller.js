import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
    static targets = ["input", "container", "query", "suggestions", "address"]
    static values = {
        latitude: Number,
        longitude: Number
    }

    connect() {
        this.initMap()
        this.timeout = null
        this.viewbox = "110.0,-7.5,110.85,-8.25"
    }

    initMap() {
        const lat = this.latitudeValue || -7.7956
        const lon = this.longitudeValue || 110.3671

        this.map = L.map(this.containerTarget).setView([lat, lon], 12)

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(this.map)

        this.marker = L.marker([lat, lon], { draggable: true }).addTo(this.map)

        this.marker.on('dragend', (e) => {
            const latlng = e.target.getLatLng()
            this.updateInput(latlng)
            this.reverseGeocode(latlng)
        })

        this.map.on('click', (e) => {
            this.marker.setLatLng(e.latlng)
            this.updateInput(e.latlng)
            this.reverseGeocode(e.latlng)
        })

        if (this.latitudeValue && this.longitudeValue) {
            this.updateInput({ lat, lng: lon })
        }

        setTimeout(() => this.map.invalidateSize(), 150)
    }

    // Debounced search for suggestions
    suggest() {
        if (this.timeout) clearTimeout(this.timeout)

        const query = this.queryTarget.value
        if (query.length < 3) {
            this.hideSuggestions()
            return
        }

        this.timeout = setTimeout(() => {
            this.fetchSuggestions(query)
        }, 500)
    }

    async fetchSuggestions(query) {
        try {
            const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&limit=5&addressdetails=1&countrycodes=id&viewbox=${this.viewbox}&bounded=1`
            const response = await fetch(url)
            const data = await response.json()
            this.renderSuggestions(data)
        } catch (error) {
            console.error("Geocoding suggestions error:", error)
        }
    }

    renderSuggestions(data) {
        if (data.length === 0) {
            this.hideSuggestions()
            return
        }

        const html = data.map(item => `
            <div class="px-4 py-3 hover:bg-blue-50 cursor-pointer border-b last:border-0 border-gray-100 transition-colors"
                 data-action="click->map-picker#selectSuggestion"
                 data-lat="${item.lat}"
                 data-lon="${item.lon}"
                 data-display-name="${item.display_name}">
                <p class="text-xs font-bold text-gray-900 truncate">${item.display_name}</p>
                <p class="text-[10px] text-gray-400 uppercase tracking-tighter mt-0.5">${item.type.replace('_', ' ')}</p>
            </div>
        `).join('')

        this.suggestionsTarget.innerHTML = html
        this.suggestionsTarget.classList.remove('hidden')
    }

    selectSuggestion(event) {
        const { lat, lon, displayName } = event.currentTarget.dataset
        const latlng = L.latLng(lat, lon)

        this.map.setView(latlng, 15)
        this.marker.setLatLng(latlng)
        this.updateInput(latlng)

        this.queryTarget.value = displayName
        this.hideSuggestions()

        // When a suggestion is picked, also update the address field
        if (this.hasAddressTarget) {
            this.addressTarget.value = displayName
        }
    }

    hideSuggestions() {
        this.suggestionsTarget.innerHTML = ""
        this.suggestionsTarget.classList.add('hidden')
    }

    async search(event) {
        if (event) event.preventDefault()
        this.hideSuggestions()

        const query = this.queryTarget.value
        if (!query) return

        try {
            const url = `https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&limit=1&countrycodes=id&viewbox=${this.viewbox}&bounded=1`
            const response = await fetch(url)
            const data = await response.json()

            if (data.length > 0) {
                const { lat, lon, display_name } = data[0]
                const latlng = L.latLng(lat, lon)
                this.map.setView(latlng, 15)
                this.marker.setLatLng(latlng)
                this.updateInput(latlng)

                if (this.hasAddressTarget) {
                    this.addressTarget.value = display_name
                }
            }
        } catch (error) {
            console.error("Geocoding error:", error)
        }
    }

    async reverseGeocode(latlng) {
        if (!this.hasAddressTarget) return

        try {
            const response = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${latlng.lat}&lon=${latlng.lng}&zoom=18&addressdetails=1`)
            const data = await response.json()

            if (data && data.display_name) {
                this.addressTarget.value = data.display_name
            }
        } catch (error) {
            console.error("Reverse geocoding error:", error)
        }
    }

    updateInput(latlng) {
        const { lat, lng } = latlng
        this.inputTarget.value = `POINT(${lng.toFixed(6)} ${lat.toFixed(6)})`
    }

    disconnect() {
        if (this.map) this.map.remove()
    }
}
