/**
 * Product Search Handler
 * Handles filtering/searching of products in a list
 */

export class ProductSearch {
  constructor(searchInputId, productSelector, dataAttribute = 'productName') {
    this.searchInput = document.getElementById(searchInputId);
    this.productSelector = productSelector;
    this.dataAttribute = dataAttribute;

    if (!this.searchInput) {
      console.error(`Search input not found: ${searchInputId}`);
      return;
    }

    this.initialize();
  }

  /**
   * Initialize search functionality
   */
  initialize() {
    this.searchInput.addEventListener('input', (e) => this.handleSearch(e));
    console.log('ProductSearch initialized');
  }

  /**
   * Handle search input event
   * @param {Event} e - Input event
   */
  handleSearch(e) {
    const searchTerm = e.target.value.toLowerCase().trim();
    const products = document.querySelectorAll(this.productSelector);

    console.log(`Searching for: "${searchTerm}"`);

    let visibleCount = 0;

    products.forEach(product => {
      const productName = product.dataset[this.dataAttribute];

      if (!productName) {
        console.warn('Product missing data attribute:', this.dataAttribute, product);
        return;
      }

      if (productName.toLowerCase().includes(searchTerm)) {
        product.style.display = '';
        visibleCount++;
      } else {
        product.style.display = 'none';
      }
    });

    console.log(`${visibleCount} products visible out of ${products.length}`);
  }

  /**
   * Clear search input and show all products
   */
  clearSearch() {
    this.searchInput.value = '';
    const products = document.querySelectorAll(this.productSelector);
    products.forEach(product => {
      product.style.display = '';
    });
    console.log('Search cleared');
  }

  /**
   * Get current search term
   * @returns {string}
   */
  getSearchTerm() {
    return this.searchInput.value.toLowerCase().trim();
  }
}
