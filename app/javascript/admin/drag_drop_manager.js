/**
 * Drag & Drop Manager for Grid Layouts
 * Handles drag and drop functionality with grid-aware positioning (X and Y coordinates)
 */

export class DragDropManager {
  constructor(containerSelector, draggableSelector, addButtonSelector) {
    this.container = document.querySelector(containerSelector);
    this.draggableSelector = draggableSelector;
    this.addButtonSelector = addButtonSelector;
    this.draggedElement = null;

    if (!this.container) {
      console.error(`Container not found: ${containerSelector}`);
      return;
    }

    this.initialize();
  }

  /**
   * Initialize drag and drop for all existing draggable elements
   */
  initialize() {
    this.attachDragListeners(this.container.querySelectorAll(this.draggableSelector));
    console.log('DragDropManager initialized');
  }

  /**
   * Attach drag event listeners to elements
   * @param {NodeList|Array} elements - Elements to attach listeners to
   */
  attachDragListeners(elements) {
    elements.forEach(item => {
      // Remove existing listeners to avoid duplicates
      item.removeEventListener('dragstart', this.handleDragStart);
      item.removeEventListener('dragend', this.handleDragEnd);
      item.removeEventListener('dragover', this.handleDragOver);

      // Add new listeners
      item.addEventListener('dragstart', this.handleDragStart.bind(this));
      item.addEventListener('dragend', this.handleDragEnd.bind(this));
      item.addEventListener('dragover', this.handleDragOver.bind(this));
    });
  }

  /**
   * Handle drag start event
   * @param {DragEvent} e
   */
  handleDragStart(e) {
    this.draggedElement = e.currentTarget;
    e.currentTarget.classList.add('dragging');
    console.log('Drag started:', e.currentTarget.dataset.productId);
  }

  /**
   * Handle drag end event
   * @param {DragEvent} e
   */
  handleDragEnd(e) {
    e.currentTarget.classList.remove('dragging');
    this.ensureAddButtonFirst();
    console.log('Drag ended');
  }

  /**
   * Handle drag over event with grid-aware positioning
   * Uses both X and Y coordinates to determine proper position in grid
   * @param {DragEvent} e
   */
  handleDragOver(e) {
    e.preventDefault();

    const target = e.currentTarget;

    // Only proceed if target is draggable and not the element being dragged
    if (!target.classList.contains('draggable') || target === this.draggedElement) {
      return;
    }

    const dragging = this.draggedElement;
    if (!dragging) return;

    const rect = target.getBoundingClientRect();
    const midX = rect.left + rect.width / 2;
    const midY = rect.top + rect.height / 2;

    // Determine if items are in the same row using floor comparison
    const targetTop = Math.floor(rect.top);
    const dragTop = Math.floor(dragging.getBoundingClientRect().top);
    const sameRow = Math.abs(targetTop - dragTop) < rect.height / 2;

    console.log('Drag over - same row:', sameRow, 'clientX:', e.clientX, 'midX:', midX, 'clientY:', e.clientY, 'midY:', midY);

    if (sameRow) {
      // Same row: use X coordinate for left/right positioning
      if (e.clientX > midX) {
        // Insert after target
        target.parentNode.insertBefore(dragging, target.nextSibling);
      } else {
        // Insert before target
        target.parentNode.insertBefore(dragging, target);
      }
    } else {
      // Different row: use Y coordinate for above/below positioning
      if (e.clientY > midY) {
        // Insert after target
        target.parentNode.insertBefore(dragging, target.nextSibling);
      } else {
        // Insert before target
        target.parentNode.insertBefore(dragging, target);
      }
    }
  }

  /**
   * Ensure the "Add Product" button always stays in first position
   */
  ensureAddButtonFirst() {
    if (!this.addButtonSelector) return;

    const addButton = this.container.querySelector(this.addButtonSelector);
    if (addButton && this.container.firstElementChild !== addButton) {
      console.log('Moving add button to first position');
      this.container.insertBefore(addButton, this.container.firstElementChild);
    }
  }

  /**
   * Add drag listeners to a new element
   * @param {HTMLElement} element - New element to make draggable
   */
  makeElementDraggable(element) {
    this.attachDragListeners([element]);
  }

  /**
   * Get current order of product IDs
   * @returns {Array<string>} - Array of product IDs in current order
   */
  getCurrentOrder() {
    const products = this.container.querySelectorAll(this.draggableSelector);
    return Array.from(products).map(product => product.dataset.productId);
  }
}
