
package com.tap.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/chatbot")
public class ChatbotController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int MAX_MESSAGE_LENGTH = 500;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(StandardCharsets.UTF_8.name());

        writeJson(response,
                "{\"reply\":\"Hello! Welcome to FoodieHub. Ask me about food, restaurants, programming, studies, or anything else.\"}");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(StandardCharsets.UTF_8.name());

        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            writeReply(response,
                    "What would you like to know? You can ask me about FoodieHub, food, technology, studies, or everyday topics.");
            return;
        }

        message = message.trim();

        if (message.length() > MAX_MESSAGE_LENGTH) {
            message = message.substring(0, MAX_MESSAGE_LENGTH);
        }

        String reply = getReply(message);
        writeReply(response, reply);
    }

    /**
     * Generates a helpful response using local rules.
     * No external API or additional dependency is required.
     */
    private String getReply(String originalMessage) {

        String message = originalMessage.toLowerCase(Locale.ROOT).trim();
        String normalized = message.replaceAll("[^a-z0-9\\s]", " ")
                                   .replaceAll("\\s+", " ")
                                   .trim();

        // Greetings
        if (containsAny(normalized,
                "hello", "hi", "hey", "good morning",
                "good afternoon", "good evening", "good night")) {
            return "Hello! Welcome to FoodieHub. 😊 "
                    + "How can I help you today? You can ask about restaurants, "
                    + "food, orders, programming, studies, or everyday questions.";
        }

        // Identity
        if (containsAny(normalized,
                "who are you", "what are you", "your name",
                "who created you", "who made you")) {
            return "I'm the FoodieHub Assistant! 🤖 "
                    + "I'm here to help with restaurants, food, menus, carts, "
                    + "checkout, orders, and general questions. "
                    + "I can also provide basic information about technology and learning.";
        }

        // FoodieHub restaurants
        if (containsAny(normalized,
                "restaurant", "restaurants", "nearby restaurant",
                "find a restaurant", "best restaurant")) {
            return "To explore restaurants on FoodieHub, open the Restaurants page "
                    + "and select a restaurant to see its menu. "
                    + "For nearby recommendations, tell me your location and preferred cuisine.";
        }

        // Menu and dishes
        if (containsAny(normalized,
                "menu", "menus", "dish", "dishes", "food item",
                "food items", "what can i eat", "recommend food",
                "recommend a dish", "vegetarian", "vegan",
                "biryani", "dosa", "pizza", "burger", "idli",
                "paneer", "dessert", "breakfast", "lunch", "dinner")) {
            return "I can help you choose food! 🍽️ "
                    + "Tell me your preferred cuisine, whether you want vegetarian "
                    + "or non-vegetarian food, and your budget. "
                    + "For available dishes and prices, open a restaurant's menu in FoodieHub.";
        }

        // Cart
        if (containsAny(normalized,
                "cart", "shopping cart", "add to cart",
                "remove item", "change quantity", "cart total")) {
            return "To manage your FoodieHub cart, open the Cart page. "
                    + "Review your selected items and quantities before checkout. "
                    + "If you describe the problem you're seeing, I can guide you through it.";
        }

        // Checkout
        if (containsAny(normalized,
                "checkout", "proceed to pay", "place order",
                "complete order", "delivery address")) {
            return "To place an order, review your cart, check your delivery address, "
                    + "and continue to checkout. Follow the payment options shown on the page "
                    + "to complete your order.";
        }

        // Payment
        if (containsAny(normalized,
                "payment", "razorpay", "upi", "cash on delivery",
                "cod", "credit card", "debit card", "transaction",
                "payment failed", "refund")) {
            return "For FoodieHub payments, select one of the payment methods "
                    + "actually displayed at checkout. If a payment fails, check its status "
                    + "before trying again. Never share your OTP, PIN, or password in chat.";
        }

        // Orders
        if (containsAny(normalized,
                "my order", "my orders", "order status",
                "track order", "order history", "cancel order",
                "delivered", "order confirmation")) {
            return "Open My Orders in FoodieHub to review your saved orders and their "
                    + "displayed statuses. Sign in if required. For a specific issue, "
                    + "describe what the page shows without sharing private account details.";
        }

        // Login and signup
        if (containsAny(normalized,
                "login", "log in", "sign in", "signup",
                "sign up", "register", "create account",
                "forgot password", "reset password", "change password")) {
            return "For account help, use the FoodieHub Login or Sign Up page. "
                    + "If you forgot your password, use the password-reset option "
                    + "provided by your application. Never share your password here.";
        }

        // Java and programming
        if (containsAny(normalized,
                "java", "javascript", "programming", "coding",
                "code", "program", "oops", "object oriented",
                "inheritance", "polymorphism", "encapsulation",
                "abstraction", "constructor", "array", "string",
                "exception handling", "collection", "jdbc",
                "servlet", "jsp", "tomcat", "mysql", "sql",
                "html", "css", "python", "debug")) {
            return "I can help with programming concepts, code examples, and debugging. "
                    + "Tell me the programming language, the concept or problem, "
                    + "and any error message you're getting. "
                    + "I'll give you a clear explanation and a practical example where possible.";
        }

        // Education and interview preparation
        if (containsAny(normalized,
                "interview", "placement", "exam", "study",
                "learn", "learning", "student", "college",
                "resume", "cv", "job", "career", "aptitude",
                "practice questions", "tcs", "nqt")) {
            return "I can help with study plans, interview preparation, aptitude practice, "
                    + "resume improvements, and career guidance. "
                    + "Tell me your target exam, role, or topic, and I'll suggest useful next steps.";
        }

        // Technology and AI
        if (containsAny(normalized,
                "artificial intelligence", " ai ", "machine learning",
                "deep learning", "technology", "computer",
                "software", "website", "web development",
                "app development", "database", "cloud computing",
                "cybersecurity", "robot", "chatbot")) {
            return "Technology is a broad topic, and I can help explain its basic concepts. "
                    + "Tell me which technology you're interested in and whether you want "
                    + "a beginner-friendly explanation, an example, or implementation guidance.";
        }

        // General knowledge and explanations
        if (containsAny(normalized,
                "what is", "what are", "who is", "who was",
                "why is", "why do", "how does", "how do",
                "how to", "explain", "meaning of", "define",
                "difference between", "compare")) {
            return buildQuestionGuidance(originalMessage);
        }

        // Recommendations and opinions
        if (containsAny(normalized,
                "recommend", "suggest", "best way",
                "which is better", "give me ideas",
                "suggestions", "advice", "help me choose")) {
            return "I can help you compare options and make a practical choice. "
                    + "Tell me your goal, budget or other requirements, "
                    + "and what options you're considering. "
                    + "I'll suggest useful factors and next steps.";
        }

        // Greetings and thanks
        if (containsAny(normalized,
                "thank you", "thanks", "thank u", "thx")) {
            return "You're welcome! 😊 I'm happy to help. "
                    + "What else would you like to know?";
        }

        // User expresses a problem
        if (containsAny(normalized,
                "not working", "problem", "issue", "error",
                "failed", "broken", "does not work", "doesn't work")) {
            return "Let's work through the problem step by step. "
                    + "Tell me what you were trying to do, what happened instead, "
                    + "and any error message you saw. "
                    + "I'll suggest a practical way to troubleshoot it.";
        }

        // Small talk
        if (containsAny(normalized,
                "how are you", "how are u", "are you fine",
                "are you good")) {
            return "I'm ready to help! 😊 "
                    + "Ask me a question about FoodieHub, learning, technology, "
                    + "food, or another topic you'd like to explore.";
        }

        // Helpful general fallback: no apology and no dead end.
        return "Here's how I can help with your question: "
                + "\"" + originalMessage + "\". "
                + "I can explain concepts, suggest ideas, outline steps, "
                + "and help troubleshoot problems. "
                + "To give you a more useful answer, add a little context "
                + "or tell me what result you're looking for.";
    }

    /**
     * Provides a more useful response to general question-style messages.
     */
    private String buildQuestionGuidance(String question) {

        String normalized = question.toLowerCase(Locale.ROOT);

        if (normalized.contains("how to")) {
            return "For \"" + question + "\", I can help you work through the steps. "
                    + "A good starting point is to identify your goal, the tools or "
                    + "information you already have, and any restrictions. "
                    + "Share those details and I can suggest a more specific procedure.";
        }

        if (normalized.contains("difference between")
                || normalized.contains("compare")) {
            return "To answer \"" + question + "\" usefully, we should compare "
                    + "the main purpose, advantages, limitations, and practical uses "
                    + "of the things involved. Tell me the specific options if the "
                    + "question needs more context.";
        }

        if (normalized.contains("what is")
                || normalized.contains("what are")
                || normalized.contains("define")
                || normalized.contains("meaning of")) {
            return "You're asking for an explanation of \"" + question + "\". "
                    + "I can help break a topic into its definition, how it works, "
                    + "a simple example, and its real-world uses. "
                    + "Add the subject or context if you want a more precise explanation.";
        }

        return "Let's look at your question: \"" + question + "\". "
                + "I can help explain the topic, identify the important points, "
                + "and suggest possible next steps. "
                + "A little more context will help me make the answer more relevant.";
    }

    /**
     * Checks whether a normalized message contains any listed phrase.
     */
    private boolean containsAny(String message, String... keywords) {

        String paddedMessage = " " + message + " ";

        for (String keyword : keywords) {
            String normalizedKeyword = keyword.trim().toLowerCase(Locale.ROOT);

            if (normalizedKeyword.isEmpty()) {
                continue;
            }

            if (paddedMessage.contains(" " + normalizedKeyword + " ")) {
                return true;
            }
        }

        return false;
    }

    private void writeReply(HttpServletResponse response, String reply)
            throws IOException {

        writeJson(response, "{\"reply\":\"" + escapeJson(reply) + "\"}");
    }

    private void writeJson(HttpServletResponse response, String json)
            throws IOException {

        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");
        response.getWriter().write(json);
    }

    /**
     * Escapes text safely for a JSON string value.
     */
    private String escapeJson(String value) {

        StringBuilder escaped = new StringBuilder();

        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);

            switch (c) {
                case '"':
                    escaped.append("\\\"");
                    break;
                case '\\':
                    escaped.append("\\\\");
                    break;
                case '\b':
                    escaped.append("\\b");
                    break;
                case '\f':
                    escaped.append("\\f");
                    break;
                case '\n':
                    escaped.append("\\n");
                    break;
                case '\r':
                    escaped.append("\\r");
                    break;
                case '\t':
                    escaped.append("\\t");
                    break;
                default:
                    if (c < 0x20) {
                        escaped.append(String.format("\\u%04x", (int) c));
                    } else {
                        escaped.append(c);
                    }
                    break;
            }
        }

        return escaped.toString();
    }
}
