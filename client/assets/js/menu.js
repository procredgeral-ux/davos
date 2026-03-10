/* Menu Control Functions */

function startGame() {
    const nick = document.getElementById('nick').value;
    if (typeof setNick === 'function') {
        setNick(nick);
    }
}

function openSkinsModal() {
    const modal = document.getElementById('skinsModal');
    if (modal) {
        modal.classList.add('active');
        if (typeof openSkinsList === 'function') {
            openSkinsList();
        }
    }
}

function closeSkinsModal() {
    const modal = document.getElementById('skinsModal');
    if (modal) {
        modal.classList.remove('active');
    }
}

function openMessageModal(title, message, type = 'info') {
    const modal = document.getElementById('messageModal');
    const modalTitle = document.getElementById('messageModalTitle');
    const modalBody = document.getElementById('messageModalBody');
    const modalHeader = document.getElementById('messageModalHeader');
    
    if (modal && modalTitle && modalBody) {
        modalTitle.textContent = title;
        modalBody.innerHTML = `<p>${message}</p>`;
        
        // Remove previous type classes
        modalHeader.classList.remove('modal-error', 'modal-info');
        // Add new type class
        if (type === 'error') {
            modalHeader.classList.add('modal-error');
        } else {
            modalHeader.classList.add('modal-info');
        }
        
        modal.classList.add('active');
    }
}

function closeMessageModal() {
    const modal = document.getElementById('messageModal');
    if (modal) {
        modal.classList.remove('active');
    }
}

// Clan Modal Functions
function openClanModal() {
    const modal = document.getElementById('clanModal');
    if (modal) {
        modal.classList.add('active');
    }
}

function closeClanModal() {
    const modal = document.getElementById('clanModal');
    if (modal) {
        modal.classList.remove('active');
    }
}

// Updates Modal Functions
function openUpdatesModal() {
    const modal = document.getElementById('updatesModal');
    if (modal) {
        modal.classList.add('active');
    }
}

function closeUpdatesModal() {
    const modal = document.getElementById('updatesModal');
    if (modal) {
        modal.classList.remove('active');
    }
}

// Tab Switching Function
function showTab(tabName, btnElement) {
    // Hide all tab contents
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Show selected tab
    const selectedTab = document.getElementById('tab-' + tabName);
    if (selectedTab) {
        selectedTab.classList.add('active');
    }
    
    // Update tab buttons - remove active from all
    document.querySelectorAll('.davos-tabs .tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Add active to clicked button
    if (btnElement) {
        btnElement.classList.add('active');
    }
}

// Close modals when clicking outside
window.onclick = function(event) {
    if (event.target.classList.contains('modal-overlay')) {
        event.target.classList.remove('active');
    }
}

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.active').forEach(modal => {
            modal.classList.remove('active');
        });
    }
});
