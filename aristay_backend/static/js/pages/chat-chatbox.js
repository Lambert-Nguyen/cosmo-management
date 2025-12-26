/**
 * Chat Chatbox Page
 */

// Chat Application State
const ChatApp = {
    ws: null,
    currentRoom: null,
    userId: null, // Will be set from data attribute
    username: null, // Will be set from data attribute
    wsToken: null, // Will be set from data attribute
    typingTimeout: null,
    reconnectAttempts: 0,
    maxReconnectAttempts: 5
};

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    console.log('Chat app initializing...');
    
    // Initialize ChatApp state from data attributes
    const chatContainer = document.querySelector('.chat-container');
    if (chatContainer) {
        ChatApp.userId = parseInt(chatContainer.dataset.userId);
        ChatApp.username = chatContainer.dataset.username;
        ChatApp.wsToken = chatContainer.dataset.wsToken;
    }

    setupEventListeners();
});

function setupEventListeners() {
    // Auto-resize textarea
    const messageInput = document.getElementById('messageInput');
    if (messageInput) {
        messageInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });
        
        // Send on Enter (Shift+Enter for new line)
        messageInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    }
    
    // Room search
    const roomSearch = document.getElementById('roomSearch');
    if (roomSearch) {
        roomSearch.addEventListener('input', function(e) {
            filterRooms(e.target.value);
        });
    }

    // Room selection (Event Delegation)
    const roomList = document.getElementById('roomList');
    if (roomList) {
        roomList.addEventListener('click', function(e) {
            const roomItem = e.target.closest('.room-item');
            if (roomItem) {
                const roomId = roomItem.dataset.roomId;
                if (roomId) {
                    selectRoom(roomId);
                }
            }
        });
    }

    // Mobile menu toggle
    const mobileToggle = document.querySelector('.mobile-menu-toggle');
    if (mobileToggle) {
        mobileToggle.addEventListener('click', toggleRoomList);
    }

    // Send button
    const sendButton = document.getElementById('sendButton');
    if (sendButton) {
        sendButton.addEventListener('click', sendMessage);
    }
}

function selectRoom(roomId) {
    console.log('Selecting room:', roomId);

    // Disconnect from previous room
    if (ChatApp.ws) {
        ChatApp.ws.close();
    }

    ChatApp.currentRoom = roomId;

    // Update UI
    document.querySelectorAll('.room-item').forEach(item => {
        item.classList.remove('active');
    });
    const selectedRoom = document.querySelector(`[data-room-id="${roomId}"]`);
    if (selectedRoom) {
        selectedRoom.classList.add('active');

        // Update chat title with room name
        const roomName = selectedRoom.querySelector('.room-name')?.textContent || 'Chat';
        const chatTitle = document.getElementById('chatTitle');
        if (chatTitle) chatTitle.textContent = roomName;
    }

    // Show input area
    const inputArea = document.getElementById('inputArea');
    if (inputArea) inputArea.classList.remove('hidden');

    // Clear messages
    const messagesContainer = document.getElementById('messagesContainer');
    if (messagesContainer) messagesContainer.innerHTML = '<div class="loading-messages">Loading messages...</div>';

    // Connect to WebSocket
    connectWebSocket(roomId);

    // Load messages via REST API
    loadMessages(roomId);

    // Hide mobile room list
    if (window.innerWidth <= 768) {
        const roomList = document.getElementById('roomList');
        if (roomList) roomList.classList.remove('show');
    }
}

function connectWebSocket(roomId) {
    // Validate WebSocket token
    if (!ChatApp.wsToken) {
        console.error('No WebSocket token available');
        showConnectionStatus('Authentication failed', 'disconnected');
        showError('Unable to connect to chat. Please refresh the page and try again.');
        return;
    }

    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = `${protocol}//${window.location.host}/ws/chat/${roomId}/?token=${ChatApp.wsToken}`;

    console.log('Connecting to WebSocket:', wsUrl);

    showConnectionStatus('Connecting...', 'connecting');

    try {
        ChatApp.ws = new WebSocket(wsUrl);
    } catch (error) {
        console.error('Failed to create WebSocket:', error);
        showConnectionStatus('Failed to connect', 'disconnected');
        showError('Could not establish WebSocket connection. Real-time messaging may not work.');
        return;
    }

    ChatApp.ws.onopen = function() {
        console.log('WebSocket connected');
        showConnectionStatus('Connected', 'connected');
        ChatApp.reconnectAttempts = 0;

        setTimeout(() => {
            hideConnectionStatus();
        }, 2000);
    };

    ChatApp.ws.onmessage = function(event) {
        try {
            const data = JSON.parse(event.data);
            console.log('WebSocket message:', data);

            switch(data.type) {
                case 'connection_established':
                    updateRoomUnreadCount(roomId, data.unread_count);
                    break;
                case 'chat_message':
                    appendMessage(data.message);
                    break;
                case 'typing':
                    showTypingIndicator(data.username, data.is_typing);
                    break;
                case 'error':
                    console.error('WebSocket error:', data.message);
                    showError(data.message);
                    break;
            }
        } catch (error) {
            console.error('Error processing WebSocket message:', error);
        }
    };

    ChatApp.ws.onerror = function(error) {
        console.error('WebSocket error:', error);
        showConnectionStatus('Connection error', 'disconnected');
    };

    ChatApp.ws.onclose = function(event) {
        console.log('WebSocket closed, code:', event.code, 'reason:', event.reason);
        showConnectionStatus('Disconnected', 'disconnected');

        // Attempt reconnection
        if (ChatApp.reconnectAttempts < ChatApp.maxReconnectAttempts && ChatApp.currentRoom === roomId) {
            ChatApp.reconnectAttempts++;
            const delay = 2000 * ChatApp.reconnectAttempts;
            console.log(`Reconnecting in ${delay}ms... (attempt ${ChatApp.reconnectAttempts})`);
            setTimeout(() => {
                connectWebSocket(roomId);
            }, delay);
        } else if (ChatApp.reconnectAttempts >= ChatApp.maxReconnectAttempts) {
            showError('Lost connection to chat server. Please refresh the page to reconnect.');
        }
    };
}

function sendMessage() {
    const input = document.getElementById('messageInput');
    if (!input) return;
    
    const message = input.value.trim();
    
    if (!message || !ChatApp.ws || ChatApp.ws.readyState !== WebSocket.OPEN) {
        return;
    }
    
    ChatApp.ws.send(JSON.stringify({
        type: 'chat_message',
        message: message
    }));
    
    input.value = '';
    input.style.height = 'auto';
}

function appendMessage(message) {
    const container = document.getElementById('messagesContainer');
    if (!container) return;
    
    // Remove empty state if present
    const emptyState = container.querySelector('.empty-state, .loading-messages');
    if (emptyState) {
        container.innerHTML = '';
    }
    
    const isOwn = message.sender.id === ChatApp.userId;
    const messageTime = new Date(message.created_at).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    
    const messageEl = document.createElement('div');
    messageEl.className = `message ${isOwn ? 'own' : ''}`;
    messageEl.innerHTML = `
        <div class="message-content">
            ${!isOwn ? `<div class="message-sender">${message.sender.username}</div>` : ''}
            <div class="message-text">${escapeHtml(message.content)}</div>
            <div class="message-time">${messageTime}</div>
        </div>
    `;
    
    container.appendChild(messageEl);
    
    // Scroll to bottom
    container.scrollTop = container.scrollHeight;
}

async function loadMessages(roomId) {
    try {
        // Use credentials 'include' to send session cookies for authentication
        const response = await fetch(`/api/chat/messages/?room=${roomId}&page_size=50&ordering=created_at`, {
            credentials: 'include',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        });

        if (!response.ok) {
            console.error('Failed to load messages, status:', response.status);
            throw new Error('Failed to load messages');
        }

        const data = await response.json();
        const container = document.getElementById('messagesContainer');
        if (!container) return;
        
        container.innerHTML = '';

        if (data.results.length === 0) {
            container.innerHTML = `
                <div class="empty-state">
                    <div class="empty-state-icon">💬</div>
                    <h3>No messages yet</h3>
                    <p>Start the conversation!</p>
                </div>
            `;
            return;
        }

        // Messages come newest first (due to ordering='-created_at' in model), so reverse for display
        data.results.reverse().forEach(message => {
            if (!message.is_deleted) {
                appendMessage(message);
            }
        });

    } catch (error) {
        console.error('Error loading messages:', error);
        showError('Failed to load messages. Please refresh the page.');
    }
}

function showTypingIndicator(username, isTyping) {
    const indicator = document.getElementById('typingIndicator');
    if (indicator) {
        if (isTyping) {
            indicator.textContent = `${username} is typing...`;
        } else {
            indicator.textContent = '';
        }
    }
}

function showConnectionStatus(message, status) {
    const statusEl = document.getElementById('connectionStatus');
    if (statusEl) {
        statusEl.textContent = message;
        statusEl.className = `connection-status ${status}`;
        statusEl.classList.remove('hidden');
    }
}

function hideConnectionStatus() {
    const statusEl = document.getElementById('connectionStatus');
    if (statusEl) statusEl.classList.add('hidden');
}

function updateRoomUnreadCount(roomId, count) {
    const roomEl = document.querySelector(`[data-room-id="${roomId}"]`);
    if (roomEl) {
        const badge = roomEl.querySelector('.unread-badge');
        if (badge) {
            if (count > 0) {
                badge.textContent = count;
                badge.classList.remove('hidden');
            } else {
                badge.classList.add('hidden');
            }
        }
    }
}

function filterRooms(query) {
    const rooms = document.querySelectorAll('.room-item');
    const lowerQuery = query.toLowerCase();
    
    rooms.forEach(room => {
        const nameEl = room.querySelector('.room-name');
        if (nameEl) {
            const name = nameEl.textContent.toLowerCase();
            if (name.includes(lowerQuery)) {
                room.style.display = 'block';
            } else {
                room.style.display = 'none';
            }
        }
    });
}

function toggleRoomList() {
    const roomList = document.getElementById('roomList');
    if (roomList) roomList.classList.toggle('show');
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function showError(message) {
    // Simple error notification - show in connection status instead of alert
    console.error(message);
    showConnectionStatus(message, 'disconnected');

    // Auto-hide after 5 seconds
    setTimeout(() => {
        const statusEl = document.getElementById('connectionStatus');
        if (statusEl && statusEl.textContent === message) {
            hideConnectionStatus();
        }
    }, 5000);
}
