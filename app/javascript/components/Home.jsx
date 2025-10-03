import React, { useState, useEffect } from 'react'

const Home = ({ featured_products = [], seasonal_products = [], recent_notices = [] }) => {
  const [menuOpen, setMenuOpen] = useState(false)
  const [currentSlide, setCurrentSlide] = useState(0)

  // スライドショーの画像
  const slides = [
    { image: '/assets/top/mamedaifuku_kusamoti.jpg', alt: '豆大福と草餅' },
    { image: '/assets/top/usagimanju.jpg', alt: 'うさぎまんじゅう' },
    { image: '/assets/top/motipai.jpg', alt: 'もちパイ' },
    { 
      image: '/assets/top/satofuru.jpg', 
      alt: 'さとふる',
      link: 'https://www.satofull.jp/products/list.php?s4=18&q=%E3%81%86%E3%81%95%E3%81%8E%E3%82%84&cnt=60&p=1'
    }
  ]

  // スライドショーの自動切り替え
  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % slides.length)
    }, 5000) // 5秒ごとに切り替え

    return () => clearInterval(timer)
  }, [])

  // メニューの切り替え
  const toggleMenu = () => {
    setMenuOpen(!menuOpen)
  }

  return (
    <div className="w-full">
      {/* ヘッダー */}
      <header className="fixed top-0 left-0 right-0 bg-white shadow-md z-50">
        <div className="container mx-auto px-4 py-4 flex justify-between items-center">
          {/* ロゴ */}
          <div className="flex items-center">
            <h1 className="text-2xl font-bold text-pink-600">御菓子処うさぎや</h1>
          </div>

          {/* ハンバーガーメニュー */}
          <button
            onClick={toggleMenu}
            className="hamburger flex flex-col justify-center items-center w-10 h-10 space-y-1.5"
            aria-label="メニュー"
          >
            <span className="hamburger-line block w-6 h-0.5 bg-gray-800"></span>
            <span className="hamburger-line block w-6 h-0.5 bg-gray-800"></span>
            <span className="hamburger-line block w-6 h-0.5 bg-gray-800"></span>
          </button>
        </div>
      </header>

      {/* フルスクリーンメニュー */}
      <div
        className={`fullscreen-menu fixed inset-0 bg-white z-40 flex items-center justify-center ${
          menuOpen ? 'visible' : 'hidden'
        }`}
      >
        <button
          onClick={toggleMenu}
          className="absolute top-8 right-8 text-4xl text-gray-800 hover:text-pink-600"
          aria-label="閉じる"
        >
          ×
        </button>
        <nav>
          <ul className="text-center space-y-6">
            <li><a href="/" className="text-2xl hover:text-pink-600">ホーム</a></li>
            <li><a href="/pages/philosophy" className="text-2xl hover:text-pink-600">御菓子処うさぎやの想い</a></li>
            <li><a href="/featured_products" className="text-2xl hover:text-pink-600">おすすめ商品</a></li>
            <li><a href="/seasonal_products" className="text-2xl hover:text-pink-600">季節限定商品</a></li>
            <li><a href="/products" className="text-2xl hover:text-pink-600">全商品一覧</a></li>
            <li><a href="/orders/new" className="text-2xl hover:text-pink-600">冷凍もちパイの発送</a></li>
            <li>
              <a 
                href="https://www.satofull.jp/products/list.php?s4=18&q=%E3%81%86%E3%81%95%E3%81%8E%E3%82%84&cnt=60&p=1"
                target="_blank"
                rel="noopener noreferrer"
                className="text-2xl hover:text-pink-600"
              >
                さとふる
              </a>
            </li>
            <li><a href="/notices" className="text-2xl hover:text-pink-600">お知らせ</a></li>
            <li><a href="/calendar_events" className="text-2xl hover:text-pink-600">営業カレンダー</a></li>
            <li>
              <a 
                href="https://page.line.me/296kbwry?openQrModal=true"
                target="_blank"
                rel="noopener noreferrer"
                className="text-2xl hover:text-pink-600"
              >
                LINE
              </a>
            </li>
            <li>
              <a 
                href="https://www.instagram.com/usagiya.fukui/?hl=ja"
                target="_blank"
                rel="noopener noreferrer"
                className="text-2xl hover:text-pink-600"
              >
                Instagram
              </a>
            </li>
            <li><a href="/inquiries/new" className="text-2xl hover:text-pink-600">お問い合わせ</a></li>
          </ul>
        </nav>
      </div>

      {/* メインビジュアル（スライドショー） */}
      <section className="relative w-full h-screen mt-20">
        {slides.map((slide, index) => (
          <div
            key={index}
            className={`absolute inset-0 transition-opacity duration-1000 ${
              index === currentSlide ? 'opacity-100' : 'opacity-0'
            }`}
          >
            {slide.link ? (
              <a href={slide.link} target="_blank" rel="noopener noreferrer">
                <img
                  src={slide.image}
                  alt={slide.alt}
                  className="w-full h-full object-cover"
                />
              </a>
            ) : (
              <img
                src={slide.image}
                alt={slide.alt}
                className="w-full h-full object-cover"
              />
            )}
          </div>
        ))}

        {/* スライドインジケーター */}
        <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 flex space-x-2">
          {slides.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentSlide(index)}
              className={`w-3 h-3 rounded-full ${
                index === currentSlide ? 'bg-white' : 'bg-white/50'
              }`}
              aria-label={`スライド${index + 1}`}
            />
          ))}
        </div>
      </section>

      {/* コンテンツエリア */}
      <div className="container mx-auto px-4 py-16">
        {/* お知らせセクション */}
        {recent_notices.length > 0 && (
          <section className="mb-16">
            <h2 className="text-3xl font-bold text-center mb-8 text-gray-800">お知らせ</h2>
            <div className="space-y-4">
              {recent_notices.map((notice) => (
                <a
                  key={notice.id}
                  href={`/notices/${notice.id}`}
                  className="block p-6 bg-white rounded-lg shadow hover:shadow-lg transition-shadow"
                >
                  <div className="flex justify-between items-start">
                    <h3 className="text-xl font-semibold text-gray-800">{notice.title}</h3>
                    <span className="text-sm text-gray-500">
                      {new Date(notice.published_at).toLocaleDateString('ja-JP')}
                    </span>
                  </div>
                  <div className="mt-2 text-gray-600 line-clamp-2">
                    {notice.content.replace(/<[^>]*>/g, '')}
                  </div>
                </a>
              ))}
            </div>
            <div className="text-center mt-8">
              <a
                href="/notices"
                className="inline-block px-6 py-3 bg-pink-600 text-white rounded-lg hover:bg-pink-700 transition-colors"
              >
                お知らせ一覧を見る
              </a>
            </div>
          </section>
        )}

        {/* おすすめ商品プレビュー */}
        {featured_products.length > 0 && (
          <section className="mb-16">
            <h2 className="text-3xl font-bold text-center mb-8 text-gray-800">おすすめ商品</h2>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
              {featured_products.slice(0, 5).map((product) => (
                <a
                  key={product.id}
                  href={`/products/${product.id}`}
                  className="block group"
                >
                  <div className="aspect-square bg-gray-200 rounded-lg overflow-hidden mb-3">
                    {product.image_url ? (
                      <img
                        src={product.image_url}
                        alt={product.name}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform"
                      />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-gray-400">
                        画像なし
                      </div>
                    )}
                  </div>
                  <h3 className="text-lg font-semibold text-gray-800 group-hover:text-pink-600">
                    {product.name}
                  </h3>
                  <p className="text-gray-600">¥{product.price.toLocaleString()}</p>
                </a>
              ))}
            </div>
            <div className="text-center mt-8">
              <a
                href="/featured_products"
                className="inline-block px-6 py-3 bg-pink-600 text-white rounded-lg hover:bg-pink-700 transition-colors"
              >
                おすすめ商品一覧を見る
              </a>
            </div>
          </section>
        )}

        {/* 季節限定商品プレビュー */}
        {seasonal_products.length > 0 && (
          <section className="mb-16">
            <h2 className="text-3xl font-bold text-center mb-8 text-gray-800">季節限定商品</h2>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
              {seasonal_products.slice(0, 5).map((product) => (
                <a
                  key={product.id}
                  href={`/products/${product.id}`}
                  className="block group"
                >
                  <div className="aspect-square bg-gray-200 rounded-lg overflow-hidden mb-3">
                    {product.image_url ? (
                      <img
                        src={product.image_url}
                        alt={product.name}
                        className="w-full h-full object-cover group-hover:scale-105 transition-transform"
                      />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-gray-400">
                        画像なし
                      </div>
                    )}
                  </div>
                  <h3 className="text-lg font-semibold text-gray-800 group-hover:text-pink-600">
                    {product.name}
                  </h3>
                  <p className="text-gray-600">¥{product.price.toLocaleString()}</p>
                </a>
              ))}
            </div>
            <div className="text-center mt-8">
              <a
                href="/seasonal_products"
                className="inline-block px-6 py-3 bg-pink-600 text-white rounded-lg hover:bg-pink-700 transition-colors"
              >
                季節限定商品一覧を見る
              </a>
            </div>
          </section>
        )}

        {/* 店舗情報セクション */}
        <section className="bg-pink-50 rounded-lg p-8" id="shop-info">
          <h2 className="text-3xl font-bold text-center mb-8 text-gray-800">店舗情報</h2>
          <div className="grid md:grid-cols-2 gap-8">
            <div>
              <h3 className="text-xl font-semibold mb-4 text-gray-800">住所</h3>
              <p className="text-gray-700">
                〒910-0001<br />
                福井県鯖江市持明寺町5-10-1
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold mb-4 text-gray-800">営業時間</h3>
              <p className="text-gray-700">
                平日・土曜日: 9:00〜18:00<br />
                定休日: 日曜日<br />
                （月曜日に不定休あり）
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold mb-4 text-gray-800">電話番号</h3>
              <p className="text-gray-700">
                <a href="tel:0778-51-2889" className="hover:text-pink-600">
                  0778-51-2889
                </a>
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold mb-4 text-gray-800">アクセス</h3>
              <p className="text-gray-700">
                バス停「持明寺」下車すぐ
              </p>
            </div>
          </div>
        </section>
      </div>

      {/* フッター */}
      <footer className="bg-gray-800 text-white py-8">
        <div className="container mx-auto px-4 text-center">
          <p>&copy; 2025 御菓子処うさぎや All Rights Reserved.</p>
          <div className="mt-4 flex justify-center space-x-6">
            <a
              href="https://page.line.me/296kbwry?openQrModal=true"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-pink-400 transition-colors"
            >
              LINE
            </a>
            <a
              href="https://www.instagram.com/usagiya.fukui/?hl=ja"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-pink-400 transition-colors"
            >
              Instagram
            </a>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default Home