export default class LocationTracker {
  constructor(controller) {
    this.controller = controller
  }

  trackLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        position => {
          this.getLocationName(position.coords.latitude, position.coords.longitude)
            .then(locationName => this.controller.updateSender.sendUpdate({ location: locationName }))
        },
        () => this.controller.updateSender.sendUpdate({ location_error: 'Unable to retrieve location' })
      )
    }
  }

  async getLocationName(latitude, longitude) {
    try {
      const response = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`);
      const data = await response.json();
      const city = data.address.city || data.address.town || data.address.village || 'Unknown City';
      const state = data.address.state;
      const country = data.address.country || 'Unknown Country';

      if (state) {
        return `${city}, ${state}, ${country}`;
      } else {
        return `${city}, ${country}`;
      }
    } catch (error) {
      console.error('Error getting location name:', error);
      return 'Unknown Location';
    }
  }

  trackIp() {
    fetch('https://api.ipify.org?format=json')
      .then(response => response.json())
      .then(data => this.controller.updateSender.sendUpdate({ ip: data.ip }))
  }
}
