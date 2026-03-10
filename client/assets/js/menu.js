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
