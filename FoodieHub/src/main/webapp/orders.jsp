
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Menu" %>

<%!
    private String ordersEscape(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String ordersStatusClass(String status) {
        if (status == null) {
            return "status-processing";
        }

        String s = status.trim().toLowerCase(Locale.ROOT);

        if (s.contains("deliver")) {
            return "status-delivered";
        }

        if (s.contains("cancel")) {
            return "status-cancelled";
        }

        if (s.contains("way") || s.contains("picked")) {
            return "status-ontheway";
        }

        if (s.contains("place") || s.contains("confirm")
                || s.contains("prepar")) {
            return "status-preparing";
        }

        return "status-processing";
    }
%>

<%
    String ordersContextPath = request.getContextPath();

    User ordersLoggedInUser =
        (User) session.getAttribute("loggedInUser");

    if (ordersLoggedInUser == null) {
        response.sendRedirect(ordersContextPath + "/login.jsp");
        return;
    }

    List<Order> ordersList =
        (List<Order>) request.getAttribute("orders");

    Map<Integer, List<OrderItem>> orderItemsMap =
        (Map<Integer, List<OrderItem>>)
            request.getAttribute("orderItemsMap");

    Map<Integer, Restaurant> restaurantsMap =
        (Map<Integer, Restaurant>)
            request.getAttribute("restaurantsMap");

    Map<Integer, Menu> menusMap =
        (Map<Integer, Menu>)
            request.getAttribute("menusMap");

    if (ordersList == null) {
        ordersList = new ArrayList<Order>();
    }

    int totalOrders = ordersList.size();
    int deliveredCount = 0;
    int cancelledCount = 0;

    for (Order countedOrder : ordersList) {
        String status = countedOrder.getStatus() == null
            ? ""
            : countedOrder.getStatus().toLowerCase(Locale.ROOT);

        if (status.contains("cancel")) {
            cancelledCount++;
        } else if (status.contains("deliver")) {
            deliveredCount++;
        }
    }

    String displayName = ordersLoggedInUser.getUsername() == null
        ? "FoodieHub User"
        : ordersLoggedInUser.getUsername();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Orders | FoodieHub</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap"
          rel="stylesheet">

    <style>
        :root {
            --bg: #001a12;
            --panel: #05291e;
            --panel2: #073525;
            --green: #00ed83;
            --bright: #6dffb0;
            --text: #f3fff8;
            --muted: #9bb9aa;
            --border: rgba(105, 255, 172, 0.17);
            --red: #ff625f;
            --gold: #ffd56b;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            scroll-behavior: smooth;
            scroll-padding-top: 110px;
        }

        body {
            min-height: 100vh;
            overflow-x: hidden;
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            background:
                radial-gradient(
                    ellipse at 8% 12%,
                    rgba(0, 237, 131, 0.08),
                    transparent 30%
                ),
                radial-gradient(
                    ellipse at 92% 40%,
                    rgba(0, 180, 100, 0.06),
                    transparent 32%
                ),
                var(--bg);
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        button {
            font: inherit;
        }

        .orders-hero {
            position: relative;
            overflow: hidden;
            padding: 44px 6% 38px;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(
                120deg,
                rgba(0, 237, 131, 0.07),
                rgba(0, 20, 14, 0.1)
            );
        }

        .hero-inner,
        .orders-container {
            width: 88%;
            max-width: 1320px;
            margin: 0 auto;
        }

        .breadcrumb {
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 2px;
            color: var(--muted);
            margin-bottom: 14px;
        }

        .breadcrumb span {
            color: var(--green);
        }

        .hero-layout {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 25px;
        }

        .orders-hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(36px, 4.2vw, 55px);
            line-height: 1.08;
            letter-spacing: -1px;
        }

        .orders-hero h1 span {
            color: var(--green);
        }

        .orders-hero p {
            color: var(--muted);
            font-size: 14px;
            line-height: 1.7;
            margin-top: 12px;
            max-width: 580px;
        }

        .hero-art {
            font-size: 70px;
            filter: drop-shadow(
                0 0 18px rgba(0, 237, 131, 0.18)
            );
            animation: float 4s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0) rotate(-4deg);
            }

            50% {
                transform: translateY(-9px) rotate(4deg);
            }
        }

        .orders-container {
            padding: 32px 0 70px;
            position: relative;
            min-height: 200px;
            overflow: visible;
        }

        .section-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .section-heading h2 {
            font-size: 23px;
            font-weight: 800;
            letter-spacing: -0.4px;
        }

        .section-heading p {
            font-size: 13px;
            color: var(--muted);
            margin-top: 6px;
        }

        .primary-btn,
        .secondary-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 12px 17px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 800;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .primary-btn {
            color: #002318;
            background: linear-gradient(
                135deg,
                #00ed83,
                #71ff9c
            );
            box-shadow: 0 7px 22px rgba(0, 237, 131, 0.13);
        }

        .primary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(0, 237, 131, 0.22);
        }

        .secondary-btn {
            border: 1px solid var(--border);
            background: rgba(0, 237, 131, 0.04);
            color: var(--bright);
        }

        .order-filters {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            padding: 8px;
            background: rgba(4, 40, 29, 0.8);
            border: 1px solid var(--border);
            border-radius: 15px;
            margin-bottom: 23px;
            width: fit-content;
            max-width: 100%;
        }

        .filter-btn {
            border: 1px solid transparent;
            background: transparent;
            color: var(--muted);
            padding: 10px 15px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
            transition: 0.2s;
        }

        .filter-btn:hover {
            color: var(--text);
            background: rgba(255, 255, 255, 0.04);
        }

        .filter-btn.active {
            background: linear-gradient(
                135deg,
                #00ed83,
                #6dffb0
            );
            color: #002318;
            box-shadow: 0 4px 14px rgba(0, 237, 131, 0.12);
        }

        .filter-count {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 19px;
            height: 19px;
            margin-left: 5px;
            padding: 0 5px;
            border-radius: 20px;
            background: rgba(0, 0, 0, 0.15);
            font-size: 10px;
        }

        /* IMPORTANT: Keep the order list and cards visible. */
        .orders-list {
            display: grid !important;
            grid-template-columns: minmax(0, 1fr);
            gap: 16px;
            width: 100%;
            min-width: 0;
            visibility: visible !important;
            opacity: 1 !important;
            overflow: visible;
        }

        .orders-list > .order-card {
            display: block !important;
            position: relative;
            width: 100%;
            min-width: 0;
            height: auto;
            min-height: 100px;
            visibility: visible !important;
            opacity: 1 !important;
            overflow: visible;
            color: var(--text);
            background: linear-gradient(
                145deg,
                rgba(5, 41, 30, 0.97),
                rgba(2, 29, 21, 0.97)
            );
            border: 1px solid var(--border);
            border-radius: 19px;
            box-shadow: 0 12px 34px rgba(0, 0, 0, 0.12);
            animation: appear 0.4s ease both;
            transition: border-color 0.25s, transform 0.25s;
        }

        .orders-list > .order-card:hover {
            border-color: rgba(0, 237, 131, 0.36);
            transform: translateY(-2px);
        }

        @keyframes appear {
            from {
                opacity: 0;
                transform: translateY(10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .order-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            padding: 19px 22px;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(
                100deg,
                rgba(0, 237, 131, 0.055),
                transparent
            );
        }

        .order-main {
            display: flex;
            align-items: center;
            gap: 13px;
            min-width: 0;
        }

        .order-food-icon {
            width: 57px;
            height: 57px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 14px;
            background: linear-gradient(145deg, #0c4b35, #06281d);
            border: 1px solid var(--border);
            font-size: 29px;
        }

        .order-number {
            font-size: 10px;
            letter-spacing: 1.5px;
            color: var(--bright);
            font-weight: 800;
            margin-bottom: 5px;
        }

        .order-top h3 {
            font-size: 18px;
            font-weight: 800;
            overflow-wrap: anywhere;
        }

        .order-date {
            font-size: 12px;
            color: var(--muted);
            margin-top: 5px;
        }

        .order-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
            padding: 8px 11px;
            border-radius: 30px;
            font-size: 11px;
            font-weight: 800;
            border: 1px solid transparent;
            text-transform: capitalize;
        }

        .order-status::before {
            content: "";
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: currentColor;
        }

        .status-preparing {
            background: rgba(255, 213, 107, 0.1);
            color: var(--gold);
            border-color: rgba(255, 213, 107, 0.2);
        }

        .status-ontheway {
            background: rgba(61, 177, 255, 0.1);
            color: #7bcaff;
            border-color: rgba(61, 177, 255, 0.2);
        }

        .status-delivered {
            background: rgba(0, 237, 131, 0.1);
            color: var(--bright);
            border-color: rgba(0, 237, 131, 0.2);
        }

        .status-cancelled {
            background: rgba(255, 98, 95, 0.1);
            color: #ff8582;
            border-color: rgba(255, 98, 95, 0.2);
        }

        .status-processing {
            background: rgba(175, 190, 181, 0.1);
            color: #c4d8cd;
            border-color: rgba(175, 190, 181, 0.2);
        }

        .order-summary {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 17px 22px;
            flex-wrap: wrap;
        }

        .restaurant-mark {
            width: 43px;
            height: 43px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            background: rgba(0, 237, 131, 0.09);
            border: 1px solid var(--border);
            font-size: 22px;
        }

        .restaurant-info {
            flex: 1;
            min-width: 130px;
        }

        .restaurant-info h4 {
            font-size: 14px;
            margin-bottom: 4px;
        }

        .restaurant-info p {
            font-size: 12px;
            color: var(--muted);
            overflow-wrap: anywhere;
        }

        .summary-total {
            text-align: right;
            margin-left: auto;
        }

        .summary-total small {
            display: block;
            color: var(--muted);
            font-size: 10px;
            letter-spacing: 1px;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .summary-total strong {
            font-size: 20px;
            color: var(--bright);
            font-weight: 800;
            white-space: nowrap;
        }

        .view-details,
        .track-order-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 800;
            cursor: pointer;
            white-space: nowrap;
            transition: 0.2s;
        }

        .view-details {
            border: 1px solid var(--green);
            background: transparent;
            color: var(--bright);
        }

        .view-details:hover {
            background: var(--green);
            color: #002318;
        }

        .track-order-btn {
            border: 1px solid rgba(0, 237, 131, 0.35);
            background: linear-gradient(120deg, #00ed83, #6dffb0);
            color: #002318;
        }

        .track-order-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0, 237, 131, 0.18);
        }

        .order-details {
            display: none;
            padding: 0 22px 20px;
        }

        .order-card.expanded .order-details {
            display: block;
            animation: appear 0.25s ease;
        }

        .details-divider {
            height: 1px;
            background: var(--border);
            margin-bottom: 15px;
        }

        .details-heading {
            font-size: 10px;
            letter-spacing: 1.5px;
            font-weight: 800;
            color: var(--muted);
            margin-bottom: 8px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 11px 0;
            border-bottom: 1px dashed rgba(105, 255, 172, 0.12);
        }

        .detail-item:last-of-type {
            border-bottom: 0;
        }

        .detail-name {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 0;
        }

        .item-symbol {
            width: 34px;
            height: 34px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 10px;
            background: rgba(0, 237, 131, 0.07);
            font-size: 18px;
        }

        .detail-name strong {
            display: block;
            font-size: 12px;
            overflow-wrap: anywhere;
        }

        .detail-name small {
            display: block;
            color: var(--muted);
            font-size: 10px;
            margin-top: 4px;
        }

        .detail-price {
            font-size: 12px;
            font-weight: 800;
            white-space: nowrap;
        }

        .order-meta {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 14px;
            padding: 13px 14px;
            background: rgba(0, 0, 0, 0.13);
            border: 1px solid rgba(105, 255, 172, 0.1);
            border-radius: 11px;
        }

        .order-meta span {
            font-size: 11px;
            color: var(--muted);
        }

        .order-meta strong {
            color: var(--text);
            font-weight: 700;
        }

        .empty-state {
            padding: 55px 24px;
            text-align: center;
            border: 1px solid var(--border);
            border-radius: 22px;
            background: linear-gradient(145deg, #05291e, #021d15);
        }

        .empty-illustration {
            width: 95px;
            height: 95px;
            display: grid;
            place-items: center;
            margin: 0 auto 20px;
            border-radius: 50%;
            font-size: 44px;
            background: radial-gradient(
                circle,
                rgba(0, 237, 131, 0.18),
                rgba(0, 237, 131, 0.03)
            );
            border: 1px solid var(--border);
        }

        .empty-state h2 {
            font-family: 'Playfair Display', serif;
            font-size: 27px;
            margin-bottom: 10px;
        }

        .empty-state p {
            max-width: 490px;
            margin: 0 auto 22px;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.8;
        }

        .empty-actions {
            display: flex;
            justify-content: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .no-filter-results {
            display: none;
            text-align: center;
            padding: 30px;
            color: var(--muted);
            border: 1px dashed var(--border);
            border-radius: 15px;
        }

        .orders-footer {
            padding: 23px 20px;
            text-align: center;
            color: var(--muted);
            font-size: 12px;
            border-top: 1px solid var(--border);
            background: #00150e;
        }

        .footer-logo {
            font-family: 'Playfair Display', serif;
            font-size: 22px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 6px;
        }

        .footer-logo span {
            color: #ff684f;
        }

        @media (max-width: 760px) {
            .hero-inner,
            .orders-container {
                width: 92%;
            }

            .orders-hero {
                padding: 34px 0;
            }

            .hero-art {
                font-size: 48px;
            }

            .orders-hero p {
                font-size: 13px;
            }

            .section-heading h2 {
                font-size: 20px;
            }

            .order-top {
                padding: 16px;
                align-items: flex-start;
            }

            .order-summary {
                padding: 15px 16px;
            }

            .order-details {
                padding: 0 16px 16px;
            }

            .order-filters {
                width: 100%;
                gap: 4px;
            }

            .filter-btn {
                padding: 9px 10px;
                flex: 1;
            }

            .order-top h3 {
                font-size: 15px;
            }

            .order-food-icon {
                width: 47px;
                height: 47px;
                font-size: 24px;
            }
        }

        @media (max-width: 480px) {
            .hero-layout {
                align-items: flex-start;
            }

            .hero-art {
                display: none;
            }

            .orders-hero h1 {
                font-size: 35px;
            }

            .order-top {
                flex-direction: column;
            }

            .order-status {
                margin-left: 60px;
            }

            .restaurant-info {
                min-width: 100px;
            }

            .summary-total strong {
                font-size: 18px;
            }

            .view-details {
                width: 100%;
            }

            .order-summary {
                gap: 10px;
            }

            .track-order-btn {
                width: 100%;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                animation: none !important;
                transition: none !important;
                scroll-behavior: auto !important;
            }
        }
    </style>
</head>

<body>

    <%@ include file="components/navbar.jsp" %>

    <section class="orders-hero">
        <div class="hero-inner">

            <div class="breadcrumb">
                FOODIEHUB / <span>YOUR ACCOUNT</span>
            </div>

            <div class="hero-layout">
                <div>
                    <h1>My <span>Orders.</span></h1>

                    <p>
                        Track your FoodieHub orders, revisit your
                        favourite dishes, and see every order in one place.
                    </p>
                </div>

                <div class="hero-art" aria-hidden="true">🍽️</div>
            </div>

        </div>
    </section>

    <main class="orders-container">

        <div class="section-heading">
            <div>
                <h2>Your Food Journey</h2>

                <p>
                    <%= totalOrders %>
                    order<%= totalOrders == 1 ? "" : "s" %>
                    in your account,
                    <%= ordersEscape(displayName) %>.
                </p>
            </div>

            <a class="primary-btn"
               href="<%= ordersContextPath %>/restaurant">
                🍴 Explore Restaurants →
            </a>
        </div>

        <% if (ordersList.isEmpty()) { %>

            <section class="empty-state">
                <div class="empty-illustration" aria-hidden="true">
                    🍜
                </div>

                <h2>Your food journey starts here</h2>

                <p>
                    You haven't placed any orders yet. Discover a
                    restaurant, choose your favourite dishes, and let
                    FoodieHub bring something delicious to you.
                </p>

                <div class="empty-actions">
                    <a class="primary-btn"
                       href="<%= ordersContextPath %>/restaurant">
                        Discover Restaurants →
                    </a>

                    <a class="secondary-btn"
                       href="<%= ordersContextPath %>/cart">
                        🛒 View Cart
                    </a>
                </div>
            </section>

        <% } else { %>

            <div class="order-filters"
                 role="group"
                 aria-label="Filter orders">

                <button class="filter-btn active"
                        type="button"
                        data-filter="all">
                    All Orders
                    <span class="filter-count"><%= totalOrders %></span>
                </button>

                <button class="filter-btn"
                        type="button"
                        data-filter="delivered">
                    Delivered
                    <span class="filter-count"><%= deliveredCount %></span>
                </button>

                <button class="filter-btn"
                        type="button"
                        data-filter="cancelled">
                    Cancelled
                    <span class="filter-count"><%= cancelledCount %></span>
                </button>
            </div>

            <div class="orders-list" id="ordersList">

                <% for (Order order : ordersList) {

                    Restaurant restaurant = restaurantsMap == null
                        ? null
                        : restaurantsMap.get(order.getRestaurantId());

                    String restaurantName =
                        restaurant != null && restaurant.getName() != null
                        ? restaurant.getName()
                        : "FoodieHub Restaurant";

                    String restaurantAddress =
                        restaurant != null && restaurant.getAddress() != null
                        ? restaurant.getAddress()
                        : "Restaurant details unavailable";

                    String orderStatus = order.getStatus() == null
                        ? "Processing"
                        : order.getStatus();

                    String statusClass = ordersStatusClass(orderStatus);

                    String filterStatus =
                        statusClass.equals("status-delivered")
                        ? "delivered"
                        : statusClass.equals("status-cancelled")
                        ? "cancelled"
                        : "other";

                    List<OrderItem> currentOrderItems =
                        orderItemsMap == null
                        ? null
                        : orderItemsMap.get(order.getOrderId());

                    if (currentOrderItems == null) {
                        currentOrderItems = new ArrayList<OrderItem>();
                    }

                    String paymentMode = order.getPaymentMode() == null
                        ? "Not specified"
                        : order.getPaymentMode();
                %>

                    <article class="order-card"
                             data-status="<%= filterStatus %>">

                        <div class="order-top">

                            <div class="order-main">

                                <div class="order-food-icon"
                                     aria-hidden="true">
                                    🍛
                                </div>

                                <div>
                                    <div class="order-number">
                                        ORDER #<%= order.getOrderId() %>
                                    </div>

                                    <h3>
                                        <%= ordersEscape(restaurantName) %>
                                    </h3>

                                    <div class="order-date">
                                        Ordered on:
                                        <%= order.getOrderDate() %>
                                    </div>
                                </div>

                            </div>

                            <span class="order-status <%= statusClass %>">
                                <%= ordersEscape(orderStatus) %>
                            </span>

                        </div>

                        <div class="order-summary">

                            <div class="restaurant-mark"
                                 aria-hidden="true">
                                ♨
                            </div>

                            <div class="restaurant-info">
                                <h4>
                                    <%= ordersEscape(restaurantName) %>
                                </h4>

                                <p>
                                    📍
                                    <%= ordersEscape(restaurantAddress) %>
                                </p>
                            </div>

                            <div class="summary-total">
                                <small>ORDER TOTAL</small>

                                <strong>
                                    ₹<%= String.format(
                                        Locale.US,
                                        "%.2f",
                                        order.getTotalAmount()
                                    ) %>
                                </strong>
                            </div>

                            <a class="track-order-btn"
                               href="<%= ordersContextPath %>/track-order?orderId=<%= order.getOrderId() %>">
                                🛵 Track My Order
                            </a>

                            <button class="view-details"
                                    type="button"
                                    aria-expanded="false">
                                View Details ↗
                            </button>

                        </div>

                        <div class="order-details">

                            <div class="details-divider"></div>

                            <div class="details-heading">
                                ORDER ITEMS
                            </div>

                            <% if (currentOrderItems.isEmpty()) { %>

                                <div class="detail-item">
                                    <div class="detail-name">
                                        <span class="item-symbol">🍽️</span>

                                        <div>
                                            <strong>
                                                Item details unavailable
                                            </strong>

                                            <small>
                                                Order #<%= order.getOrderId() %>
                                            </small>
                                        </div>
                                    </div>

                                    <span class="detail-price">—</span>
                                </div>

                            <% } else { %>

                                <% for (OrderItem orderItem :
                                        currentOrderItems) {

                                    Menu menu = menusMap == null
                                        ? null
                                        : menusMap.get(orderItem.getMenuId());

                                    String itemName =
                                        menu != null && menu.getItemName() != null
                                        ? menu.getItemName()
                                        : "Food item (Menu ID: "
                                            + orderItem.getMenuId() + ")";
                                %>

                                    <div class="detail-item">

                                        <div class="detail-name">

                                            <span class="item-symbol"
                                                  aria-hidden="true">
                                                🍽️
                                            </span>

                                            <div>
                                                <strong>
                                                    <%= ordersEscape(itemName) %>
                                                </strong>

                                                <small>
                                                    Menu ID:
                                                    <%= orderItem.getMenuId() %>
                                                </small>
                                            </div>

                                        </div>

                                        <span class="detail-price">
                                            ₹<%= String.format(
                                                Locale.US,
                                                "%.2f",
                                                orderItem.getTotalAmount()
                                            ) %>
                                        </span>

                                    </div>

                                <% } %>

                            <% } %>

                            <div class="order-meta">

                                <span>
                                    Order ID:
                                    <strong>
                                        #<%= order.getOrderId() %>
                                    </strong>
                                </span>

                                <span>
                                    Payment:
                                    <strong>
                                        <%= ordersEscape(paymentMode) %>
                                    </strong>
                                </span>

                                <span>
                                    Status:
                                    <strong>
                                        <%= ordersEscape(orderStatus) %>
                                    </strong>
                                </span>

                            </div>

                        </div>

                    </article>

                <% } %>

            </div>

            <div class="no-filter-results" id="noFilterResults">
                No orders found in this category.
            </div>

        <% } %>

    </main>

    <footer class="orders-footer">
        <div class="footer-logo">
            Foodie<span>Hub</span>
        </div>

        <p>
            Discover delicious food. Delivered with love. ❤️
        </p>
    </footer>

    <script>
        (function () {

            const filterButtons =
                document.querySelectorAll('.filter-btn');

            const orderCards =
                document.querySelectorAll('.order-card');

            const emptyFilterMessage =
                document.getElementById('noFilterResults');

            /*
             * FIX: Explicitly display every order when the page loads.
             * The controller has already retrieved the order data.
             */
            orderCards.forEach(function (card) {
                card.style.display = 'block';
            });

            if (emptyFilterMessage) {
                emptyFilterMessage.style.display = 'none';
            }

            filterButtons.forEach(function (button) {

                button.addEventListener('click', function () {

                    const filter = button.dataset.filter;

                    filterButtons.forEach(function (item) {
                        item.classList.toggle(
                            'active',
                            item === button
                        );
                    });

                    let visible = 0;

                    orderCards.forEach(function (card) {

                        const show =
                            filter === 'all' ||
                            card.dataset.status === filter;

                        card.style.display = show ? 'block' : 'none';

                        if (show) {
                            visible++;
                        }
                    });

                    if (emptyFilterMessage) {
                        emptyFilterMessage.style.display =
                            visible === 0 ? 'block' : 'none';
                    }
                });
            });

            document.querySelectorAll('.view-details')
                .forEach(function (button) {

                    button.addEventListener('click', function () {

                        const card = button.closest('.order-card');

                        if (!card) {
                            return;
                        }

                        const expanded =
                            card.classList.toggle('expanded');

                        button.setAttribute(
                            'aria-expanded',
                            String(expanded)
                        );

                        button.textContent = expanded
                            ? 'Hide Details ↑'
                            : 'View Details ↗';
                    });
                });

        })();
    </script>

</body>
</html>
