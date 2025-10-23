/**
 * Modal Handler
 * Manages modal open/close functionality
 */

export class ModalHandler {
  constructor(modalId, openButtonId, closeButtonId) {
    this.modal = document.getElementById(modalId);
    this.openButton = document.getElementById(openButtonId);
    this.closeButton = document.getElementById(closeButtonId);

    if (!this.modal) {
      console.error(`Modal not found: ${modalId}`);
      return;
    }

    if (!this.openButton) {
      console.error(`Open button not found: ${openButtonId}`);
      return;
    }

    if (!this.closeButton) {
      console.error(`Close button not found: ${closeButtonId}`);
      return;
    }

    this.initialize();
  }

  /**
   * Initialize modal event listeners
   */
  initialize() {
    // Open modal button
    this.openButton.addEventListener('click', () => this.open());

    // Close modal button
    this.closeButton.addEventListener('click', () => this.close());

    // Close modal when clicking outside (on overlay)
    this.modal.addEventListener('click', (e) => {
      if (e.target === this.modal) {
        this.close();
      }
    });

    console.log('ModalHandler initialized');
  }

  /**
   * Open the modal
   */
  open() {
    this.modal.style.display = 'flex';
    console.log('Modal opened');
  }

  /**
   * Close the modal
   */
  close() {
    this.modal.style.display = 'none';
    console.log('Modal closed');
  }

  /**
   * Check if modal is open
   * @returns {boolean}
   */
  isOpen() {
    return this.modal.style.display === 'flex';
  }
}
