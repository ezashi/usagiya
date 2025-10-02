import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "indicator"]
  static values = {
    autoplayInterval: { type: Number, default: 3000 }
  }

  connect() {
    this.currentIndex = 0
    this.isAutoPlaying = true
    this.showSlide(0)
    this.startAutoplay()
  }

  disconnect() {
    this.stopAutoplay()
  }

  // 次の画像へ
  next() {
    this.stopAutoplay()
    this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length
    this.showSlide(this.currentIndex)
    this.startAutoplay()
  }

  // 前の画像へ
  previous() {
    this.stopAutoplay()
    this.currentIndex = (this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length
    this.showSlide(this.currentIndex)
    this.startAutoplay()
  }

  // 特定の画像へジャンプ
  goTo(event) {
    this.stopAutoplay()
    this.currentIndex = parseInt(event.currentTarget.dataset.index)
    this.showSlide(this.currentIndex)
    this.startAutoplay()
  }

  // スライドを表示
  showSlide(index) {
    // すべてのスライドを非表示
    this.slideTargets.forEach((slide, i) => {
      if (i === index) {
        slide.classList.remove("opacity-0")
        slide.classList.add("opacity-100")
      } else {
        slide.classList.remove("opacity-100")
        slide.classList.add("opacity-0")
      }
    })

    // インジケーターを更新
    this.indicatorTargets.forEach((indicator, i) => {
      if (i === index) {
        indicator.classList.remove("w-3", "bg-white/50")
        indicator.classList.add("w-8", "bg-white")
      } else {
        indicator.classList.remove("w-8", "bg-white")
        indicator.classList.add("w-3", "bg-white/50")
      }
    })
  }

  // 自動再生を開始
  startAutoplay() {
    if (this.autoplayTimer) return

    this.autoplayTimer = setInterval(() => {
      if (this.isAutoPlaying) {
        this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length
        this.showSlide(this.currentIndex)
      }
    }, this.autoplayIntervalValue)
  }

  // 自動再生を停止
  stopAutoplay() {
    if (this.autoplayTimer) {
      clearInterval(this.autoplayTimer)
      this.autoplayTimer = null
    }
  }

  // マウスオーバーで自動再生を一時停止
  pauseAutoplay() {
    this.isAutoPlaying = false
  }

  // マウスアウトで自動再生を再開
  resumeAutoplay() {
    this.isAutoPlaying = true
  }
}