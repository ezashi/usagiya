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
import SeasonalProducts from './components/SeasonalProducts'

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
    console.log('Home mounted')
  }

  // おすすめ商品コンポーネント
  const featuredRoot = document.getElementById('featured-products-root')
  if (featuredRoot) {
    const props = JSON.parse(featuredRoot.dataset.props || '{}')
    const root = createRoot(featuredRoot)
    root.render(<FeaturedProducts {...props} />)
    console.log('FeaturedProducts mounted')
  }

  // 季節限定商品コンポーネント
  const seasonalRoot = document.getElementById('seasonal-products-root')
  if (seasonalRoot) {
    const props = JSON.parse(seasonalRoot.dataset.props || '{}')
    const root = createRoot(seasonalRoot)
    root.render(<SeasonalProducts {...props} />)
    console.log('SeasonalProducts mounted')
  }
}

// 初回読み込み時
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', mountComponents)
} else {
  mountComponents()
}

console.log('Application.js loaded successfully!')