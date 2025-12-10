/**
 * PropertyAutocomplete - Searchable property dropdown with lazy loading
 * 
 * Converts standard select elements into autocomplete dropdowns with:
 * - Real-time search
 * - Lazy loading with pagination
 * - Keyboard navigation
 * - Accessibility support
 * 
 * @module PropertyAutocomplete
 */

export class PropertyAutocomplete {
    /**
     * @param {HTMLElement} selectElement - The <select> element to enhance
     * @param {Object} options - Configuration options
     * @param {string} options.searchUrl - API endpoint for property search
     * @param {number} options.minChars - Minimum characters before search (default: 0)
     * @param {number} options.debounceMs - Debounce delay in milliseconds (default: 300)
     * @param {number} options.pageSize - Results per page (default: 20)
     */
    constructor(selectElement, options = {}) {
        this.select = selectElement;
        this.options = {
            searchUrl: '/api/properties/search/',
            minChars: 0,
            debounceMs: 300,
            pageSize: 20,
            ...options
        };
        
        this.currentValue = this.select.value;
        this.searchTimeout = null;
        this.currentPage = 1;
        this.hasMore = true;
        this.isLoading = false;
        
        this.init();
    }
    
    /**
     * Initialize the autocomplete component
     */
    init() {
        // Hide original select
        this.select.style.display = 'none';
        
        // Create autocomplete UI
        this.container = this.createContainer();
        this.input = this.createSearchInput();
        this.dropdown = this.createDropdown();
        this.loadingIndicator = this.createLoadingIndicator();
        
        // Assemble components
        this.container.appendChild(this.input);
        this.container.appendChild(this.loadingIndicator);
        this.container.appendChild(this.dropdown);
        
        // Insert after original select
        this.select.parentNode.insertBefore(this.container, this.select.nextSibling);
        
        // Set initial display value
        this.setInitialValue();
        
        // Attach event listeners
        this.attachEventListeners();
    }
    
    /**
     * Create main container element
     */
    createContainer() {
        const container = document.createElement('div');
        container.className = 'property-autocomplete';
        container.setAttribute('data-component', 'property-autocomplete');
        return container;
    }
    
    /**
     * Create search input field
     */
    createSearchInput() {
        const input = document.createElement('input');
        input.type = 'text';
        input.className = 'form-control property-autocomplete-input';
        input.placeholder = 'Search properties...';
        input.setAttribute('aria-label', 'Search properties');
        input.setAttribute('aria-autocomplete', 'list');
        input.setAttribute('aria-expanded', 'false');
        input.setAttribute('role', 'combobox');
        
        // Copy required attribute if present
        if (this.select.hasAttribute('required')) {
            input.setAttribute('required', '');
        }
        
        return input;
    }
    
    /**
     * Create dropdown results container
     */
    createDropdown() {
        const dropdown = document.createElement('div');
        dropdown.className = 'property-autocomplete-dropdown';
        dropdown.setAttribute('role', 'listbox');
        dropdown.style.display = 'none';
        return dropdown;
    }
    
    /**
     * Create loading indicator
     */
    createLoadingIndicator() {
        const indicator = document.createElement('div');
        indicator.className = 'property-autocomplete-loading';
        indicator.style.display = 'none';
        indicator.innerHTML = '<span class="spinner"></span> Loading...';
        return indicator;
    }
    
    /**
     * Set initial display value from selected option
     */
    setInitialValue() {
        const selectedOption = this.select.options[this.select.selectedIndex];
        if (selectedOption && selectedOption.value) {
            this.input.value = selectedOption.text;
            this.input.setAttribute('data-value', selectedOption.value);
        }
    }
    
    /**
     * Attach event listeners
     */
    attachEventListeners() {
        // Search on input
        this.input.addEventListener('input', () => this.handleInput());
        
        // Show dropdown on focus
        this.input.addEventListener('focus', () => this.handleFocus());
        
        // Hide dropdown on blur (with delay for click handling)
        this.input.addEventListener('blur', () => {
            setTimeout(() => this.hideDropdown(), 200);
        });
        
        // Keyboard navigation
        this.input.addEventListener('keydown', (e) => this.handleKeydown(e));
        
        // Scroll to load more
        this.dropdown.addEventListener('scroll', () => this.handleScroll());
        
        // Click outside to close
        document.addEventListener('click', (e) => {
            if (!this.container.contains(e.target)) {
                this.hideDropdown();
            }
        });
    }
    
    /**
     * Handle input changes with debouncing
     */
    handleInput() {
        clearTimeout(this.searchTimeout);
        
        const query = this.input.value.trim();
        
        // Reset pagination on new search
        this.currentPage = 1;
        this.hasMore = true;
        
        if (query.length >= this.options.minChars) {
            this.searchTimeout = setTimeout(() => {
                this.search(query);
            }, this.options.debounceMs);
        } else {
            // Show all properties if query is empty
            this.search('');
        }
    }
    
    /**
     * Handle focus - show dropdown with current results
     */
    handleFocus() {
        if (this.dropdown.children.length === 0) {
            this.search(this.input.value.trim());
        } else {
            this.showDropdown();
        }
    }
    
    /**
     * Handle keyboard navigation
     */
    handleKeydown(e) {
        const items = this.dropdown.querySelectorAll('.property-autocomplete-item');
        const currentIndex = Array.from(items).findIndex(item => 
            item.classList.contains('highlighted')
        );
        
        switch(e.key) {
            case 'ArrowDown':
                e.preventDefault();
                this.highlightItem(items, currentIndex + 1);
                break;
                
            case 'ArrowUp':
                e.preventDefault();
                this.highlightItem(items, currentIndex - 1);
                break;
                
            case 'Enter':
                e.preventDefault();
                if (currentIndex >= 0 && items[currentIndex]) {
                    this.selectItem(items[currentIndex]);
                }
                break;
                
            case 'Escape':
                this.hideDropdown();
                break;
        }
    }
    
    /**
     * Handle scroll for infinite loading
     */
    handleScroll() {
        if (this.isLoading || !this.hasMore) return;
        
        const scrollThreshold = 50; // px from bottom
        const scrollPos = this.dropdown.scrollTop + this.dropdown.clientHeight;
        const scrollHeight = this.dropdown.scrollHeight;
        
        if (scrollHeight - scrollPos < scrollThreshold) {
            this.loadMore();
        }
    }
    
    /**
     * Search for properties via API
     */
    async search(query) {
        try {
            this.showLoading();
            
            const url = new URL(this.options.searchUrl, window.location.origin);
            url.searchParams.set('q', query);
            url.searchParams.set('page', this.currentPage);
            url.searchParams.set('page_size', this.options.pageSize);
            
            const response = await fetch(url);
            
            if (!response.ok) {
                throw new Error(`Search failed: ${response.statusText}`);
            }
            
            const data = await response.json();
            
            // Clear dropdown for first page
            if (this.currentPage === 1) {
                this.dropdown.innerHTML = '';
            }
            
            // Render results
            this.renderResults(data.results);
            this.hasMore = data.has_more;
            
            this.hideLoading();
            this.showDropdown();
            
        } catch (error) {
            console.error('Property search error:', error);
            this.showError('Failed to load properties');
            this.hideLoading();
        }
    }
    
    /**
     * Load more results (pagination)
     */
    async loadMore() {
        if (this.isLoading || !this.hasMore) return;
        
        this.currentPage++;
        await this.search(this.input.value.trim());
    }
    
    /**
     * Render search results
     */
    renderResults(results) {
        if (results.length === 0 && this.currentPage === 1) {
            this.dropdown.innerHTML = '<div class="property-autocomplete-empty">No properties found</div>';
            return;
        }
        
        results.forEach(property => {
            const item = document.createElement('div');
            item.className = 'property-autocomplete-item';
            item.setAttribute('role', 'option');
            item.setAttribute('data-value', property.id);
            item.textContent = property.display;
            
            item.addEventListener('click', () => this.selectItem(item));
            
            this.dropdown.appendChild(item);
        });
    }
    
    /**
     * Highlight item by index
     */
    highlightItem(items, index) {
        // Remove existing highlight
        items.forEach(item => item.classList.remove('highlighted'));
        
        // Add highlight to new item (with wrapping)
        if (items.length > 0) {
            const safeIndex = ((index % items.length) + items.length) % items.length;
            items[safeIndex].classList.add('highlighted');
            items[safeIndex].scrollIntoView({ block: 'nearest' });
        }
    }
    
    /**
     * Select an item from dropdown
     */
    selectItem(item) {
        const value = item.getAttribute('data-value');
        const text = item.textContent;
        
        // Update hidden select
        this.select.value = value;
        
        // Update display input
        this.input.value = text;
        this.input.setAttribute('data-value', value);
        
        // Trigger change event on select
        this.select.dispatchEvent(new Event('change', { bubbles: true }));
        
        // Hide dropdown
        this.hideDropdown();
        
        // Update current value
        this.currentValue = value;
    }
    
    /**
     * Show dropdown
     */
    showDropdown() {
        this.dropdown.style.display = 'block';
        this.input.setAttribute('aria-expanded', 'true');
    }
    
    /**
     * Hide dropdown
     */
    hideDropdown() {
        this.dropdown.style.display = 'none';
        this.input.setAttribute('aria-expanded', 'false');
    }
    
    /**
     * Show loading indicator
     */
    showLoading() {
        this.isLoading = true;
        this.loadingIndicator.style.display = 'block';
    }
    
    /**
     * Hide loading indicator
     */
    hideLoading() {
        this.isLoading = false;
        this.loadingIndicator.style.display = 'none';
    }
    
    /**
     * Show error message
     */
    showError(message) {
        this.dropdown.innerHTML = `<div class="property-autocomplete-error">${message}</div>`;
        this.showDropdown();
    }
    
    /**
     * Destroy autocomplete and restore original select
     */
    destroy() {
        this.container.remove();
        this.select.style.display = '';
    }
}

/**
 * Initialize all property autocomplete fields on page
 */
export function initPropertyAutocomplete(selector = '[data-property-autocomplete]') {
    const selects = document.querySelectorAll(selector);
    const instances = [];
    
    selects.forEach(select => {
        const instance = new PropertyAutocomplete(select);
        instances.push(instance);
    });
    
    return instances;
}
