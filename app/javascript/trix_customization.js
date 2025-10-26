// Trixエディタの日本語化と機能拡張

document.addEventListener('trix-before-initialize', function() {
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
      attachFiles: "画像を挿入",
      undo: "元に戻す",
      redo: "やり直し",
      remove: "削除"
    };

    // ツールバーのカスタマイズ（日本語化）
    Trix.config.toolbar.getDefaultHTML = function() {
      return `
        <div class="trix-button-row">
          <span class="trix-button-group trix-button-group--text-tools" data-trix-button-group="text-tools">
            <button type="button" class="trix-button trix-button--icon trix-button--icon-bold" data-trix-attribute="bold" data-trix-key="b" title="太字" tabindex="-1">太字</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-italic" data-trix-attribute="italic" data-trix-key="i" title="斜体" tabindex="-1">斜体</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-strike" data-trix-attribute="strike" title="取り消し線" tabindex="-1">取消線</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-link" data-trix-attribute="href" data-trix-action="link" data-trix-key="k" title="リンク" tabindex="-1">リンク</button>
          </span>
          <span class="trix-button-group trix-button-group--block-tools" data-trix-button-group="block-tools">
            <button type="button" class="trix-button trix-button--icon trix-button--icon-heading-1" data-trix-attribute="heading1" title="見出し" tabindex="-1">見出し</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-quote" data-trix-attribute="quote" title="引用" tabindex="-1">引用</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-code" data-trix-attribute="code" title="コード" tabindex="-1">コード</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-bullet-list" data-trix-attribute="bullet" title="箇条書き" tabindex="-1">● リスト</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-number-list" data-trix-attribute="number" title="番号付きリスト" tabindex="-1">1. 番号</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-decrease-nesting-level" data-trix-action="decreaseNestingLevel" title="インデント解除" tabindex="-1">← 戻す</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-increase-nesting-level" data-trix-action="increaseNestingLevel" title="インデント" tabindex="-1">→ 進む</button>
          </span>
          <span class="trix-button-group trix-button-group--file-tools" data-trix-button-group="file-tools">
            <button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="attachFiles" title="画像を挿入" tabindex="-1">📷 画像</button>
          </span>
          <span class="trix-button-group-spacer"></span>
          <span class="trix-button-group trix-button-group--history-tools" data-trix-button-group="history-tools">
            <button type="button" class="trix-button trix-button--icon trix-button--icon-undo" data-trix-action="undo" data-trix-key="z" title="元に戻す" tabindex="-1">↶ 戻す</button>
            <button type="button" class="trix-button trix-button--icon trix-button--icon-redo" data-trix-action="redo" data-trix-key="shift+z" title="やり直し" tabindex="-1">↷ 進む</button>
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
      `;
    };
  }
});

document.addEventListener('DOMContentLoaded', function() {

  // 画像リサイズ機能の追加（Word風）
  function enableImageResizing() {
    // 新しい画像が追加されたとき
    document.addEventListener('trix-attachment-add', function(event) {
      const attachment = event.attachment;
      if (attachment.file && attachment.file.type.startsWith('image/')) {
        setTimeout(() => {
          applyResizeToAllImages();
        }, 200);
      }
    });

    // 既存の画像にもリサイズ機能を追加
    setTimeout(() => {
      applyResizeToAllImages();
    }, 500);

    // ページが読み込まれたときにも適用
    document.addEventListener('turbo:load', function() {
      setTimeout(() => {
        applyResizeToAllImages();
      }, 200);
    });
  }

  function applyResizeToAllImages() {
    const figures = document.querySelectorAll('trix-editor figure[data-trix-attachment]');
    figures.forEach(figure => {
      const img = figure.querySelector('img');
      if (img && !img.classList.contains('resizable')) {
        makeImageResizable(img, figure);
      }
    });
  }

  function makeImageResizable(img, figure) {
    img.classList.add('resizable');
    img.style.maxWidth = '100%';
    img.style.height = 'auto';
    img.style.display = 'block';

    // 画像を選択状態にする
    let isSelected = false;
    let isResizing = false;
    let startX, startY, startWidth, startHeight, currentHandle;

    // 既存のリサイズハンドルを削除
    const existingHandles = figure.querySelectorAll('.resize-handle');
    existingHandles.forEach(h => h.remove());

    // リサイズハンドルを8つ追加（Word風）
    const handles = ['nw', 'n', 'ne', 'e', 'se', 's', 'sw', 'w'];
    const handleElements = [];

    handles.forEach(position => {
      const handle = document.createElement('div');
      handle.className = `resize-handle resize-handle-${position}`;
      handle.style.cssText = `
        position: absolute;
        width: 8px;
        height: 8px;
        background: white;
        border: 1px solid #3b82f6;
        z-index: 100;
        display: none;
      `;

      // 位置の設定
      switch(position) {
        case 'nw':
          handle.style.top = '-4px';
          handle.style.left = '-4px';
          handle.style.cursor = 'nwse-resize';
          break;
        case 'n':
          handle.style.top = '-4px';
          handle.style.left = '50%';
          handle.style.transform = 'translateX(-50%)';
          handle.style.cursor = 'ns-resize';
          break;
        case 'ne':
          handle.style.top = '-4px';
          handle.style.right = '-4px';
          handle.style.cursor = 'nesw-resize';
          break;
        case 'e':
          handle.style.top = '50%';
          handle.style.right = '-4px';
          handle.style.transform = 'translateY(-50%)';
          handle.style.cursor = 'ew-resize';
          break;
        case 'se':
          handle.style.bottom = '-4px';
          handle.style.right = '-4px';
          handle.style.cursor = 'nwse-resize';
          break;
        case 's':
          handle.style.bottom = '-4px';
          handle.style.left = '50%';
          handle.style.transform = 'translateX(-50%)';
          handle.style.cursor = 'ns-resize';
          break;
        case 'sw':
          handle.style.bottom = '-4px';
          handle.style.left = '-4px';
          handle.style.cursor = 'nesw-resize';
          break;
        case 'w':
          handle.style.top = '50%';
          handle.style.left = '-4px';
          handle.style.transform = 'translateY(-50%)';
          handle.style.cursor = 'ew-resize';
          break;
      }

      handleElements.push(handle);
      figure.appendChild(handle);

      // ハンドルのドラッグイベント
      handle.addEventListener('mousedown', function(e) {
        e.preventDefault();
        e.stopPropagation();
        isResizing = true;
        currentHandle = position;
        startX = e.clientX;
        startY = e.clientY;
        startWidth = img.offsetWidth;
        startHeight = img.offsetHeight;

        document.addEventListener('mousemove', onMouseMove);
        document.addEventListener('mouseup', onMouseUp);
      });
    });

    // 画像のスタイル設定
    figure.style.position = 'relative';
    figure.style.display = 'inline-block';
    figure.style.border = '2px solid transparent';
    figure.style.padding = '2px';
    figure.style.margin = '10px 0';

    // 画像をクリックしたら選択状態にする
    img.addEventListener('click', function(e) {
      e.stopPropagation();
      selectImage();
    });

    function selectImage() {
      // 他の画像の選択を解除
      document.querySelectorAll('trix-editor figure[data-trix-attachment]').forEach(f => {
        f.style.border = '2px solid transparent';
        f.querySelectorAll('.resize-handle').forEach(h => h.style.display = 'none');
      });

      // この画像を選択
      isSelected = true;
      figure.style.border = '2px solid #3b82f6';
      handleElements.forEach(h => h.style.display = 'block');
    }

    function deselectImage() {
      isSelected = false;
      figure.style.border = '2px solid transparent';
      handleElements.forEach(h => h.style.display = 'none');
    }

    // エディタ外をクリックしたら選択解除
    document.addEventListener('click', function(e) {
      if (!figure.contains(e.target)) {
        deselectImage();
      }
    });

    function onMouseMove(e) {
      if (!isResizing) return;

      const deltaX = e.clientX - startX;
      const deltaY = e.clientY - startY;
      const aspectRatio = startWidth / startHeight;
      let newWidth = startWidth;
      let newHeight = startHeight;

      // ハンドルの位置に応じてリサイズ
      switch(currentHandle) {
        case 'e':
        case 'w':
          newWidth = Math.max(50, startWidth + (currentHandle === 'e' ? deltaX : -deltaX));
          newHeight = newWidth / aspectRatio;
          break;
        case 'n':
        case 's':
          newHeight = Math.max(50, startHeight + (currentHandle === 's' ? deltaY : -deltaY));
          newWidth = newHeight * aspectRatio;
          break;
        case 'se':
        case 'nw':
          newWidth = Math.max(50, startWidth + (currentHandle === 'se' ? deltaX : -deltaX));
          newHeight = newWidth / aspectRatio;
          break;
        case 'ne':
        case 'sw':
          newWidth = Math.max(50, startWidth + (currentHandle === 'ne' ? deltaX : -deltaX));
          newHeight = newWidth / aspectRatio;
          break;
      }

      img.style.width = newWidth + 'px';
      img.style.height = newHeight + 'px';
    }

    function onMouseUp() {
      isResizing = false;
      currentHandle = null;
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

// Word風のスタイルを追加
const style = document.createElement('style');
style.textContent = `
  /* Word風のエディタスタイル */
  trix-editor {
    word-wrap: break-word !important;
    overflow-wrap: break-word !important;
    white-space: pre-wrap !important;
    overflow-x: hidden !important;
  }

  trix-editor * {
    max-width: 100%;
  }

  /* 画像スタイル */
  trix-editor figure[data-trix-attachment] {
    position: relative;
    display: inline-block;
    margin: 10px 0;
    padding: 2px;
    border: 2px solid transparent;
    transition: border-color 0.2s ease;
  }

  trix-editor figure[data-trix-attachment]:hover {
    border-color: #e0e0e0;
  }

  trix-editor img.resizable {
    max-width: 100%;
    height: auto;
    display: block;
    user-select: none;
  }

  /* リサイズハンドル */
  .resize-handle {
    position: absolute;
    width: 8px;
    height: 8px;
    background: white;
    border: 1px solid #3b82f6;
    z-index: 100;
    display: none;
    box-shadow: 0 1px 3px rgba(0,0,0,0.2);
  }

  /* ツールバーボタンのスタイル改善（日本語対応） */
  trix-toolbar .trix-button {
    font-size: 0.8125rem;
    padding: 0.4rem 0.6rem;
    font-weight: 500;
    white-space: nowrap;
    min-width: auto;
  }

  trix-toolbar .trix-button-group {
    margin-bottom: 0;
  }

  trix-toolbar .trix-button:hover {
    background-color: rgba(59, 130, 246, 0.1);
  }

  trix-toolbar .trix-button.trix-active {
    background-color: rgba(59, 130, 246, 0.2);
    color: #3b82f6;
  }

  /* ダイアログのスタイル */
  trix-toolbar .trix-dialog {
    border-radius: 6px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }

  trix-toolbar .trix-dialog input[type="url"] {
    border: 1px solid #e5e7eb;
    border-radius: 4px;
    padding: 0.5rem;
  }

  trix-toolbar .trix-dialog input[type="button"] {
    border-radius: 4px;
    font-weight: 500;
  }
`;
document.head.appendChild(style);