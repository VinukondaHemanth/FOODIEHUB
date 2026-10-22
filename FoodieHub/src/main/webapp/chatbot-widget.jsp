
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String chatbotContext = request.getContextPath();
%>

<style>
#fh-chat-launcher,
#fh-chat-window,
#fh-chat-window * {
    box-sizing: border-box;
}

/* Floating transparent robot */
#fh-chat-launcher {
    position: fixed;
    right: 20px;
    bottom: 18px;
    z-index: 2147483000;
    width: 100px;
    height: 115px;
    padding: 0;

    display: flex;
    align-items: center;
    justify-content: center;

    border: none;
    border-radius: 0;
    background: transparent;
    box-shadow: none;
    cursor: pointer;
    overflow: visible;
    transition: transform .25s ease;
}

#fh-chat-launcher:hover {
    transform: translateY(-5px) scale(1.04);
    background: transparent;
    box-shadow: none;
}

#fh-chat-launcher .fh-chat-robot {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: contain;
    background: transparent;
    border: none;
    border-radius: 0;
    box-shadow: none;
}

#fh-chat-launcher .fh-chat-robot-fallback {
    display: none;
    font-size: 42px;
}

#fh-chat-launcher .fh-chat-online {
    position: absolute;
    right: 5px;
    bottom: 7px;
    width: 13px;
    height: 13px;
    border: 2px solid #fff;
    border-radius: 50%;
    background: #36ff88;
    box-shadow: 0 0 9px rgba(54,255,136,.75);
}

/* Chat window */
#fh-chat-window {
    position: fixed;
    right: 24px;
    bottom: 145px;
    z-index: 2147483001;

    width: min(370px, calc(100vw - 28px));
    height: min(540px, calc(100vh - 165px));
    min-height: 350px;

    display: none;
    flex-direction: column;
    overflow: hidden;

    border: 1px solid rgba(105,255,172,.35);
    border-radius: 20px;
    background: #041e16;
    color: #f3fff7;
    box-shadow: 0 20px 65px rgba(0,0,0,.55);
    font-family: Arial, Helvetica, sans-serif;
}

#fh-chat-window.fh-chat-open {
    display: flex;
    animation: fhChatAppear .2s ease-out;
}

@keyframes fhChatAppear {
    from {
        opacity: 0;
        transform: translateY(10px) scale(.98);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

/* Header */
#fh-chat-window .fh-chat-header {
    display: flex;
    align-items: center;
    gap: 11px;
    padding: 15px;
    background: linear-gradient(120deg, #075235, #063323);
    border-bottom: 1px solid rgba(105,255,172,.2);
}

/* Header robot: same PNG as floating robot */
#fh-chat-window .fh-chat-avatar {
    width: 48px;
    height: 48px;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    border: none;
    border-radius: 0;
    background: transparent;
    box-shadow: none;
}

#fh-chat-window .fh-chat-header-robot {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: contain;
    border: none;
    border-radius: 0;
    background: transparent;
    box-shadow: none;
}

#fh-chat-window .fh-chat-heading {
    flex: 1;
    min-width: 0;
}

#fh-chat-window .fh-chat-heading strong {
    display: block;
    font-size: 15px;
    color: #fff;
}

#fh-chat-window .fh-chat-heading small {
    display: block;
    margin-top: 4px;
    color: #b9e9ca;
    font-size: 11px;
}

#fh-chat-window .fh-chat-close {
    width: 34px;
    height: 34px;
    flex-shrink: 0;
    border: 1px solid rgba(255,255,255,.2);
    border-radius: 10px;
    background: rgba(0,0,0,.15);
    color: #fff;
    font-size: 23px;
    cursor: pointer;
}

/* Message area */
#fh-chat-window .fh-chat-messages {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    padding: 15px 12px;
    display: flex;
    flex-direction: column;
    gap: 10px;
    background: radial-gradient(ellipse at top, #073323, #041e16 70%);
}

#fh-chat-window .fh-chat-message {
    max-width: 88%;
    padding: 11px 12px;
    border-radius: 13px;
    font-size: 13px;
    line-height: 1.55;
    overflow-wrap: anywhere;
    white-space: pre-wrap;
}

#fh-chat-window .fh-chat-bot {
    align-self: flex-start;
    color: #e9fff0;
    background: #0b3827;
    border: 1px solid rgba(105,255,172,.13);
    border-bottom-left-radius: 4px;
}

#fh-chat-window .fh-chat-user {
    align-self: flex-end;
    color: #00331d;
    background: linear-gradient(110deg, #8dffad, #48f58a);
    border-bottom-right-radius: 4px;
}

/* Quick actions */
#fh-chat-window .fh-chat-quick-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    padding: 0 12px 10px;
    background: #041e16;
}

#fh-chat-window .fh-chat-quick-actions button {
    border: 1px solid rgba(105,255,172,.28);
    border-radius: 20px;
    padding: 7px 10px;
    color: #caffd9;
    background: #092b1e;
    font-size: 11px;
    cursor: pointer;
}

#fh-chat-window .fh-chat-quick-actions button:hover {
    background: #104b31;
}

/* Typing indicator */
#fh-chat-window .fh-chat-typing {
    display: none;
    padding: 0 14px 9px;
    background: #06271b;
    color: #9ccdb0;
    font-size: 11px;
}

/* Input form */
#fh-chat-window .fh-chat-form {
    display: flex;
    gap: 8px;
    padding: 12px;
    background: #06271b;
    border-top: 1px solid rgba(105,255,172,.17);
}

#fh-chat-window .fh-chat-input {
    flex: 1;
    min-width: 0;
    height: 43px;
    border: 1px solid rgba(105,255,172,.24);
    border-radius: 12px;
    outline: none;
    padding: 0 12px;
    color: #f4fff8;
    background: #031b13;
    font-size: 13px;
}

#fh-chat-window .fh-chat-input:focus {
    border-color: #56ff9d;
}

#fh-chat-window .fh-chat-send {
    width: 45px;
    height: 43px;
    flex-shrink: 0;
    border: none;
    border-radius: 12px;
    color: #00351e;
    background: linear-gradient(120deg, #8dffad, #43f486);
    font-size: 20px;
    font-weight: bold;
    cursor: pointer;
}

#fh-chat-window .fh-chat-send:disabled {
    opacity: .55;
    cursor: wait;
}

@media (max-width: 480px) {
    #fh-chat-launcher {
        width: 82px;
        height: 95px;
        right: 12px;
        bottom: 10px;
    }

    #fh-chat-window {
        right: 10px;
        bottom: 115px;
        width: calc(100vw - 20px);
        height: min(520px, calc(100vh - 135px));
        min-height: 320px;
    }
}
</style>

<!-- Floating chatbot robot -->
<button type="button"
        id="fh-chat-launcher"
        aria-label="Open FoodieHub chat"
        aria-controls="fh-chat-window"
        aria-expanded="false">

    <img class="fh-chat-robot"
         src="<%= chatbotContext %>/images/chatbot-robot.png"
         alt="FoodieHub chatbot robot"
         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">

    <span class="fh-chat-robot-fallback" aria-hidden="true">🤖</span>
    <span class="fh-chat-online" aria-hidden="true"></span>
</button>

<!-- Chat panel -->
<section id="fh-chat-window"
         role="dialog"
         aria-label="FoodieHub chatbot"
         aria-hidden="true">

    <header class="fh-chat-header">

        <!-- Same transparent PNG as the floating robot -->
        <div class="fh-chat-avatar">
            <img
                src="<%= chatbotContext %>/images/chatbot-robot.png"
                alt="FoodieHub Assistant"
                class="fh-chat-header-robot"
                onerror="this.style.display='none';">
        </div>

        <div class="fh-chat-heading">
            <strong>FoodieHub Assistant</strong>
            <small>Online · Here to help you</small>
        </div>

        <button type="button"
                class="fh-chat-close"
                id="fh-chat-close"
                aria-label="Close chat">×</button>
    </header>

    <div class="fh-chat-messages"
         id="fh-chat-messages"
         aria-live="polite">

        <div class="fh-chat-message fh-chat-bot">Hello! Welcome to FoodieHub. How can I help you today?</div>
    </div>

    <div class="fh-chat-quick-actions" id="fh-chat-quick-actions">
        <button type="button" data-question="Show me restaurants">Restaurants</button>
        <button type="button" data-question="How do I view the menu?">Menu</button>
        <button type="button" data-question="How does checkout work?">Checkout</button>
        <button type="button" data-question="How do I view my orders?">My orders</button>
    </div>

    <div class="fh-chat-typing" id="fh-chat-typing">
        Assistant is typing...
    </div>

    <form class="fh-chat-form" id="fh-chat-form">
        <input class="fh-chat-input"
               id="fh-chat-input"
               name="message"
               type="text"
               maxlength="500"
               placeholder="Ask me anything..."
               autocomplete="off"
               aria-label="Type your message"
               required>

        <button class="fh-chat-send"
                id="fh-chat-send"
                type="submit"
                aria-label="Send message">➤</button>
    </form>
</section>

<script>
(function () {
    "use strict";

    /* Prevent duplicate event handlers */
    if (window.foodieHubChatInitialized) {
        return;
    }
    window.foodieHubChatInitialized = true;

    var contextPath = "<%= chatbotContext %>";
    var endpoint = contextPath + "/chatbot";

    function initializeChat() {
        var launcher = document.getElementById("fh-chat-launcher");
        var panel = document.getElementById("fh-chat-window");
        var closeButton = document.getElementById("fh-chat-close");
        var messages = document.getElementById("fh-chat-messages");
        var form = document.getElementById("fh-chat-form");
        var input = document.getElementById("fh-chat-input");
        var sendButton = document.getElementById("fh-chat-send");
        var typing = document.getElementById("fh-chat-typing");
        var quickActions = document.getElementById("fh-chat-quick-actions");

        if (!launcher || !panel || !closeButton || !messages ||
            !form || !input || !sendButton || !typing) {
            console.error("FoodieHub chatbot: a required widget element is missing.");
            return;
        }

        function openChat() {
            panel.classList.add("fh-chat-open");
            panel.setAttribute("aria-hidden", "false");
            launcher.setAttribute("aria-expanded", "true");
            input.focus();
            messages.scrollTop = messages.scrollHeight;
        }

        function closeChat() {
            panel.classList.remove("fh-chat-open");
            panel.setAttribute("aria-hidden", "true");
            launcher.setAttribute("aria-expanded", "false");
            launcher.focus();
        }

        function addMessage(text, sender) {
            var bubble = document.createElement("div");

            bubble.className = "fh-chat-message " +
                (sender === "user" ? "fh-chat-user" : "fh-chat-bot");

            bubble.textContent = text;
            messages.appendChild(bubble);
            messages.scrollTop = messages.scrollHeight;
        }

        function localReply(message) {
            var text = message.toLowerCase();

            if (/\b(hi|hello|hey)\b/.test(text)) {
                return "Hello! Welcome to FoodieHub. How can I help you?";
            }

            if (text.indexOf("restaurant") !== -1) {
                return "Open the Restaurants page and select a restaurant to explore its menu.";
            }

            if (text.indexOf("menu") !== -1 || text.indexOf("food") !== -1) {
                return "Choose a restaurant to view its menu, then add your favourite dishes to the cart.";
            }

            if (text.indexOf("cart") !== -1) {
                return "Open your Cart page to review the items you selected.";
            }

            if (text.indexOf("checkout") !== -1 ||
                text.indexOf("payment") !== -1) {
                return "Open your Cart and select Proceed to Pay to continue checkout.";
            }

            if (text.indexOf("order") !== -1 ||
                text.indexOf("delivery") !== -1) {
                return "Open My Orders to review your orders. Personal order details may require login.";
            }

            if (text.indexOf("login") !== -1 ||
                text.indexOf("sign in") !== -1) {
                return "Use the Login page to access your account.";
            }

            if (text.indexOf("sign up") !== -1 ||
                text.indexOf("register") !== -1) {
                return "Open the Sign Up page to create your account.";
            }

            if (text.indexOf("thank") !== -1) {
                return "You're welcome! Enjoy FoodieHub.";
            }

            if (text.indexOf("help") !== -1) {
                return "Ask me about restaurants, menus, cart, checkout, payments, login, or orders.";
            }

            return "Sorry, I do not understand. Please ask about FoodieHub restaurants, menus, cart, checkout, or orders.";
        }

        function sendMessage(message) {
            message = message.trim();

            if (!message || sendButton.disabled) {
                return;
            }

            addMessage(message, "user");
            input.value = "";
            sendButton.disabled = true;
            typing.style.display = "block";

            var body = new URLSearchParams();
            body.set("message", message);

            fetch(endpoint, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: body.toString(),
                credentials: "same-origin"
            })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Chat endpoint returned HTTP " + response.status);
                }
                return response.json();
            })
            .then(function (data) {
                if (!data || typeof data.reply !== "string") {
                    throw new Error("Invalid chatbot response");
                }

                addMessage(data.reply, "bot");
            })
            .catch(function (error) {
                console.warn("FoodieHub chatbot endpoint unavailable; using local reply.", error);
                addMessage(localReply(message), "bot");
            })
            .finally(function () {
                typing.style.display = "none";
                sendButton.disabled = false;
                input.focus();
            });
        }

        launcher.addEventListener("click", function () {
            if (panel.classList.contains("fh-chat-open")) {
                closeChat();
            } else {
                openChat();
            }
        });

        closeButton.addEventListener("click", closeChat);

        form.addEventListener("submit", function (event) {
            event.preventDefault();
            sendMessage(input.value);
        });

        if (quickActions) {
            quickActions.addEventListener("click", function (event) {
                var button = event.target.closest("button[data-question]");

                if (button) {
                    sendMessage(button.getAttribute("data-question"));
                }
            });
        }

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape" &&
                panel.classList.contains("fh-chat-open")) {
                closeChat();
            }
        });
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initializeChat, {
            once: true
        });
    } else {
        initializeChat();
    }
})();
</script>
