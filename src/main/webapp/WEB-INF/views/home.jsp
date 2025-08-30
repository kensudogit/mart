<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>intra-mart - ホーム</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
    <div class="container">
        <header class="header">
            <h1>intra-mart環境</h1>
            <nav class="nav">
                <ul>
                    <li><a href="<c:url value='/'/>">ホーム</a></li>
                    <li><a href="<c:url value='/dashboard'/>">ダッシュボード</a></li>
                    <li><a href="<c:url value='/login'/>">ログイン</a></li>
                </ul>
            </nav>
        </header>

        <main class="main">
            <section class="welcome">
                <h2>ようこそ！</h2>
                <p class="message">${message}</p>
                <p class="version">バージョン: ${version}</p>
            </section>

            <section class="features">
                <h3>主な機能</h3>
                <div class="feature-grid">
                    <div class="feature-item">
                        <h4>Java 11</h4>
                        <p>最新のJava機能を活用した開発環境</p>
                    </div>
                    <div class="feature-item">
                        <h4>PostgreSQL</h4>
                        <p>高性能なリレーショナルデータベース</p>
                    </div>
                    <div class="feature-item">
                        <h4>Spring Framework</h4>
                        <p>エンタープライズ級のJavaフレームワーク</p>
                    </div>
                    <div class="feature-item">
                        <h4>Hibernate</h4>
                        <p>オブジェクトリレーショナルマッピング</p>
                    </div>
                </div>
            </section>
        </main>

        <footer class="footer">
            <p>&copy; 2024 intra-mart環境. All rights reserved.</p>
        </footer>
    </div>

    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>
