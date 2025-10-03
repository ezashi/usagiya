// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers/index"
import "trix"
import "@rails/actiontext"
import React from 'react'
import { createRoot } from 'react-dom/client'

// コンポーネントのインポート
import Home from './components/Home'

// Reactコンポーネントをマウントする関数
window.mountComponent = (componentName, Component) => {
  const element = document.getElementById(componentName)
  if (element) {
    const root = createRoot(element)
    const props = JSON.parse(element.dataset.props || '{}')
    root.render(<Component {...props} />)
  }
}

// DOMContentLoadedイベントでコンポーネントをマウント
document.addEventListener('DOMContentLoaded', () => {
  // 一般ユーザー用コンポーネント
  window.mountComponent('home-root', Home)
})

// Turbo対応（ページ遷移時にも再マウント）
document.addEventListener('turbo:load', () => {
  window.mountComponent('home-root', Home)
})

console.log('Application.js loaded successfully!')