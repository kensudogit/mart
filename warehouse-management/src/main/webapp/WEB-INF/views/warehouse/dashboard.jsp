<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>倉庫管理システム - ダッシュボード</title>
    <link rel="stylesheet" href="<c:url value='/css/warehouse.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="warehouse-container">
        <!-- ヘッダー -->
        <header class="warehouse-header">
            <div class="header-content">
                <div class="logo-section">
                    <i class="fas fa-warehouse"></i>
                    <h1>倉庫管理システム</h1>
                </div>
                <nav class="main-nav">
                    <ul>
                        <li class="active"><a href="<c:url value='/warehouse/dashboard'/>"><i class="fas fa-tachometer-alt"></i> ダッシュボード</a></li>
                        <li><a href="<c:url value='/warehouse/inventory'/>"><i class="fas fa-boxes"></i> 在庫管理</a></li>
                        <li><a href="<c:url value='/warehouse/inbound'/>"><i class="fas fa-arrow-down"></i> 入庫</a></li>
                        <li><a href="<c:url value='/warehouse/outbound'/>"><i class="fas fa-arrow-up"></i> 出庫</a></li>
                        <li><a href="<c:url value='/warehouse/cycle-count'/>"><i class="fas fa-clipboard-check"></i> 棚卸し</a></li>
                        <li><a href="<c:url value='/warehouse/reports'/>"><i class="fas fa-chart-bar"></i> レポート</a></li>
                        <li><a href="<c:url value='/warehouse/settings'/>"><i class="fas fa-cog"></i> 設定</a></li>
                    </ul>
                </nav>
                <div class="user-section">
                    <span class="user-name">管理者</span>
                    <a href="#" class="logout-btn"><i class="fas fa-sign-out-alt"></i></a>
                </div>
            </div>
        </header>

        <!-- メインコンテンツ -->
        <main class="warehouse-main">
            <!-- アラート表示 -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <!-- サマリーカード -->
            <section class="summary-section">
                <div class="summary-grid">
                    <div class="summary-card primary">
                        <div class="card-icon">
                            <i class="fas fa-boxes"></i>
                        </div>
                        <div class="card-content">
                            <h3>総在庫数</h3>
                            <p class="card-number">${summary.totalProducts}</p>
                            <span class="card-unit">商品</span>
                        </div>
                    </div>

                    <div class="summary-card success">
                        <div class="card-icon">
                            <i class="fas fa-warehouse"></i>
                        </div>
                        <div class="card-content">
                            <h3>在庫価値</h3>
                            <p class="card-number">¥<fmt:formatNumber value="${summary.totalValue}" pattern="#,##0"/></p>
                            <span class="card-unit">円</span>
                        </div>
                    </div>

                    <div class="summary-card warning">
                        <div class="card-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="card-content">
                            <h3>低在庫商品</h3>
                            <p class="card-number">${summary.lowStockCount}</p>
                            <span class="card-unit">商品</span>
                        </div>
                    </div>

                    <div class="summary-card info">
                        <div class="card-icon">
                            <i class="fas fa-exchange-alt"></i>
                        </div>
                        <div class="card-content">
                            <h3>今日の取引</h3>
                            <p class="card-number">${summary.todayTransactions}</p>
                            <span class="card-unit">件</span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- メインコンテンツエリア -->
            <div class="main-content-grid">
                <!-- 在庫チャート -->
                <section class="chart-section">
                    <div class="section-header">
                        <h2><i class="fas fa-chart-pie"></i> 在庫分布</h2>
                    </div>
                    <div class="chart-container">
                        <canvas id="inventoryChart" width="400" height="300"></canvas>
                    </div>
                </section>

                <!-- 低在庫商品リスト -->
                <section class="low-stock-section">
                    <div class="section-header">
                        <h2><i class="fas fa-exclamation-triangle"></i> 低在庫商品</h2>
                        <a href="<c:url value='/warehouse/inventory'/>" class="view-all-btn">すべて表示</a>
                    </div>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>商品コード</th>
                                    <th>商品名</th>
                                    <th>在庫数</th>
                                    <th>最小在庫</th>
                                    <th>ステータス</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${lowStockProducts}" var="product" varStatus="status">
                                    <tr class="${status.index % 2 == 0 ? 'even' : 'odd'}">
                                        <td>${product.productCode}</td>
                                        <td>${product.productName}</td>
                                        <td>
                                            <span class="quantity-badge ${product.quantity <= 0 ? 'out-of-stock' : 'low-stock'}">
                                                ${product.quantity}
                                            </span>
                                        </td>
                                        <td>${product.minStockLevel}</td>
                                        <td>
                                            <span class="status-badge ${product.quantity <= 0 ? 'critical' : 'warning'}">
                                                ${product.quantity <= 0 ? '在庫切れ' : '低在庫'}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- 最近の取引履歴 -->
                <section class="recent-transactions-section">
                    <div class="section-header">
                        <h2><i class="fas fa-history"></i> 最近の取引</h2>
                        <a href="<c:url value='/warehouse/reports'/>" class="view-all-btn">すべて表示</a>
                    </div>
                    <div class="transactions-list">
                        <c:forEach items="${recentTransactions}" var="transaction">
                            <div class="transaction-item ${transaction.transactionType.name().toLowerCase()}">
                                <div class="transaction-icon">
                                    <i class="fas fa-${transaction.inbound ? 'arrow-down' : 'arrow-up'}"></i>
                                </div>
                                <div class="transaction-details">
                                    <div class="transaction-header">
                                        <span class="transaction-type">${transaction.transactionType.displayName}</span>
                                        <span class="transaction-date">
                                            <fmt:formatDate value="${transaction.transactionDate}" pattern="MM/dd HH:mm"/>
                                        </span>
                                    </div>
                                    <div class="transaction-info">
                                        <span class="product-name">商品ID: ${transaction.productId}</span>
                                        <span class="quantity">数量: ${transaction.quantity}</span>
                                    </div>
                                </div>
                                <div class="transaction-status">
                                    <span class="status-badge ${transaction.status.name().toLowerCase()}">
                                        ${transaction.status.displayName}
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>

                <!-- クイックアクション -->
                <section class="quick-actions-section">
                    <div class="section-header">
                        <h2><i class="fas fa-bolt"></i> クイックアクション</h2>
                    </div>
                    <div class="quick-actions-grid">
                        <a href="<c:url value='/warehouse/inbound'/>" class="quick-action-card inbound">
                            <div class="action-icon">
                                <i class="fas fa-arrow-down"></i>
                            </div>
                            <h3>入庫処理</h3>
                            <p>商品の入庫処理を行います</p>
                        </a>

                        <a href="<c:url value='/warehouse/outbound'/>" class="quick-action-card outbound">
                            <div class="action-icon">
                                <i class="fas fa-arrow-up"></i>
                            </div>
                            <h3>出庫処理</h3>
                            <p>商品の出庫処理を行います</p>
                        </a>

                        <a href="<c:url value='/warehouse/cycle-count'/>" class="quick-action-card cycle-count">
                            <div class="action-icon">
                                <i class="fas fa-clipboard-check"></i>
                            </div>
                            <h3>棚卸し</h3>
                            <p>在庫の棚卸しを行います</p>
                        </a>

                        <a href="<c:url value='/warehouse/inventory'/>" class="quick-action-card inventory">
                            <div class="action-icon">
                                <i class="fas fa-search"></i>
                            </div>
                            <h3>在庫検索</h3>
                            <p>在庫情報を検索します</p>
                        </a>
                    </div>
                </section>
            </div>
        </main>
    </div>

    <script src="<c:url value='/js/warehouse.js'/>"></script>
    <script>
        // 在庫分布チャートの初期化
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('inventoryChart').getContext('2d');
            const inventoryChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['通常在庫', '低在庫', '在庫切れ'],
                    datasets: [{
                        data: [70, 20, 10],
                        backgroundColor: [
                            '#4CAF50',
                            '#FF9800',
                            '#F44336'
                        ],
                        borderWidth: 2,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                usePointStyle: true
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
