-- intra-mart環境 PostgreSQL セットアップスクリプト

-- データベースの作成
CREATE DATABASE intramart_db
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Japanese_Japan.932'
    LC_CTYPE = 'Japanese_Japan.932'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- データベースに接続
\c intramart_db;

-- スキーマの作成
CREATE SCHEMA intramart_schema;

-- ユーザーテーブルの作成
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

-- ユーザー権限の作成
CREATE USER intramart_user WITH PASSWORD 'intramart_password';

-- スキーマへの権限付与
GRANT USAGE ON SCHEMA intramart_schema TO intramart_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA intramart_schema TO intramart_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA intramart_schema TO intramart_user;

-- テーブル作成権限の付与
GRANT CREATE ON SCHEMA intramart_schema TO intramart_user;

-- サンプルデータの挿入
INSERT INTO intramart_schema.users (username, email, password, first_name, last_name) VALUES
('admin', 'admin@intramart.local', '$2a$10$example.hash', '管理者', '太郎'),
('user1', 'user1@intramart.local', '$2a$10$example.hash', 'ユーザー', '一郎'),
('user2', 'user2@intramart.local', '$2a$10$example.hash', 'ユーザー', '二郎');

-- インデックスの作成
CREATE INDEX idx_users_username ON intramart_schema.users(username);
CREATE INDEX idx_users_email ON intramart_schema.users(email);
CREATE INDEX idx_users_active ON intramart_schema.users(is_active);

-- 更新日時の自動更新トリガー
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON intramart_schema.users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- テーブル情報の確認
\dt intramart_schema.*

-- 権限情報の確認
\du intramart_user
