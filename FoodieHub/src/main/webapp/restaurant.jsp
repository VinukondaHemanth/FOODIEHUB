
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>

<%!
    private String restaurantValue(Object bean, String getter) {
        if (bean == null) return "";
        try {
            Object value = bean.getClass().getMethod(getter).invoke(bean);
            return value == null ? "" : String.valueOf(value);
        } catch (Exception e) {
            return "";
        }
    }

    private String restaurantEscape(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String restaurantImageUrl(String imagePath, String contextPath) {
        if (imagePath == null || imagePath.trim().isEmpty()) {
            return "";
        }

        imagePath = imagePath.trim();

        if (imagePath.matches("(?i)^https?://.*")) {
            return imagePath;
        }

        if (!imagePath.startsWith("/")) {
            imagePath = "/" + imagePath;
        }

        return contextPath + imagePath;
    }
%>

<%
    String restaurantContextPath = request.getContextPath();

    List<?> restaurantList =
        (List<?>) request.getAttribute("restaurants");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#031b14">

    <title>FoodieHub | Discover Great Food</title>

    <style>
        :root {
            --fh-bg: #031b14;
            --fh-bg-light: #06291e;
            --fh-card: #082d21;
            --fh-card-light: #0b3828;
            --fh-green: #55f58a;
            --fh-green-light: #aaffbd;
            --fh-orange: #ff6545;
            --fh-text: #f3fff7;
            --fh-muted: #a9c8b7;
            --fh-border: rgba(114,255,163,.19);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            scroll-behavior: smooth;
            scroll-padding-top: 90px;
        }

        body {
            min-height: 100vh;
            overflow-x: hidden;
            color: var(--fh-text);
            font-family: "Segoe UI", Arial, Helvetica, sans-serif;
            background: radial-gradient(
                ellipse at 50% 0%,
                #08452d 0%,
                #04271c 35%,
                #031b14 78%
            );
        }

        button, input {
            font: inherit;
        }

        a {
            -webkit-tap-highlight-color: transparent;
        }

        ::selection {
            color: #032317;
            background: #7dffa5;
        }

        /* HERO SECTION */

        .fh-hero {
            position: relative;
            isolation: isolate;
            min-height: 540px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            padding: 75px 24px 80px;
            background: #03251a;
            border-bottom: 1px solid var(--fh-border);
        }

        .fh-hero-video {
            position: absolute;
            inset: 0;
            z-index: -3;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            pointer-events: none;
            background: #03251a;
        }

        .fh-hero-overlay {
            position: absolute;
            inset: 0;
            z-index: -2;
            background:
                linear-gradient(
                    90deg,
                    rgba(1,20,13,.68),
                    rgba(2,31,19,.35),
                    rgba(1,20,13,.60)
                ),
                linear-gradient(
                    0deg,
                    rgba(3,27,20,.97) 0%,
                    rgba(3,27,20,.18) 35%,
                    rgba(3,27,20,.22) 70%,
                    rgba(3,27,20,.63) 100%
                );
        }

        .fh-hero-glow {
            position: absolute;
            z-index: -1;
            width: 440px;
            height: 440px;
            top: 50%;
            left: 50%;
            transform: translate(-50%,-50%);
            border-radius: 50%;
            background: rgba(25,255,119,.10);
            filter: blur(100px);
            pointer-events: none;
        }

        .fh-hero-content {
            width: 100%;
            max-width: 900px;
            position: relative;
            z-index: 2;
            text-align: center;
            animation: fhHeroEntrance 1s cubic-bezier(.2,.8,.2,1) both;
        }

        @keyframes fhHeroEntrance {
            from { opacity: 0; transform: translateY(25px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fh-hero-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            margin-bottom: 26px;
            padding: 10px 17px;
            border: 1px solid rgba(118,255,164,.35);
            border-radius: 50px;
            background: rgba(4,41,26,.72);
            backdrop-filter: blur(10px);
            color: #c2ffd2;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.6px;
            text-transform: uppercase;
        }

        .fh-live-dot {
            width: 8px;
            height: 8px;
            flex-shrink: 0;
            border-radius: 50%;
            background: var(--fh-green);
            box-shadow: 0 0 13px var(--fh-green);
            animation: fhDotPulse 1.7s ease-in-out infinite;
        }

        @keyframes fhDotPulse {
            50% {
                box-shadow:
                    0 0 0 7px rgba(85,245,138,.08),
                    0 0 20px var(--fh-green);
            }
        }

        .fh-hero h1 {
            max-width: 850px;
            margin: 0 auto 20px;
            color: #fff;
            font-family: Georgia, "Times New Roman", serif;
            font-size: clamp(45px,6.2vw,76px);
            font-weight: 800;
            line-height: 1.08;
            letter-spacing: -1.9px;
            text-shadow: 0 4px 24px rgba(0,0,0,.42);
        }

        .fh-hero h1 .fh-highlight {
            color: var(--fh-green-light);
            text-shadow: 0 0 32px rgba(85,245,138,.22);
        }

        .fh-hero-description {
            max-width: 650px;
            margin: 0 auto;
            color: #e0f0e5;
            font-size: 16px;
            line-height: 1.85;
            text-shadow: 0 2px 12px rgba(0,0,0,.5);
        }

        .fh-hero-actions {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: center;
            gap: 13px;
            margin-top: 32px;
        }

        .fh-hero-button {
            min-height: 49px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 13px 22px;
            border-radius: 12px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 800;
            transition: transform .25s, box-shadow .25s, background .25s;
        }

        .fh-hero-button-primary {
            color: #032317;
            background: linear-gradient(110deg,#9dffb2,#42f481,#6bffa5);
            border: 1px solid #aaffbd;
            box-shadow:
                0 0 25px rgba(66,244,129,.23),
                inset 0 1px rgba(255,255,255,.7);
        }

        .fh-hero-button-secondary {
            color: #f0fff4;
            background: rgba(3,30,20,.65);
            border: 1px solid rgba(180,255,202,.40);
            backdrop-filter: blur(10px);
        }

        .fh-hero-button:hover {
            transform: translateY(-3px);
        }

        .fh-hero-button-primary:hover {
            box-shadow: 0 8px 32px rgba(66,244,129,.34);
        }

        .fh-hero-button-secondary:hover {
            background: rgba(12,73,42,.85);
        }

        /* BENEFITS */

        .fh-benefits {
            position: relative;
            z-index: 3;
            max-width: 1120px;
            width: calc(100% - 40px);
            display: grid;
            grid-template-columns: repeat(3,minmax(0,1fr));
            gap: 13px;
            margin: -28px auto 0;
        }

        .fh-benefit {
            min-height: 76px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 15px;
            border: 1px solid var(--fh-border);
            border-radius: 15px;
            background: linear-gradient(140deg,rgba(8,52,35,.97),rgba(4,34,24,.98));
            box-shadow: 0 12px 30px rgba(0,0,0,.18);
            backdrop-filter: blur(15px);
            transition: transform .25s,border-color .25s,box-shadow .25s;
        }

        .fh-benefit:hover {
            transform: translateY(-4px);
            border-color: rgba(95,255,147,.42);
            box-shadow: 0 15px 30px rgba(0,0,0,.23);
        }

        .fh-benefit-icon {
            width: 41px;
            height: 41px;
            flex-shrink: 0;
            display: grid;
            place-items: center;
            border-radius: 12px;
            border: 1px solid rgba(102,255,151,.24);
            background: rgba(45,195,94,.12);
            font-size: 19px;
        }

        .fh-benefit strong {
            display: block;
            margin-bottom: 4px;
            color: #f2fff6;
            font-size: 13px;
        }

        .fh-benefit small {
            display: block;
            color: var(--fh-muted);
            font-size: 11px;
            line-height: 1.5;
        }

        /* RESTAURANT SECTION */

        .fh-restaurant-section {
            max-width: 1320px;
            margin: 0 auto;
            padding: 65px 28px 85px;
        }

        .fh-section-heading {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 27px;
        }

        .fh-section-eyebrow {
            display: block;
            margin-bottom: 9px;
            color: var(--fh-green);
            font-size: 10px;
            font-weight: 850;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .fh-section-heading h2 {
            margin-bottom: 9px;
            color: #f5fff7;
            font-family: Georgia, "Times New Roman", serif;
            font-size: clamp(29px,4vw,40px);
            letter-spacing: -.7px;
        }

        .fh-section-heading p {
            max-width: 600px;
            color: var(--fh-muted);
            font-size: 13px;
            line-height: 1.8;
        }

        .fh-restaurant-count {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            flex-shrink: 0;
            padding: 10px 13px;
            border: 1px solid var(--fh-border);
            border-radius: 10px;
            background: rgba(8,52,35,.7);
            color: #caffd7;
            font-size: 11px;
            font-weight: 750;
        }

        .fh-restaurant-count span {
            color: var(--fh-green);
        }

        .fh-restaurant-grid {
            display: grid;
            grid-template-columns: repeat(3,minmax(0,1fr));
            gap: 22px;
        }

        /* RESTAURANT CARD */

        .fh-restaurant-card {
            position: relative;
            min-width: 0;
            overflow: hidden;
            border: 1px solid rgba(117,255,163,.18);
            border-radius: 18px;
            background: linear-gradient(145deg,rgba(9,48,34,.98),rgba(4,29,21,.98));
            box-shadow: 0 10px 28px rgba(0,0,0,.16);
            animation: fhCardEntrance .65s ease both;
            transition: transform .32s,border-color .32s,box-shadow .32s;
        }

        .fh-restaurant-card:hover {
            transform: translateY(-7px);
            border-color: rgba(100,255,151,.52);
            box-shadow:
                0 20px 45px rgba(0,0,0,.26),
                0 0 27px rgba(54,255,122,.08);
        }

        @keyframes fhCardEntrance {
            from { opacity: 0; transform: translateY(22px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fh-restaurant-image-wrap {
            position: relative;
            height: 220px;
            overflow: hidden;
            background: #123d2b;
        }

        .fh-restaurant-image-wrap::after {
            content: "";
            position: absolute;
            inset: 0;
            pointer-events: none;
            background: linear-gradient(0deg,rgba(2,20,14,.65),transparent 58%);
        }

        .fh-restaurant-image {
            width: 100%;
            height: 100%;
            display: block;
            object-fit: cover;
            object-position: center;
            transition: transform .55s;
        }

        .fh-restaurant-card:hover .fh-restaurant-image {
            transform: scale(1.075);
        }

        .fh-image-fallback {
            width: 100%;
            height: 100%;
            display: grid;
            place-items: center;
            color: #c6ffd4;
            font-size: 55px;
            background: radial-gradient(circle at 35% 30%,#216747,#0a3826 65%,#06251b);
        }

        .fh-delivery-badge {
            position: absolute;
            z-index: 2;
            right: 12px;
            bottom: 12px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 10px;
            border: 1px solid rgba(155,255,184,.24);
            border-radius: 9px;
            background: rgba(3,32,21,.89);
            backdrop-filter: blur(8px);
            color: #d9ffe3;
            font-size: 11px;
            font-weight: 800;
        }

        .fh-restaurant-info {
            padding: 18px;
        }

        .fh-restaurant-topline {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 10px;
        }

        .fh-restaurant-name {
            min-width: 0;
            margin-bottom: 9px;
            color: #f4fff7;
            font-size: 19px;
            font-weight: 800;
            line-height: 1.35;
            overflow-wrap: anywhere;
        }

        .fh-rating {
            flex-shrink: 0;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 8px;
            border: 1px solid rgba(111,255,154,.2);
            border-radius: 8px;
            background: rgba(42,183,87,.14);
            color: #caffd7;
            font-size: 11px;
            font-weight: 850;
        }

        .fh-rating-star {
            color: #c8ff70;
        }

        .fh-cuisine {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-bottom: 12px;
            color: var(--fh-green-light);
            font-size: 11px;
            font-weight: 750;
        }

        .fh-cuisine-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--fh-green);
            box-shadow: 0 0 8px rgba(85,245,138,.45);
        }

        .fh-restaurant-address {
            min-height: 39px;
            margin-bottom: 17px;
            color: var(--fh-muted);
            font-size: 12px;
            line-height: 1.65;
            overflow-wrap: anywhere;
        }

        .fh-restaurant-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding-top: 14px;
            border-top: 1px solid rgba(123,236,157,.13);
        }

        .fh-fresh-label {
            display: flex;
            align-items: center;
            gap: 7px;
            color: #b9d7c4;
            font-size: 10px;
            font-weight: 700;
        }

        .fh-fresh-icon {
            color: var(--fh-green);
            font-size: 14px;
        }

        .fh-view-menu {
            min-height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            flex-shrink: 0;
            padding: 10px 13px;
            border: 1px solid rgba(163,255,187,.55);
            border-radius: 10px;
            background: linear-gradient(110deg,#82ffa1,#42ef7c);
            color: #032317;
            font-size: 12px;
            font-weight: 850;
            text-decoration: none;
            box-shadow: 0 0 16px rgba(60,246,123,.10);
            transition: transform .22s,box-shadow .22s,filter .22s;
        }

        .fh-view-menu:hover {
            transform: translateY(-2px);
            filter: brightness(1.05);
            box-shadow: 0 7px 24px rgba(60,246,123,.2);
        }

        .fh-view-menu:focus-visible,
        .fh-hero-button:focus-visible {
            outline: 2px solid #d3ffde;
            outline-offset: 4px;
        }

        /* EMPTY STATE */

        .fh-empty-state {
            grid-column: 1 / -1;
            padding: 55px 22px;
            text-align: center;
            border: 1px dashed rgba(114,255,163,.28);
            border-radius: 18px;
            background: rgba(7,44,30,.65);
        }

        .fh-empty-icon {
            width: 75px;
            height: 75px;
            display: grid;
            place-items: center;
            margin: 0 auto 17px;
            border: 1px solid var(--fh-border);
            border-radius: 22px;
            background: rgba(45,194,96,.12);
            font-size: 33px;
        }

        .fh-empty-state h3 {
            margin-bottom: 10px;
            color: #f2fff6;
            font-size: 21px;
        }

        .fh-empty-state p {
            max-width: 520px;
            margin: 0 auto;
            color: var(--fh-muted);
            font-size: 13px;
            line-height: 1.8;
        }

        /* BOTTOM CTA */

        .fh-bottom-cta {
            max-width: 1264px;
            margin: 0 auto 60px;
            padding: 0 28px;
        }

        .fh-cta-inner {
            position: relative;
            overflow: hidden;
            padding: 30px 35px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 22px;
            border: 1px solid rgba(112,255,158,.24);
            border-radius: 18px;
            background:
                radial-gradient(ellipse at 90% 10%,rgba(47,219,111,.13),transparent 45%),
                linear-gradient(120deg,#082f21,#05251a);
        }

        .fh-cta-inner h2 {
            margin-bottom: 9px;
            font-family: Georgia, "Times New Roman", serif;
            font-size: clamp(23px,3vw,31px);
        }

        .fh-cta-inner h2 span {
            color: var(--fh-green);
        }

        .fh-cta-inner p {
            max-width: 620px;
            color: var(--fh-muted);
            font-size: 12px;
            line-height: 1.8;
        }

        .fh-cta-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            flex-shrink: 0;
            padding: 13px 18px;
            border: 1px solid rgba(154,255,180,.4);
            border-radius: 11px;
            background: rgba(38,187,88,.14);
            color: #c8ffd5;
            font-size: 12px;
            font-weight: 800;
            text-decoration: none;
            transition: background .25s,transform .25s;
        }

        .fh-cta-button:hover {
            transform: translateY(-2px);
            background: rgba(38,187,88,.25);
        }

        /* FOOTER */

        .fh-footer {
            padding: 25px 20px;
            border-top: 1px solid rgba(112,255,158,.14);
            text-align: center;
            color: #89ad99;
            font-size: 11px;
            line-height: 1.8;
        }

        .fh-footer strong {
            color: #c6ffd5;
        }

        .fh-footer span {
            color: var(--fh-orange);
        }

        /* RESPONSIVE */

        @media (max-width: 1050px) {
            .fh-restaurant-grid {
                grid-template-columns: repeat(2,minmax(0,1fr));
            }

            .fh-hero {
                min-height: 500px;
            }
        }

        @media (max-width: 700px) {
            .fh-hero {
                min-height: 480px;
                padding: 65px 20px 75px;
            }

            .fh-hero h1 {
                font-size: clamp(40px,9vw,59px);
                letter-spacing: -.8px;
            }

            .fh-hero-description {
                font-size: 14px;
            }

            .fh-hero-badge {
                font-size: 9px;
                letter-spacing: 1px;
            }

            .fh-benefits {
                grid-template-columns: 1fr;
                width: calc(100% - 32px);
                gap: 9px;
                margin-top: -23px;
            }

            .fh-benefit {
                min-height: 65px;
                justify-content: flex-start;
                padding: 11px 14px;
            }

            .fh-benefit-icon {
                width: 38px;
                height: 38px;
            }

            .fh-restaurant-section {
                padding: 48px 17px 60px;
            }

            .fh-section-heading {
                align-items: flex-start;
                flex-direction: column;
            }

            .fh-restaurant-grid {
                grid-template-columns: 1fr;
                gap: 17px;
            }

            .fh-restaurant-image-wrap {
                height: 235px;
            }

            .fh-cta-inner {
                align-items: flex-start;
                flex-direction: column;
                padding: 25px 21px;
            }

            .fh-bottom-cta {
                padding: 0 17px;
                margin-bottom: 40px;
            }
        }

        @media (max-width: 400px) {
            .fh-hero {
                min-height: 450px;
                padding: 55px 15px 65px;
            }

            .fh-hero h1 {
                font-size: 38px;
            }

            .fh-hero-actions {
                flex-direction: column;
                width: 100%;
            }

            .fh-hero-button {
                width: 100%;
                max-width: 260px;
            }

            .fh-restaurant-info {
                padding: 14px;
            }

            .fh-restaurant-name {
                font-size: 17px;
            }

            .fh-restaurant-image-wrap {
                height: 205px;
            }

            .fh-fresh-label {
                font-size: 9px;
            }

            .fh-view-menu {
                padding: 9px 10px;
                font-size: 11px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: .01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: .01ms !important;
                scroll-behavior: auto !important;
            }
        }
    </style>
</head>

<body>

    <!-- SHARED FOODIEHUB NAVBAR -->
    <%@ include file="components/navbar.jsp" %>

    <main>

        <!-- HERO WITH CONTINUOUS BACKGROUND VIDEO -->
        <section class="fh-hero">

            <video
                id="fhHeroVideo"
                class="fh-hero-video"
                autoplay
                muted
                playsinline
                preload="auto"
                aria-hidden="true">

                <source
                    src="<%= restaurantContextPath %>/videos/one.mp4"
                    type="video/mp4">
            </video>

            <div class="fh-hero-overlay"></div>
            <div class="fh-hero-glow"></div>

            <div class="fh-hero-content">

                <div class="fh-hero-badge">
                    <span class="fh-live-dot"></span>
                    Fresh flavours · Delivered with love
                </div>

                <h1>
                    Good Food.<br>
                    <span class="fh-highlight">Brighter Moods.</span>
                </h1>

                <p class="fh-hero-description">
                    Discover amazing restaurants, explore authentic flavours,
                    and enjoy your favourite meals delivered to your doorstep.
                    Your next delicious experience starts here.
                </p>

                <div class="fh-hero-actions">
                    <a href="#restaurants"
                       class="fh-hero-button fh-hero-button-primary">
                        Explore Restaurants
                        <span aria-hidden="true">&#8594;</span>
                    </a>

                    <a href="<%= restaurantContextPath %>/orders"
                       class="fh-hero-button fh-hero-button-secondary">
                        &#9776; &nbsp; My Orders
                    </a>
                </div>

            </div>
        </section>

        <!-- QUICK BENEFITS -->
        <section class="fh-benefits" aria-label="FoodieHub benefits">

            <div class="fh-benefit">
                <div class="fh-benefit-icon" aria-hidden="true">&#128666;</div>
                <div>
                    <strong>Quick Delivery</strong>
                    <small>Your favourite food, brought to you</small>
                </div>
            </div>

            <div class="fh-benefit">
                <div class="fh-benefit-icon" aria-hidden="true">&#11088;</div>
                <div>
                    <strong>Restaurants You Love</strong>
                    <small>Discover delicious local favourites</small>
                </div>
            </div>

            <div class="fh-benefit">
                <div class="fh-benefit-icon" aria-hidden="true">&#127860;</div>
                <div>
                    <strong>Made for Food Lovers</strong>
                    <small>Find something tasty for every craving</small>
                </div>
            </div>

        </section>

        <!-- RESTAURANTS FROM EXISTING DATABASE -->
        <section class="fh-restaurant-section" id="restaurants">

            <div class="fh-section-heading">
                <div>
                    <span class="fh-section-eyebrow">
                        DISCOVER YOUR NEXT FAVOURITE
                    </span>

                    <h2>
                        Explore Restaurants<span style="color:var(--fh-green)">.</span>
                    </h2>

                    <p>
                        From comforting South Indian classics to flavour-packed
                        meals, find a restaurant that makes your day delicious.
                    </p>
                </div>

                <div class="fh-restaurant-count">
                    <span>&#10022;</span>
                    Your food journey starts here
                </div>
            </div>

            <div class="fh-restaurant-grid">

                <%
                    int restaurantCount = 0;

                    if (restaurantList != null && !restaurantList.isEmpty()) {

                        int cardIndex = 0;

                        for (Object restaurant : restaurantList) {

                            String id = restaurantValue(
                                restaurant, "getRestaurantId");

                            String name = restaurantValue(
                                restaurant, "getName");

                            String address = restaurantValue(
                                restaurant, "getAddress");

                            String delivery = restaurantValue(
                                restaurant, "getDeliveryTime");

                            String cuisine = restaurantValue(
                                restaurant, "getCuisineType");

                            String rating = restaurantValue(
                                restaurant, "getRating");

                            String imagePath = restaurantValue(
                                restaurant, "getImagePath");

                            String imageUrl = restaurantImageUrl(
                                imagePath, restaurantContextPath);

                            if (name.trim().isEmpty()) {
                                name = "FoodieHub Restaurant";
                            }

                            if (address.trim().isEmpty()) {
                                address = "Address details unavailable";
                            }

                            if (cuisine.trim().isEmpty()) {
                                cuisine = "Delicious food";
                            }

                            if (delivery.trim().isEmpty()) {
                                delivery = "Delivery available";
                            }

                            String menuUrl =
                                restaurantContextPath
                                + "/menu?restaurantId="
                                + URLEncoder.encode(id, "UTF-8");
                %>

                <article class="fh-restaurant-card"
                         style="animation-delay:<%= cardIndex * 0.07 %>s">

                    <div class="fh-restaurant-image-wrap">

                        <% if (!imageUrl.isEmpty()) { %>

                            <img
                                class="fh-restaurant-image"
                                src="<%= restaurantEscape(imageUrl) %>"
                                alt="<%= restaurantEscape(name) %>"
                                loading="lazy"
                                onerror="this.style.display='none';this.nextElementSibling.style.display='grid';">

                            <div class="fh-image-fallback"
                                 style="display:none"
                                 aria-hidden="true">
                                &#127860;
                            </div>

                        <% } else { %>

                            <div class="fh-image-fallback" aria-hidden="true">
                                &#127860;
                            </div>

                        <% } %>

                        <div class="fh-delivery-badge">
                            <span aria-hidden="true">&#128666;</span>
                            <%= restaurantEscape(delivery) %>
                        </div>

                    </div>

                    <div class="fh-restaurant-info">

                        <div class="fh-restaurant-topline">

                            <h3 class="fh-restaurant-name">
                                <%= restaurantEscape(name) %>
                            </h3>

                            <% if (!rating.trim().isEmpty()) { %>
                                <span class="fh-rating">
                                    <span class="fh-rating-star">&#9733;</span>
                                    <%= restaurantEscape(rating) %>
                                </span>
                            <% } %>

                        </div>

                        <div class="fh-cuisine">
                            <span class="fh-cuisine-dot"></span>
                            <%= restaurantEscape(cuisine) %>
                        </div>

                        <p class="fh-restaurant-address">
                            <span aria-hidden="true">&#128205;</span>
                            <%= restaurantEscape(address) %>
                        </p>

                        <div class="fh-restaurant-footer">

                            <div class="fh-fresh-label">
                                <span class="fh-fresh-icon">&#10022;</span>
                                Made with care
                            </div>

                            <a class="fh-view-menu"
                               href="<%= menuUrl %>">
                                View Menu
                                <span aria-hidden="true">&#8594;</span>
                            </a>

                        </div>
                    </div>
                </article>

                <%
                            cardIndex++;
                            restaurantCount++;
                        }

                    } else {
                %>

                    <div class="fh-empty-state">
                        <div class="fh-empty-icon" aria-hidden="true">
                            &#127860;
                        </div>

                        <h3>No restaurants available yet</h3>

                        <p>
                            We couldn't find any restaurants to display.
                            Check your database records and make sure
                            RestaurantController is loading the restaurant list.
                        </p>
                    </div>

                <% } %>

            </div>
        </section>

        <!-- BOTTOM CALL TO ACTION -->
        <section class="fh-bottom-cta">
            <div class="fh-cta-inner">

                <div>
                    <h2>
                        Hungry already?
                        <span>Let's fix that.</span>
                    </h2>

                    <p>
                        Explore the restaurants above, choose your favourite
                        dishes, and build your next FoodieHub meal.
                    </p>
                </div>

                <a href="#restaurants" class="fh-cta-button">
                    Find Your Food
                    <span aria-hidden="true">&#8594;</span>
                </a>

            </div>
        </section>

    </main>

    <!-- FOOTER -->
    <footer class="fh-footer">
        Crafted for food lovers with <span>&#10084;</span>
        by <strong>FoodieHub</strong>.
    </footer>

    <!-- FOOD VIDEO PLAYLIST: one.mp4 -> two.mp4 -> repeat -->
    <script>
        (function () {
            "use strict";

            const video = document.getElementById("fhHeroVideo");

            if (!video) {
                return;
            }

            const contextPath = "<%= restaurantContextPath %>";

            const videoPlaylist = [
                contextPath + "/videos/one.mp4",
                contextPath + "/videos/two.mp4"
            ];

            let currentVideoIndex = 0;
            let switchingVideo = false;

            function keepVideoMuted() {
                video.muted = true;
                video.defaultMuted = true;
                video.volume = 0;
            }

            function playCurrentVideo() {
                switchingVideo = false;
                keepVideoMuted();

                video.src = videoPlaylist[currentVideoIndex];
                video.load();

                const playPromise = video.play();

                if (playPromise !== undefined) {
                    playPromise.catch(function (error) {
                        console.warn(
                            "FoodieHub background video could not autoplay.",
                            "Check the video path and browser autoplay settings.",
                            error
                        );
                    });
                }
            }

            video.addEventListener("ended", function () {
                if (switchingVideo) {
                    return;
                }

                switchingVideo = true;
                currentVideoIndex =
                    (currentVideoIndex + 1) % videoPlaylist.length;

                playCurrentVideo();
            });

            video.addEventListener("volumechange", keepVideoMuted);

            video.addEventListener("error", function () {
                console.error(
                    "FoodieHub background video failed to load:",
                    video.currentSrc,
                    video.error
                );
            });

            document.addEventListener("visibilitychange", function () {
                if (!document.hidden && !switchingVideo && video.paused) {
                    keepVideoMuted();

                    const playPromise = video.play();

                    if (playPromise !== undefined) {
                        playPromise.catch(function () {
                            // Browser may require a user gesture.
                        });
                    }
                }
            });

            playCurrentVideo();
        })();
    </script>

    <!-- FOODIEHUB CHATBOT WIDGET -->
    <%-- Chatbot widget is already included by components/navbar.jsp. --%>

</body>
</html>
