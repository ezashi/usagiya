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

// マウント済みコンポーネントを追跡
const mountedRoots = new Map()

// Reactコンポーネントを安全にマウントする関数
const mountComponent = (rootId, Component, retryCount = 0) => {
  const maxRetries = 3
  
  try {
    const rootElement = document.getElementById(rootId)
    
    if (!rootElement) {
      if (retryCount < maxRetries) {
        console.log(`Root element ${rootId} not found, retrying... (${retryCount + 1}/${maxRetries})`)
        setTimeout(() => mountComponent(rootId, Component, retryCount + 1), 100)
      }
      return false
    }

    if (mountedRoots.has(rootId)) {
      console.log(`${rootId} already mounted, skipping...`)
      return true
    }

    let props = {}
    try {
      const propsData = rootElement.dataset.props
      if (propsData) {
        props = JSON.parse(propsData)
      }
    } catch (parseError) {
      console.error(`Error parsing props for ${rootId}:`, parseError)
      props = {}
    }

    const root = createRoot(rootElement)
    root.render(<Component {...props} />)
    mountedRoots.set(rootId, root)
    
    console.log(`${rootId} mounted successfully`)
    return true
    
  } catch (error) {
    console.error(`Error mounting ${rootId}:`, error)
    
    if (retryCount < maxRetries) {
      setTimeout(() => mountComponent(rootId, Component, retryCount + 1), 200)
    }
    return false
  }
}

// すべてのコンポーネントをマウント
const mountAllComponents = () => {
  console.log('Mounting all components...')
  
  // ホームページではReactコンポーネントをマウントしない（ERBを使用）
  const isHomePage = window.location.pathname === '/' || window.location.pathname === '/pages/home'
  
  if (!isHomePage) {
    mountComponent('home-root', Home)
  }
  
  mountComponent('featured-products-root', FeaturedProducts)
  mountComponent('seasonal-products-root', SeasonalProducts)
}

// すべてのコンポーネントをアンマウント
const unmountAllComponents = () => {
  console.log('Unmounting all components...')
  
  mountedRoots.forEach((root, rootId) => {
    try {
      root.unmount()
      console.log(`${rootId} unmounted successfully`)
    } catch (error) {
      console.error(`Error unmounting ${rootId}:`, error)
    }
  })
  
  mountedRoots.clear()
}

// ページ読み込み時とTurbo遷移時の処理
const initializePage = () => {
  console.log('Initializing page...')
  
  // 既存のコンポーネントをアンマウント
  unmountAllComponents()
  
  // 新しいコンポーネントをマウント
  setTimeout(() => {
    mountAllComponents()
  }, 10)
}

// DOMContentLoaded: 初回読み込み時
document.addEventListener('DOMContentLoaded', () => {
  console.log('DOMContentLoaded event fired')
  initializePage()
})

// turbo:load: Turbo Driveによるページ遷移時
document.addEventListener('turbo:load', () => {
  console.log('turbo:load event fired')
  initializePage()
})

// turbo:before-cache: ページがキャッシュされる前
document.addEventListener('turbo:before-cache', () => {
  console.log('turbo:before-cache event fired')
  unmountAllComponents()
})

// turbo:render: ページがレンダリングされた後
document.addEventListener('turbo:render', () => {
  console.log('turbo:render event fired')
  // スタイルの再適用が必要な場合はここで実行
})