import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  static targets = ["marker"]

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/romber/cltpnv2gf00ty01pkg00e27bd'
    })
    this.#addMarkersToMap()
    this.#fitMapToMarkers()
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
      const customMarker = document.createElement('div');
      customMarker.innerHTML = `<div data-action="click->map#activateMarker" data-map-target="marker"><svg width="32" height="36" viewBox="0 0 32 36" fill="none" xmlns="http://www.w3.org/2000/svg" style="transform: scale(0.75);">
      <circle cx="16" cy="16" r="16" fill="#45220A"/>
      <path fill-rule="evenodd" clip-rule="evenodd" d="M8.65439 10.2849C8.79037 10.2849 8.92635 10.2626 9.03966 10.2402L10.8754 12.5196C10.3314 13.1229 9.76487 13.6816 9.1983 14.2402C9.47025 14.486 9.71955 14.7542 9.9915 15C10.9433 14.3296 11.8952 13.6816 12.8697 13.0112C13.5496 12.0503 14.2975 11.067 15 10.0838C14.6827 9.7933 14.4108 9.54749 14.1161 9.27933C13.5722 9.83799 12.983 10.352 12.4391 10.8883L10.2408 9.1676C10.2861 9.01117 10.3088 8.81006 10.3088 8.65363C10.3088 7.73743 9.58357 7 8.65439 7C7.72521 7 7 7.73743 7 8.65363C7 9.54749 7.72521 10.2849 8.65439 10.2849Z" fill="#F3BF39"/>
      <path fill-rule="evenodd" clip-rule="evenodd" d="M23.3456 10.2849C23.2096 10.2849 23.0963 10.2626 22.9377 10.2402L21.102 12.5196C21.6686 13.1229 22.2351 13.6816 22.779 14.2402C22.5297 14.486 22.2805 14.7542 22.0312 15C21.0567 14.3296 20.0822 13.6816 19.1076 13.0112C18.4278 12.0503 17.7025 11.067 17 10.0838C17.3173 9.7933 17.5892 9.54749 17.8839 9.27933C18.4278 9.83799 18.9943 10.352 19.5609 10.8883L21.7592 9.1676C21.7139 9.01117 21.6686 8.81006 21.6686 8.65363C21.6686 7.73743 22.4164 7 23.3456 7C24.2521 7 25 7.73743 25 8.65363C25 9.54749 24.2521 10.2849 23.3456 10.2849Z" fill="#F3BF39"/>
      <path fill-rule="evenodd" clip-rule="evenodd" d="M17.3823 13C16.9252 13.418 16.4463 13.836 16.0109 14.232C15.532 13.836 15.0748 13.418 14.5959 13C14.2476 13.682 13.6816 14.298 12.9633 14.716L14.0735 15.97C12.4844 17.422 10.8952 18.852 9.32789 20.37C8.91429 21.624 8.41361 22.768 8 24C9.19728 23.604 10.5252 23.252 11.7224 22.834L16.0109 18.104L20.2776 22.834C21.4748 23.252 22.8027 23.604 24 24C23.5646 22.768 23.0857 21.624 22.6939 20.37C21.083 18.852 19.5156 17.422 17.9265 15.97L19.0367 14.716C18.2966 14.298 17.7524 13.682 17.3823 13Z" fill="#F3BF39"/>
      <rect x="12" y="31.2427" width="6" height="6" transform="rotate(-45 12 31.2427)" fill="#45220A"/>
      </svg></div>`
      new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  activateMarker(event) {
    this.markerTargets.forEach((marker) => {
      if (event.currentTarget === marker) {
        marker.style.transform = "scale(1.5)"
        marker.style.transition = 'transform 0.2s ease-in-out';
      } else {
        marker.style.transform = "scale(0.75)"
        marker.style.transition = 'transform 0.2s ease-in-out';
      }
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach((marker) => {
      bounds.extend([marker.lng, marker.lat])
    })
    this.map.fitBounds(bounds, {
      padding: 70,
      maxZoom: 15,
      duration: 0
    })
  }
}
