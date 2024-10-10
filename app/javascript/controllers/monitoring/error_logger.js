export default class ErrorLogger {
  constructor(controller) {
    this.controller = controller
  }

  logError(feature, error, context = {}) {
    console.error(`[${feature}] Error:`, error, 'Context:', context);
    this.controller.updateSender.debouncedSendUpdate({ error_log: { feature, error: error.message, context } });
  }
}
