// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// おすすめ商品ページのレイアウト切り替え機能
document.addEventListener('turbo:load', function() {
  const carouselViewBtn = document.getElementById('carousel-view-btn');
  const gridViewBtn = document.getElementById('grid-view-btn');
  const carouselView = document.getElementById('carousel-view');
  const gridView = document.getElementById('grid-view');

  if (carouselViewBtn && gridViewBtn && carouselView && gridView) {
    // カルーセルビューへ切り替え
    carouselViewBtn.addEventListener('click', function() {
      carouselView.classList.remove('hidden');
      gridView.classList.add('hidden');
      carouselViewBtn.classList.add('active');
      gridViewBtn.classList.remove('active');
    });

    // グリッドビューへ切り替え
    gridViewBtn.addEventListener('click', function() {
      gridView.classList.remove('hidden');
      carouselView.classList.add('hidden');
      gridViewBtn.classList.add('active');
      carouselViewBtn.classList.remove('active');
    });
  }
});