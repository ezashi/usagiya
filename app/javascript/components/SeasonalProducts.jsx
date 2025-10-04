import React, { useState, useEffect } from 'react'
import { motion } from 'framer-motion'

const getInitialBgColor = () => {
  const colors = ['#fff', '#F9F9F9']
  return colors[Math.floor(Math.random() * colors.length)]
}

const getRandomHoverColor = () => {
  const colors = ['#EE827C', '#165e83', '#ffae8a', '#F0908D', '#e1e3e6', '#ee836f', '#2e4b71', '#eee8aa', '#ede4e1']
  return colors[Math.floor(Math.random() * colors.length)]
}

// レスポンシブなカードサイズを計算
const getCardSize = () => {
  if (typeof window === 'undefined') return '350px'
  const width = window.innerWidth
  if (width >= 1440) return '28.5vw' // 3.5個表示
  if (width >= 1024) return '33.3vw' // 3個表示
  if (width >= 768) return '50vw'    // 2個表示
  return '80vw' // モバイル: 1.2個表示
}

const SeasonalProducts = ({ products = [] }) => {
  const [layout, setLayout] = useState('animation')
  const [titleHover, setTitleHover] = useState(false)
  const [initialBgColor, setInitialBgColor] = useState('#fff')
  const [currentBgColor, setCurrentBgColor] = useState('#fff')
  const [cardSize, setCardSize] = useState('350px')
  const [titleFontSize, setTitleFontSize] = useState('2.25rem')

  useEffect(() => {
    const color = getInitialBgColor()
    setInitialBgColor(color)
    setCurrentBgColor(color)
    setCardSize(getCardSize())

    // タイトルのフォントサイズを設定
    const updateFontSize = () => {
      const width = window.innerWidth
      if (width >= 768) {
        setTitleFontSize('2.25rem') // PC/タブレット
      } else if (width >= 480) {
        setTitleFontSize('1.5rem') // 小型タブレット/大型モバイル
      } else {
        setTitleFontSize('1.25rem') // 小型モバイル
      }
    }

    updateFontSize()

    const handleResize = () => {
      setCardSize(getCardSize())
      updateFontSize()
    }
    window.addEventListener('resize', handleResize)
    return () => window.removeEventListener('resize', handleResize)
  }, [])

  const handleProductHoverEnter = () => {
    setCurrentBgColor(getRandomHoverColor())
  }

  const handleProductHoverLeave = () => {
    setCurrentBgColor(initialBgColor)
  }

  if (products.length === 0) {
    return (
      <div style={{ padding: '2rem' }}>
        <h1 style={{ fontSize: '1.875rem', fontWeight: 'bold', marginBottom: '2rem', textAlign: 'center' }}>
          季節限定商品
        </h1>
        <p style={{ textAlign: 'center', color: '#4B5563' }}>現在、季節限定商品はありません。</p>
      </div>
    )
  }

  // アニメーション用に商品を十分な回数繰り返す（途切れないように）
  const repeatedProducts = Array(10).fill(products).flat()

  return (
    <div 
      style={{ 
        minHeight: '100vh', 
        paddingTop: '140px',
        paddingBottom: '2rem',
        backgroundColor: currentBgColor,
        transition: 'background-color 0.5s'
      }}
    >
      {/* ヘッダー */}
      <div style={{ 
        padding: '0 1rem',
        marginBottom: '2rem',
        background: 'none',
        backgroundColor: 'transparent'
      }}>
        <div style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'center',
          maxWidth: '1280px',
          margin: '0 auto',
          background: 'none',
          backgroundColor: 'transparent'
        }}>
          {/* タイトル */}
          <h1 
            style={{
              fontSize: titleFontSize,
              fontWeight: 'bold',
              color: titleHover ? '#D5016B' : '#fff',
              WebkitTextStroke: '1px #000',
              cursor: 'default',
              transition: 'color 0.3s, font-size 0.3s',
              background: 'none'
            }}
            onMouseEnter={() => setTitleHover(true)}
            onMouseLeave={() => setTitleHover(false)}
          >
            季節限定商品
          </h1>

          {/* レイアウト切り替えボタン */}
          <div style={{ display: 'flex', gap: '1rem' }}>
            <button
              onClick={() => setLayout('animation')}
              style={{
                padding: '0.75rem 1.5rem',
                borderRadius: '0.5rem',
                fontWeight: '600',
                backgroundColor: layout === 'animation' ? '#ffc0cb' : '#fff',
                color: layout === 'animation' ? '#fff' : '#D5016B',
                border: layout === 'animation' ? 'none' : '2px solid #DB2777',
                cursor: 'pointer',
                transition: 'all 0.3s',
                boxShadow: layout === 'animation' ? '0 4px 6px rgba(0,0,0,0.1)' : 'none'
              }}
            >
              🎬 Motion
            </button>
            <button
              onClick={() => setLayout('grid')}
              style={{
                padding: '0.75rem 1.5rem',
                borderRadius: '0.5rem',
                fontWeight: '600',
                backgroundColor: layout === 'grid' ? '#ffc0cb' : '#fff',
                color: layout === 'grid' ? '#fff' : '#D5016B',
                border: layout === 'grid' ? 'none' : '2px solid #DB2777',
                cursor: 'pointer',
                transition: 'all 0.3s',
                boxShadow: layout === 'grid' ? '0 4px 6px rgba(0,0,0,0.1)' : 'none'
              }}
            >
              📋 Grid
            </button>
          </div>
        </div>
      </div>

      {/* レイアウト1: アニメーション表示 */}
      {layout === 'animation' && (
        <div style={{ overflow: 'hidden', paddingBottom: '3rem' }}>
          <motion.div
            style={{ display: 'flex', gap: '1.5rem' }}
            animate={{
              x: [0, -(parseFloat(cardSize) + 24) * products.length],
            }}
            transition={{
              x: {
                repeat: Infinity,
                repeatType: "loop",
                duration: products.length * 1,
                ease: "linear",
              },
            }}
          >
            {repeatedProducts.map((product, index) => (
              <motion.div
                key={`${product.id}-${index}`}
                style={{ 
                  flexShrink: 0,
                  width: cardSize,
                }}
                onMouseEnter={handleProductHoverEnter}
                onMouseLeave={handleProductHoverLeave}
                whileHover={{ scale: 1.05 }}
                transition={{ type: "spring", stiffness: 300 }}
              >
                <a href={`/products/${product.id}`} style={{ display: 'block', textDecoration: 'none' }}>
                  {/* 商品画像エリア */}
                  <div 
                    style={{ 
                      width: '100%',
                      height: cardSize,
                      backgroundColor: '#fff',
                      borderRadius: '0.5rem',
                      boxShadow: '0 10px 15px rgba(0,0,0,0.1)',
                      overflow: 'hidden',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      marginBottom: '1rem'
                    }}
                  >
                    {product.image_url ? (
                      <img
                        src={product.image_url}
                        alt={product.name}
                        style={{
                          maxWidth: '90%',
                          maxHeight: '90%',
                          objectFit: 'contain',
                          padding: '1rem'
                        }}
                      />
                    ) : (
                      <div style={{
                        width: '100%',
                        height: '100%',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        color: '#9CA3AF',
                        fontSize: '1.125rem'
                      }}>
                        画像なし
                      </div>
                    )}
                  </div>

                  {/* 商品名 */}
                  <h3 style={{
                    fontSize: '1.25rem',
                    fontWeight: 'bold',
                    textAlign: 'center',
                    color: '#fff',
                    WebkitTextStroke: '3px #000',
                    paintOrder: 'stroke fill',
                    padding: '0 0.5rem',
                    lineHeight: '1.5'
                  }}>
                    {product.name}
                  </h3>
                </a>
              </motion.div>
            ))}
          </motion.div>
        </div>
      )}

      {/* レイアウト2: グリッド表示 */}
      {layout === 'grid' && (
        <div style={{ padding: '0 1rem', maxWidth: '1280px', margin: '0 auto' }}>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fill, minmax(180px, 1fr))',
            gap: '1.5rem'
          }}>
            {products.map((product) => (
              <motion.div
                key={product.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                onMouseEnter={handleProductHoverEnter}
                onMouseLeave={handleProductHoverLeave}
                whileHover={{ scale: 1.05 }}
                style={{ paddingBottom: '1rem' }}
              >
                <a href={`/products/${product.id}`} style={{ display: 'block', textDecoration: 'none' }}>
                  {/* 商品画像エリア */}
                  <div style={{
                    aspectRatio: '1',
                    backgroundColor: '#fff',
                    borderRadius: '0.5rem',
                    boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
                    overflow: 'hidden',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    padding: '1rem',
                    marginBottom: '0.5rem'
                  }}>
                    {product.image_url ? (
                      <img
                        src={product.image_url}
                        alt={product.name}
                        style={{
                          maxWidth: '100%',
                          maxHeight: '100%',
                          objectFit: 'contain'
                        }}
                      />
                    ) : (
                      <div style={{
                        width: '100%',
                        height: '100%',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        color: '#9CA3AF',
                        fontSize: '0.875rem'
                      }}>
                        画像なし
                      </div>
                    )}
                  </div>

                  {/* 商品名 */}
                  <h3 style={{
                    fontSize: '0.875rem',
                    fontWeight: '600',
                    textAlign: 'center',
                    color: '#fff',
                    WebkitTextStroke: '2px #000',
                    paintOrder: 'stroke fill',
                    padding: '0 0.25rem',
                    lineHeight: '1.5'
                  }}>
                    {product.name}
                  </h3>
                </a>
              </motion.div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

export default SeasonalProducts