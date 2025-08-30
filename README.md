# intra-mart環境

## 概要
intra-mart環境のWebアプリケーションです。Java 11、PostgreSQL、Spring Framework、Hibernateを使用して構築されています。

## 技術スタック
- **言語**: Java 11
- **データベース**: PostgreSQL
- **フレームワーク**: Spring Framework 5.3.20
- **ORM**: Hibernate 5.6.9
- **ビュー**: JSP + JSTL
- **ビルドツール**: Maven
- **アプリケーションサーバー**: Tomcat

## 環境構築手順

### 1. 前提条件
- Java 11以上がインストールされていること
- Maven 3.6以上がインストールされていること
- PostgreSQL 12以上がインストールされていること

### 2. PostgreSQLのセットアップ
```bash
# PostgreSQLにログイン
psql -U postgres

# データベースとユーザーを作成
CREATE DATABASE intramart_db;
CREATE USER intramart_user WITH PASSWORD 'intramart_password';
GRANT ALL PRIVILEGES ON DATABASE intramart_db TO intramart_user;

# データベースに接続
\c intramart_db

# スキーマを作成
CREATE SCHEMA intramart_schema;

# ユーザーテーブルを作成
CREATE TABLE intramart_schema.users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# 権限を付与
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA intramart_schema TO intramart_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA intramart_schema TO intramart_user;
```

### 3. アプリケーションのビルドと実行
```bash
# 依存関係のダウンロード
mvn clean install

# Tomcatでアプリケーションを起動
mvn tomcat7:run
```

### 4. アクセス
アプリケーションが起動したら、以下のURLでアクセスできます：
- ホーム画面: http://localhost:8080/intra-mart/
- ダッシュボード: http://localhost:8080/intra-mart/dashboard
- ログイン: http://localhost:8080/intra-mart/login

## プロジェクト構造
```
src/
├── main/
│   ├── java/
│   │   └── com/intramart/app/
│   │       ├── controller/     # コントローラー
│   │       └── model/          # エンティティモデル
│   ├── resources/
│   │   ├── applicationContext.xml  # Spring設定
│   │   ├── spring-mvc.xml          # Spring MVC設定
│   │   ├── database.properties     # データベース設定
│   │   └── intramart.properties    # intra-mart設定
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml             # Webアプリケーション設定
│       │   └── views/              # JSPビュー
│       ├── css/                    # スタイルシート
│       └── js/                     # JavaScript
└── test/
    └── java/                       # テストコード
```

## 設定ファイル

### database.properties
PostgreSQLデータベースの接続設定
- ホスト: localhost
- ポート: 5432
- データベース: intramart_db
- ユーザー: intramart_user
- パスワード: intramart_password

### intramart.properties
intra-mart環境の基本設定
- アプリケーション名: intra-mart Application
- バージョン: 1.0.0
- セッションタイムアウト: 30分
- ログレベル: INFO

## 開発ガイドライン

### コーディング規約
- Java: Oracle Java Code Conventionsに準拠
- パッケージ名: com.intramart.app.*
- クラス名: PascalCase
- メソッド名: camelCase
- 定数: UPPER_SNAKE_CASE

### データベース設計
- テーブル名: スネークケース（例: user_profiles）
- カラム名: スネークケース（例: created_at）
- 主キー: {テーブル名}_id
- 外部キー: {参照テーブル名}_id

## トラブルシューティング

### よくある問題
1. **データベース接続エラー**
   - PostgreSQLサービスが起動しているか確認
   - 接続情報（ホスト、ポート、ユーザー名、パスワード）を確認

2. **Maven依存関係エラー**
   - インターネット接続を確認
   - Mavenのローカルリポジトリをクリア（mvn clean）

3. **ポート競合**
   - 8080番ポートが使用中の場合、spring-mvc.xmlでポート番号を変更

### ログの確認
- アプリケーションログ: logs/intramart.log
- Tomcatログ: コンソール出力
- データベースログ: PostgreSQLのログファイル

## ライセンス
このプロジェクトは社内利用を目的としています。

## サポート
技術的な問題や質問がある場合は、開発チームまでお問い合わせください。
