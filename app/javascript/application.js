// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers/index"
import "trix"
import "@rails/actiontext"
import React from 'react'
import { createRoot } from 'react-dom/client'

// コンポーネントのインポート
import Home from './components/Home'
import FeaturedProducts from './components/FeaturedProducts'

console.log('Application.js loading...')

// Reactコンポーネントをマウントする関数
const mountComponents = () => {
  console.log('Mounting components...')

  // ホームコンポーネント
  const homeRoot = document.getElementById('home-root')
  if (homeRoot) {
    const props = JSON.parse(homeRoot.dataset.props || '{}')
    const root = createRoot(homeRoot)
    root.render(<Home {...props} />)
  }

  // おすすめ商品コンポーネント
  const featuredRoot = document.getElementById('featured-products-root')
  if (featuredRoot) {
    const props = JSON.parse(featuredRoot.dataset.props || '{}')
    const root = createRoot(featuredRoot)
    root.render(<FeaturedProducts {...props} />)
    console.log('FeaturedProducts mounted')
  }
}

// 初回読み込み時
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', mountComponents)
} else {
  mountComponents()
}

console.log('Application.js loaded successfully!')