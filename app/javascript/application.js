// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers/index"
import "trix"
import "@rails/actiontext"
import React from 'react'
import { createRoot } from 'react-dom/client'

// Reactコンポーネントは後ほど追加します
console.log('Application.js loaded successfully!')

// Reactコンポーネントをマウントする関数（後で使用）
window.mountComponent = (componentName, Component) => {
  const element = document.getElementById(componentName)
  if (element) {
    const root = createRoot(element)
    const props = JSON.parse(element.dataset.props || '{}')
    root.render(<Component {...props} />)
  }
}