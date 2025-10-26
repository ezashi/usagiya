// Trixエディタの日本語化と機能拡張

document.addEventListener('DOMContentLoaded', function() {
  // Trixエディタの日本語化
  if (typeof Trix !== 'undefined') {
    // ツールバーボタンの日本語化
    Trix.config.lang = {
      bold: "太字",
      italic: "斜体",
      strike: "取り消し線",
      link: "リンク",
      heading1: "見出し",
      quote: "引用",
      code: "コード",
      bullets: "箇条書き",
      numbers: "番号付きリスト",
      outdent: "インデント解除",
      indent: "インデント",
      attachFiles: "ファイルを添付",
      undo: "元に戻す",
      redo: "やり直し",
      remove: "削除"
    };

    // ツールバーのカスタマイズ
    Trix.config.toolbar = {
      getDefaultHTML: function() { return `
        <div class="trix-button-row">
          <span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">
            <button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="太字" tabindex="-1">太字</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-italic" data-trix-attribute="italic" data-trix-key="i" title="斜体" tabindex="-1">斜体</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-strike" data-trix-attribute="strike" title="取り消し線" tabindex="-1">取消</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-link" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="リンク" tabindex="-1">リンク</button>
          </span>
          <span class="trix-button-group trix-button-group--block-tools" data-trix-button-group="block-tools">
            <button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-attribute="heading1" title="見出し" tabindex="-1">見出し</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-quote" data-trix-attribute="quote" title="引用" tabindex="-1">引用</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-code" data-trix-attribute="code" title="コード" tabindex="-1">コード</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-bullet-list" data-trix-attribute="bullet" title="箇条書き" tabindex="-1">●</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-number-list" data-trix-attribute="number" title="番号付きリスト" tabindex="-1">1.</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-decrease-nesting-level" data-trix-action="decreaseNestingLevel" title="インデント解除" tabindex="-1">←</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-increase-nesting-level" data-trix-action="increaseNestingLevel" title="インデント" tabindex="-1">→</button>
          </span>
          <span class="trix-button-group trix-button-group--file-tools" data-trix-button-group="file-tools">
            <button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="attachFiles" title="画像・ファイルを添付" tabindex="-1">📎</button>
          </span>
          <span class="trix-button-group-spacer"></span>
          <span class="trix-button-group trix-button-group--history-tools" data-trix-button-group="history-tools">
            <button type="button" class="trix-button trix-button--icon trix-button--icon-undo" data-trix-action="undo" data-trix-key="z" title="元に戻す" tabindex="-1">↶</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-redo" data-trix-action="redo" data-trix-key="shift+z" title="やり直し" tabindex="-1">↷</button>
          </span>
        </div>
        <div class="trix-dialogs" data-trix-dialogs>
          <div class="trix-dialog trix-dialog--link" data-trix-dialog="href" data-trix-dialog-attribute="href">
            <div class="trix-dialog__link-fields">
              <input type="url" name="href" class="trix-input trix-input--dialog" placeholder="URLを入力してください" aria-label="URL" required data-trix-input>
              <div class="trix-button-group">
                <input type="button" class="trix-button trix-button--dialog" value="リンク" data-trix-method="setAttribute">
                <input type="button" class="trix-button trix-button--dialog" value="リンク解除" data-trix-method="removeAttribute">
              </div>
            </div>
          </div>
        </div>
      `; }
    };
  }

  // 画像リサイズ機能の追加
  function enableImageResizing() {
    document.addEventListener('trix-attachment-add', function(event) {
      const attachment = event.attachment;

      if (attachment.file && attachment.file.type.startsWith('image/')) {
        setTimeout(() => {
          const figures = document.querySelectorAll('trix-editor figure[data-trix-attachment]');
          figures.forEach(figure => {
            const img = figure.querySelector('img');
            if (img && !img.classList.contains('resizable')) {
              makeImageResizable(img, figure);
            }
          });
        }, 100);
      }
    });

    // 既存の画像にもリサイズ機能を追加
    setTimeout(() => {
      const figures = document.querySelectorAll('trix-editor figure[data-trix-attachment]');
      figures.forEach(figure => {
        const img = figure.querySelector('img');
        if (img && !img.classList.contains('resizable')) {
          makeImageResizable(img, figure);
        }
      });
    }, 500);
  }

  function makeImageResizable(img, figure) {
    img.classList.add('resizable');
    img.style.cursor = 'nwse-resize';
    img.style.maxWidth = '100%';
    img.style.height = 'auto';

    let isResizing = false;
    let startX, startY, startWidth, startHeight;

    // リサイズハンドルを追加
    const resizeHandle = document.createElement('div');
    resizeHandle.className = 'image-resize-handle';
    resizeHandle.style.cssText = `
      position: absolute;
      bottom: -5px;
      right: -5px;
      width: 10px;
      height: 10px;
      background: #3b82f6;
      border: 2px solid white;
      border-radius: 50%;
      cursor: nwse-resize;
      z-index: 10;
      box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    `;

    figure.style.position = 'relative';
    figure.style.display = 'inline-block';
    figure.appendChild(resizeHandle);

    resizeHandle.addEventListener('mousedown', function(e) {
      e.preventDefault();
      e.stopPropagation();
      isResizing = true;
      startX = e.clientX;
      startY = e.clientY;
      startWidth = img.offsetWidth;
      startHeight = img.offsetHeight;

      document.addEventListener('mousemove', onMouseMove);
      document.addEventListener('mouseup', onMouseUp);
    });

    function onMouseMove(e) {
      if (!isResizing) return;

      const deltaX = e.clientX - startX;
      const aspectRatio = startWidth / startHeight;
      const newWidth = Math.max(100, startWidth + deltaX);

      img.style.width = newWidth + 'px';
      img.style.height = (newWidth / aspectRatio) + 'px';
    }

    function onMouseUp() {
      isResizing = false;
      document.removeEventListener('mousemove', onMouseMove);
      document.removeEventListener('mouseup', onMouseUp);
    }
  }

  // 画像リサイズ機能を有効化
  enableImageResizing();

  // Word風の自動改行スタイルを適用
  const trixEditors = document.querySelectorAll('trix-editor');
  trixEditors.forEach(editor => {
    editor.style.wordWrap = 'break-word';
    editor.style.overflowWrap = 'break-word';
    editor.style.whiteSpace = 'pre-wrap';
  });
});

// 画像リサイズ用のCSSを追加
const style = document.createElement('style');
style.textContent = `
  trix-editor figure[data-trix-attachment] {
    position: relative;
    display: inline-block;
  }

  trix-editor img.resizable {
    cursor: nwse-resize;
    max-width: 100%;
    height: auto;
  }

  trix-editor figure[data-trix-attachment]:hover .image-resize-handle {
    opacity: 1;
  }

  .image-resize-handle {
    opacity: 0;
    transition: opacity 0.2s ease;
  }

  /* Word風の改行スタイル */
  trix-editor {
    word-wrap: break-word !important;
    overflow-wrap: break-word !important;
    white-space: pre-wrap !important;
    overflow-x: hidden !important;
  }

  trix-editor * {
    max-width: 100%;
  }

  /* ツールバーボタンのスタイル改善 */
  trix-toolbar .trix-button {
    font-size: 0.875rem;
    padding: 0.5rem;
  }

  trix-toolbar .trix-button:not(.trix-button--icon) {
    font-weight: 500;
  }
`;
document.head.appendChild(style);