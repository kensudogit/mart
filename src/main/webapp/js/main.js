// intra-mart Application Main JavaScript

document.addEventListener('DOMContentLoaded', function() {
    console.log('intra-mart環境が読み込まれました');
    
    // ナビゲーションのアクティブ状態を管理
    initializeNavigation();
    
    // フォームのバリデーション
    initializeFormValidation();
    
    // アニメーション効果
    initializeAnimations();
});

/**
 * ナビゲーションの初期化
 */
function initializeNavigation() {
    const navLinks = document.querySelectorAll('.nav a');
    const currentPath = window.location.pathname;
    
    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        }
        
        // ホバー効果
        link.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.05)';
        });
        
        link.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });
}

/**
 * フォームバリデーションの初期化
 */
function initializeFormValidation() {
    const forms = document.querySelectorAll('form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!validateForm(this)) {
                e.preventDefault();
                showError('フォームの入力内容を確認してください。');
            }
        });
    });
}

/**
 * フォームのバリデーション
 */
function validateForm(form) {
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;
    
    requiredFields.forEach(field => {
        if (!field.value.trim()) {
            field.classList.add('error');
            isValid = false;
        } else {
            field.classList.remove('error');
        }
    });
    
    return isValid;
}

/**
 * エラーメッセージの表示
 */
function showError(message) {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.textContent = message;
    errorDiv.style.cssText = `
        background-color: #f8d7da;
        color: #721c24;
        padding: 1rem;
        border: 1px solid #f5c6cb;
        border-radius: 5px;
        margin: 1rem 0;
        text-align: center;
    `;
    
    const container = document.querySelector('.container');
    container.insertBefore(errorDiv, container.firstChild);
    
    // 3秒後にエラーメッセージを削除
    setTimeout(() => {
        errorDiv.remove();
    }, 3000);
}

/**
 * アニメーション効果の初期化
 */
function initializeAnimations() {
    // スクロール時のフェードイン効果
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // アニメーション対象の要素を監視
    const animatedElements = document.querySelectorAll('.feature-item, .welcome');
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
}

/**
 * ユーティリティ関数：日付のフォーマット
 */
function formatDate(date) {
    const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    };
    return new Date(date).toLocaleDateString('ja-JP', options);
}

/**
 * ユーティリティ関数：API呼び出し
 */
async function apiCall(url, options = {}) {
    try {
        const response = await fetch(url, {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return await response.json();
    } catch (error) {
        console.error('API呼び出しエラー:', error);
        throw error;
    }
}

/**
 * ユーティリティ関数：ローカルストレージの管理
 */
const Storage = {
    set: function(key, value) {
        try {
            localStorage.setItem(key, JSON.stringify(value));
        } catch (e) {
            console.error('ローカルストレージへの保存に失敗しました:', e);
        }
    },
    
    get: function(key) {
        try {
            const item = localStorage.getItem(key);
            return item ? JSON.parse(item) : null;
        } catch (e) {
            console.error('ローカルストレージからの読み込みに失敗しました:', e);
            return null;
        }
    },
    
    remove: function(key) {
        try {
            localStorage.removeItem(key);
        } catch (e) {
            console.error('ローカルストレージからの削除に失敗しました:', e);
        }
    }
};

// グローバルに公開
window.intraMart = {
    Storage: Storage,
    formatDate: formatDate,
    apiCall: apiCall
};
