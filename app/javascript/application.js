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

// 背景色を強制的に白に設定する関数
const ensureWhiteBackground = () => {
  document.documentElement.style.backgroundColor = '#ffffff'
  document.body.style.backgroundColor = '#ffffff'
  
  const rootElements = document.querySelectorAll('[id$="-root"]')
  rootElements.forEach(el => {
    el.style.backgroundColor = '#ffffff'
  })
}

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
  
  ensureWhiteBackground()
  
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
      console.log(`${rootId} unmounted`)
    } catch (error) {
      console.error(`Error unmounting ${rootId}:`, error)
    }
  })
  
  mountedRoots.clear()
}

let mountTimeout = null

const debouncedMount = () => {
  if (mountTimeout) {
    clearTimeout(mountTimeout)
  }
  
  mountTimeout = setTimeout(() => {
    ensureWhiteBackground()
    mountAllComponents()
  }, 50)
}

// 初回読み込み時
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    ensureWhiteBackground()
    mountAllComponents()
  })
} else {
  ensureWhiteBackground()
  mountAllComponents()
}

// Turboイベント対応
document.addEventListener('turbo:before-visit', () => {
  const sideMenu = document.getElementById('sideMenu')
  const overlay = document.getElementById('overlay-menu')
  if (sideMenu) sideMenu.classList.remove('active')
  if (overlay) overlay.classList.remove('active')
  document.body.style.overflow = ''
})

document.addEventListener('turbo:before-render', () => {
  ensureWhiteBackground()
  unmountAllComponents()
})

document.addEventListener('turbo:render', debouncedMount)
document.addEventListener('turbo:load', debouncedMount)
document.addEventListener('turbo:frame-load', debouncedMount)

// 背景色監視（安全策）
let backgroundCheckInterval = null

const startBackgroundCheck = () => {
  if (backgroundCheckInterval) {
    clearInterval(backgroundCheckInterval)
  }
  
  backgroundCheckInterval = setInterval(() => {
    const bodyBg = window.getComputedStyle(document.body).backgroundColor
    const htmlBg = window.getComputedStyle(document.documentElement).backgroundColor
    
    if (bodyBg === 'rgb(0, 0, 0)' || htmlBg === 'rgb(0, 0, 0)') {
      console.warn('Black background detected! Forcing white...')
      ensureWhiteBackground()
    }
  }, 500)
}

const stopBackgroundCheck = () => {
  if (backgroundCheckInterval) {
    clearInterval(backgroundCheckInterval)
    backgroundCheckInterval = null
  }
}

document.addEventListener('turbo:load', () => {
  startBackgroundCheck()
  setTimeout(stopBackgroundCheck, 5000)
})

if (document.readyState === 'complete') {
  startBackgroundCheck()
  setTimeout(stopBackgroundCheck, 5000)
} else {
  window.addEventListener('load', () => {
    startBackgroundCheck()
    setTimeout(stopBackgroundCheck, 5000)
  })
}

console.log('Application.js loaded successfully!')