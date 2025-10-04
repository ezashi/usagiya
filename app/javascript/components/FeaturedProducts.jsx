import React, { useState, useEffect } from 'react'
import { motion } from 'framer-motion'

const getInitialBgColor = () => {
  const colors = ['#fff', '#000']
  return colors[Math.floor(Math.random() * colors.length)]
}

const getRandomHoverColor = () => {
  const colors = ['#EE827C', '#F0908D', '#F9F9F9']
  return colors[Math.floor(Math.random() * colors.length)]
}

const FeaturedProducts = ({ products = [] }) => {
  const [layout, setLayout] = useState('animation')
  const [titleHover, setTitleHover] = useState(false)
  const [initialBgColor, setInitialBgColor] = useState('#fff')
  const [currentBgColor, setCurrentBgColor] = useState('#fff')

  useEffect(() => {
    const color = getInitialBgColor()
    setInitialBgColor(color)
    setCurrentBgColor(color)
  }, [])

  const handleProductHoverEnter = () => {
    setCurrentBgColor(getRandomHoverColor())
  }

  const handleProductHoverLeave = () => {
    setCurrentBgColor(initialBgColor)
  }

  if (products.length === 0) {
    return (
      <div className="container mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8 text-center">おすすめ商品</h1>
        <p className="text-center text-gray-600">現在、おすすめ商品はありません。</p>
      </div>
    )
  }

  return (
    <div 
      className="min-h-screen py-8 transition-colors duration-500"
      style={{ backgroundColor: currentBgColor }}
    >
      {/* ヘッダー - 背景を透明に */}
      <div className="container mx-auto px-4 mb-8" style={{ backgroundColor: 'transparent' }}>
        <div className="flex justify-between items-center" style={{ backgroundColor: 'transparent' }}>
          {/* タイトル（左寄せ） */}
          <h1 
            className="text-4xl font-bold transition-all"
            style={{
              color: titleHover ? '#D5016B' : '#fff',
              WebkitTextStroke: '2px #000',
              cursor: 'default'
            }}
            onMouseEnter={() => setTitleHover(true)}
            onMouseLeave={() => setTitleHover(false)}
          >
            おすすめ商品
          </h1>

          {/* レイアウト切り替えボタン（右寄せ） */}
          <div className="flex gap-4">
            <button
              onClick={() => setLayout('animation')}
              className={`px-6 py-3 rounded-lg font-semibold transition-all ${
                layout === 'animation'
                  ? 'bg-pink-600 text-white shadow-lg'
                  : 'bg-white text-pink-600 border-2 border-pink-600 hover:bg-pink-50'
              }`}
            >
              🎬 Motion
            </button>
            <button
              onClick={() => setLayout('grid')}
              className={`px-6 py-3 rounded-lg font-semibold transition-all ${
                layout === 'grid'
                  ? 'bg-pink-600 text-white shadow-lg'
                  : 'bg-white text-pink-600 border-2 border-pink-600 hover:bg-pink-50'
              }`}
            >
              📋 List
            </button>
          </div>
        </div>
      </div>

      {/* レイアウト1: アニメーション表示 */}
      {layout === 'animation' && (
        <div className="overflow-hidden">
          <motion.div
            className="flex gap-8"
            animate={{
              x: [0, -100 * products.length],
            }}
            transition={{
              x: {
                repeat: Infinity,
                repeatType: "loop",
                duration: products.length * 3,
                ease: "linear",
              },
            }}
          >
            {[...products, ...products].map((product, index) => (
              <motion.a
                key={`${product.id}-${index}`}
                href={`/products/${product.id}`}
                className="flex-shrink-0 block group"
                style={{ width: '600px', height: '600px' }}
                onMouseEnter={handleProductHoverEnter}
                onMouseLeave={handleProductHoverLeave}
                whileHover={{ scale: 1.05 }}
                transition={{ type: "spring", stiffness: 300 }}
              >
                <div className="w-full h-full bg-white rounded-lg shadow-lg overflow-hidden relative flex items-center justify-center">
                  {product.image_url ? (
                    <>
                      <img
                        src={product.image_url}
                        alt={product.name}
                        className="max-w-full max-h-full object-contain"
                        style={{ maxWidth: '90%', maxHeight: '90%' }}
                      />
                      <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                        <h3 className="text-2xl font-bold text-white px-4 py-2 rounded"
                            style={{ 
                              backgroundColor: 'rgba(0, 0, 0, 0.6)',
                              textShadow: '2px 2px 4px rgba(0, 0, 0, 0.8)'
                            }}>
                          {product.name}
                        </h3>
                      </div>
                    </>
                  ) : (
                    <div className="w-full h-full flex flex-col items-center justify-center text-gray-400 text-lg">
                      <div>画像なし</div>
                      <h3 className="text-2xl font-bold text-gray-800 mt-4">
                        {product.name}
                      </h3>
                    </div>
                  )}
                </div>
              </motion.a>
            ))}
          </motion.div>
        </div>
      )}

      {/* レイアウト2: グリッド表示 */}
      {layout === 'grid' && (
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6">
            {products.map((product) => (
              <motion.a
                key={product.id}
                href={`/products/${product.id}`}
                className="block group bg-white rounded-lg shadow-md overflow-hidden transition-shadow relative"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                onMouseEnter={handleProductHoverEnter}
                onMouseLeave={handleProductHoverLeave}
                whileHover={{ scale: 1.1 }}
              >
                <div className="aspect-square relative flex items-center justify-center p-4">
                  {product.image_url ? (
                    <>
                      <img
                        src={product.image_url}
                        alt={product.name}
                        className="max-w-full max-h-full object-contain"
                      />
                      <div className="absolute bottom-0 left-0 right-0 bg-black bg-opacity-60 text-white p-2">
                        <h3 className="text-sm font-semibold text-center truncate">
                          {product.name}
                        </h3>
                      </div>
                    </>
                  ) : (
                    <div className="w-full h-full flex flex-col items-center justify-center text-gray-400">
                      <div className="text-sm">画像なし</div>
                      <h3 className="text-sm font-bold text-gray-800 mt-2 text-center px-2">
                        {product.name}
                      </h3>
                    </div>
                  )}
                </div>
              </motion.a>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

export default FeaturedProducts