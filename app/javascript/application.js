// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers/index"
import "trix"
import "@rails/actiontext"
import React from 'react'
import { createRoot } from 'react-dom/client'

// コンポーネントのインポート
import Home from './components/Home'

console.log('Application.js loading...')

// Reactコンポーネントをマウントする関数
const mountComponents = () => {
  console.log('Mounting components...')
  
  const homeRoot = document.getElementById('home-root')
  if (homeRoot) {
    console.log('Found home-root, mounting Home component')
    const props = JSON.parse(homeRoot.dataset.props || '{}')
    console.log('Props:', props)
    const root = createRoot(homeRoot)
    root.render(<Home {...props} />)
    console.log('Home component mounted successfully')
  } else {
    console.log('home-root not found')
  }
}

// 初回読み込み時
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', mountComponents)
} else {
  mountComponents()
}

// Turbo対応
document.addEventListener('turbo:load', mountComponents)
document.addEventListener('turbo:render', mountComponents)

console.log('Application.js loaded successfully!')