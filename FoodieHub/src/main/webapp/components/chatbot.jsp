
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodieHub Chat Assistant</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: #f3fff7;
            background:
                radial-gradient(ellipse at top, #0b5638, transparent 55%),
                #031b13;
        }

        .chatbot-page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 18px clamp(16px, 5vw, 65px);
            background: rgba(0, 25, 17, .9);
            border-bottom: 1px solid rgba(105, 255, 172, .2);
        }

        .chatbot-brand {
            color: #f3fff7;
            text-decoration: none;
            font-size: 23px;
            font-weight: 800;
        }

        .chatbot-brand span {
            color: #ff6545;
        }

        .chatbot-back {
            padding: 11px 15px;
            border: 1px solid rgba(105, 255, 172, .35);
            border-radius: 10px;
            color: #caffd9;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
        }

        .chatbot-main {
            width: min(850px, 92%);
            margin: 65px auto;
            text-align: center;
        }

        .chatbot-icon {
            width: 95px;
            height: 95px;
            display: grid;
            place-items: center;
            margin: 0 auto 22px;
            border: 1px solid #64ffa0;
            border-radius: 28px;
            background: #0a3c29;
            box-shadow: 0 0 35px rgba(0, 237, 131, .15);
            font-size: 48px;
        }

        .chatbot-main h1 {
            margin: 0 0 15px;
            font-size: clamp(30px, 5vw, 48px);
        }

        .chatbot-main h1 span {
            color: #67ff9f;
        }

        .chatbot-main p {
            max-width: 610px;
            margin: 0 auto 25px;
            color: #b5d6c3;
            font-size: 15px;
            line-height: 1.8;
        }

        .chatbot-open-button {
            display: inline-block;
            padding: 14px 23px;
            border: 0;
            border-radius: 12px;
            background: linear-gradient(110deg, #91ffb0, #42ef7c);
            color: #00351e;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
        }

        .chatbot-test-note {
            margin-top: 35px;
            color: #8eb8a0;
            font-size: 12px;
            line-height: 1.7;
        }
    </style>
</head>

<body>

    <header class="chatbot-page-header">
        <a class="chatbot-brand" href="<%= cp %>/restaurant">
            Foodie<span>Hub</span>
        </a>

        <a class="chatbot-back" href="<%= cp %>/restaurant">
            ← Back to Restaurants
        </a>
    </header>

    <main class="chatbot-main">
        <div class="chatbot-icon" aria-hidden="true">🤖</div>

        <h1>Meet Your <span>FoodieHub Assistant</span></h1>

        <p>
            Need help finding restaurants, browsing menus, managing your cart,
            completing checkout, or reviewing orders? Open the assistant and
            ask your question.
        </p>

        <button type="button"
                class="chatbot-open-button"
                id="fh-chat-page-open">
            Start Chatting →
        </button>

        <div class="chatbot-test-note">
            This page uses the same floating chatbot widget as the rest of
            FoodieHub. The assistant provides rule-based responses.
        </div>
    </main>

    <!-- Include the widget exactly once on this page. -->
    <jsp:include page="/chatbot-widget.jsp" />

    <script>
        (function () {
            var openButton = document.getElementById("fh-chat-page-open");

            if (openButton) {
                openButton.addEventListener("click", function () {
                    var launcher = document.getElementById("fh-chat-launcher");

                    if (launcher) {
                        launcher.click();
                    }
                });
            }
        })();
    </script>

</body>
</html>
