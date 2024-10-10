import { debounce } from './utils'

export default class UpdateSender {
  constructor(controller) {
    this.controller = controller
    this.debouncedSendUpdate = debounce(this.sendUpdate.bind(this), 300);
  }

  sendUpdate(data) {
    const url = `/api/monitoring/${this.controller.assessmentParticipationHashIdValue}`;
    fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify(data)
    });
  }

  bufferStateChange(stateKey, newValue, bufferTime = 2000) {
    clearTimeout(this[`${stateKey}Timer`]);
    this[`${stateKey}Timer`] = setTimeout(() => {
      this.debouncedSendUpdate({ [stateKey]: newValue });
    }, bufferTime);
  }
}
