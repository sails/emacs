(require 'package)
;; 国内的镜像
;;(add-to-list 'package-archives
;;            '("melpa" . "https://melpa.org/packages/"))

(setq package-archives '(
 			 ("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
 			 ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")))

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")  ;; 自定义的扩展


;; ////////////////common setting/////////////////
;; common lisp extensions一些额外的函数和宏
(require 'cl)
(eval-when-compile (require 'cl))

;; windows 设置
(when (eq system-type 'windows-nt)
  ;; 解决windows中文卡的问题
  (set-fontset-font t 'han (font-spec :family "新宋体" :size 12))
  ;; 改变默认路径
  (setq inhibit-startup-message t)
  (cd "E:/")
  (setenv "HOME" "D:/program/emacs")
  (setenv "PATH" "D:/program/emacs/bin") 
  )

;; key bindings,把meta映射成cmd键，但是不影响cmd+tab这样的系统快捷方式
;; emacs-mac-port 已经把meta改过了
(when (eq system-type 'darwin) ;; mac specific settings
  (message "remap key")
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
  ;; 由于ls与linux中的不同，有些插件可能会报错
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil)
  (set-frame-font "Menlo-12")

  (setq default-frame-alist
      `((top . 0)
        (left . 300)   ;; 单位是像素
        (width . 100)  ;; 单位frame-char-width
        (height . 40)  ;; 单位frame-char-height
        ))
  ;; (message "height:%d" (x-display-pixel-height))
  ;; (message "width:%d" (x-display-pixel-width))
  )

;; ssh连接linux时，删除键重新映射
(define-key global-map "\C-h" 'backward-delete-char)
(define-key global-map "\C-x?" 'help-command)

;; 终端模式下支持鼠标
(xterm-mouse-mode 1)

;;以 y/n 替代 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;; recent file，最近打开的文件，在menu上会出现一个最近打开的文件列表，
;; 当在c-x c-f打开文件时，M-p可以查看填入最近打开的文件，M-n可以恢复正常
(recentf-mode t)
;;(set-fontset-font t 'han (font-spec :family "monaco" :size 12))
;;显示行号
;;(global-linum-mode 1)
(global-display-line-numbers-mode 1)
;;显示列
(column-number-mode 1)
;;在终端环境下，没有scroll-bar，所以设置会出错
(if (display-graphic-p)
    (progn
      (scroll-bar-mode 0)
      (tool-bar-mode 0)
      )
  )

(tool-bar-mode 0)
;;全屏，在使用railwaycat的emacs编译版本时，最大化按钮不是全屏
(global-set-key  [(M return)] 'toggle-frame-fullscreen)

;; 窗口间方便跳转
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

;; 大小写M-u,M-l
(put 'upcase-region 'disabled nil)

;; ////////////////common setting/////////////////





;; 启动自动检查安装配置
(defvar required-packages
  '(
    company
    yasnippet
    yasnippet-snippets
    flycheck
    projectile
    magit
    autopair
    ecb
    company-lsp
    company-go
    markdown-mode
    json-mode
    sr-speedbar
    exec-path-from-shell
    google-c-style
    flymake-google-cpplint
    firestarter
    helm
    edit-at-point
    urlenc
    reveal-in-osx-finder
    helm-gtags
    ggtags
    ag
    quickrun
    ivy
    expand-region
  ) "a list of packages to ensure are installed at launch.")

(defun packages-installed-p ()
  (loop for p in required-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))
;; 依次查检进行安装
(unless (packages-installed-p)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ; install the missing packages
  (dolist (p required-packages)
    (when (not (package-installed-p p))
      (package-install p))))


;; ///////////////programe setting ///////////////

(require 'init-jce)

(add-hook 'after-init-hook 'global-company-mode)
;; any-company mode 默认是M-n M-p用于选择，但是习惯
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (setq company-idle-delay 0)

  ;; company-yasnippet会造成在以.开始的补全中，出现很多无用的运算符号
  (add-to-list
   'company-backends '(company-gtags))
  (setq company-idle-delay 0.15)
  
  ;; 由于开启semantic-mode后,company-semantic 代替company-clang，它的优先级更高
  (setq company-backends (delete 'company-semantic company-backends))

  (push 'company-lsp company-backends)
  
  )

(require 'yasnippet)
(add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
(setq yas/prompt-functions '(yas/dropdown-prompt))
(yas-global-mode 1)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; 基于google style修改编程风格
(c-add-style "Google" google-c-style)
(c-add-style "mine" '("Google"
                      (c-basic-offset . 4)
                      (c-offsets-alist . ((innamespace . 0)
                                          (access-label . -3)
                                          (case-label . 0)
                                          (member-init-intro . +)
                                          (topmost-intro . 0)
                                          ))))

(defun my-c-common-hook()
       (progn
         (c-set-style "mine")
         )
       )

(add-hook 'c-mode-common-hook 'my-c-common-hook)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)


;; 当开启semantic时，speedbar第一次展开一个文件的方法时会出错，这时只要重启关闭后再展示就正常了
;; (add-hook 'c-mode-common-hook 'semantic-mode)

(setq flycheck-clang-include-path
      (list (expand-file-name "~/workspace/")
	    (expand-file-name "~/workspace/vas_lib_proj/")
	    (expand-file-name "./")
	    (expand-file-name "../")
	    (expand-file-name "../../")

	    ))

(add-hook 'c++-mode-hook
	  (lambda ()
            ;; flycheck 设置
            (flycheck-mode 1)
	    (setq flycheck-clang-language-standard "c++11")
	    (flycheck-select-checker 'c/c++-cppcheck)
	    (setq flycheck-cppcheck-checks (quote ("style" "all")))
	    ))

;; (add-hook 'go-mode-hook 'flycheck-mode)


;; firestarter，用于设置每次保存时执行的命令
(firestarter-mode)

;; golang 设置
(add-hook 'go-mode-hook #'lsp)
(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ;; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-,") 'pop-tag-mark)
  (setq lsp-prefer-flymake nil)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)


(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'lua-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'go-mode-hook 'hs-minor-mode)
(if (display-graphic-p)
    (progn
      ;; if graphic
      (global-set-key (kbd "C-=") 'hs-show-block)
      (global-set-key (kbd "C--") 'hs-hide-block)
      )
  ;; else (optional)
  (global-set-key (kbd "C-c =") 'hs-show-block)
  (global-set-key (kbd "C-c -") 'hs-hide-block)
  )


;; sr-speedbar
(require 'sr-speedbar)
(setq sr-speedbar-right-side nil)
(speedbar-add-supported-extension ".go")
(speedbar-add-supported-extension ".proto")
(speedbar-add-supported-extension ".jce")
(setq speedbar-use-images nil)

;; ecb-mode
(setq ecb-tip-of-the-day nil)
;; 可以点击操作
(setq ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
;; 自带的布局http://ecb.sourceforge.net/docs/Changing-the-ECB-layout.html
(setq ecb-layout-name "left6")
(setq ecb-history-make-buckets 'never)
(global-set-key (kbd "C-c C-e") 'ecb-minor-mode)


;; ;; helm
(helm-mode 1)
(require 'helm-config)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(define-key helm-find-files-map "\t" 'helm-execute-persistent-action)
(global-set-key (kbd "M-x") 'helm-M-x)  ;; 它比ivy的方便些，有历史记录
(global-set-key (kbd "C-x b") 'helm-mini)

;; ivy
;; (ivy-mode 1)  ;; 查找文件，还是ivy补全方便
;; ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
;; (setq ivy-use-virtual-buffers t)
;; ;; 改变高度成1/3
;; (setq ivy-height-alist
;;       '((t
;;          lambda (_caller)
;;          (/ (frame-height) 3))))
;; ;; 默认情况下如果目录下有test.cpp，想创建test.c是不行的，由于在输入test.c时，会默认补全
;; ;; 并选中test.cpp，打开ivy-use-selectable-prompt后，可以C-p把补全的选中框移动到输入上
;; (setq ivy-use-selectable-prompt t) 

;; helm-gtags
(setq
 ;; helm-gtags-auto-update t  ;; TAG file is updated after saving buffer
 )
(setenv "GTAGSFORCECPP" "1")
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(add-hook 'jce-mode-hook 'helm-gtags-mode)
(with-eval-after-load 'helm-gtags
  (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
  (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-find-tag-from-here)
  (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
  (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack))

;; ggtags
;; (setenv "GTAGSFORCECPP" "1")
;; (add-hook 'c-mode-hook 'ggtags-mode)
;; (add-hook 'c++-mode-hook 'ggtags-mode)
;; (add-hook 'asm-mode-hook 'ggtags-mode)
;; (add-hook 'jce-mode-hook 'ggtags-mode)

(projectile-global-mode)
(setq projectile-enable-caching t)
(define-key projectile-mode-map  (kbd "C-c p f") 'projectile-find-file)
(define-key projectile-mode-map  (kbd "C-c p p") 'projectile-switch-project)

;; 默认它的find file是用外部的svn git命令来查找，但是如果有submodule时，所导致不多个project，而不是
;; 一个。如果设置native时，会直接遍历目录，所以会慢很多，基本上不能接受。所以还是用svn，git来查找，只是
;; 查找时，用c-c p F来，这样就是从已知的project中找查
;; (setq projectile-indexing-method 'native)
;; autopair mode
(autopair-global-mode)

;; 可以很方便的在头文件与cpp文件中切换
(setq cc-other-file-alist
      '(("\\.c"   (".h"))
        ("\\.cpp"   (".h"))
        ("\\.h"   (".c"".cpp"".cc"))))
(setq ff-search-directories
      '("." "../src" "../include"))
(add-hook 'c-mode-common-hook
          (lambda() 
            (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

;; quickrun
(quickrun-add-command "c++/c11"
                      '((:command . "g++")
                        (:exec    . ("%c -std=c++11 %o -o %n %s"
                                     "%n %a"))
                        (:remove  . ("%n")))
                      :default "c++")

;; org 自动换行
(add-hook 'org-mode-hook 
(lambda () (setq truncate-lines nil)))
;;org 代码高亮
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-image-actual-width '(300 500))
;; 禁用下划线转义,org导出时下划线的问题abc_def中的def会变成小标
(setq org-use-sub-superscripts nil)
(setq org-export-with-sub-superscripts nil)


;; 代码注释
(defun qiang-comment-dwim-line (&optional arg)
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'qiang-comment-dwim-line)

;; lua的缩进
(setq lua-indent-level 4)
(add-hook 'lua-mode-hook
	  (lambda ()
            ;; flycheck 设置
            (flycheck-mode 1)
            (when (executable-find "luacheck")
              (flycheck-select-checker 'lua-luacheck))
            ))

;; ///////////////programe setting ///////////////



;; //////////// Other ///////////////

;; 这个插件很厉害，可以得到环境变量的值, 它会自动复制MANPATH, PATH and exec-path，
;; 其它的要通过(exec-path-from-shell-copy-env "GOPATH")的方式来设置
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH")
  )


;; 调用reveal-in-osx-finder在finder中打开当前目录，并选中当前文件
(require 'reveal-in-osx-finder)


;; 高效的选中region
(require 'expand-region)
(global-set-key (kbd "C-x m") 'er/expand-region)

;; 复制，粘贴
(global-set-key (kbd "C-c e") 'edit-at-point-symbol-copy)
(global-set-key (kbd "C-c w") 'edit-at-point-word-copy)


;;(setq gdb-many-windows t)

;; 编译远程文件
(setq tramp-default-method "ssh")
(setq tramp-default-user "sails")


;; copy buffer path
(defun copy-file-name(choice)
  "Copy the buffer-file-name to the kill-ring"
  (interactive "cCopy Buffer Name (f) full, (d) directory, (n) name")
  (let ((new-kill-string)
        (name (if (eq major-mode 'dired-mode)
                  (dired-get-filename)
                (or (buffer-file-name) ""))))
    (cond ((eq choice ?f)
           (setq new-kill-string name))
          ((eq choice ?d)
           (setq new-kill-string (file-name-directory name)))
          ((eq choice ?n)
           (setq new-kill-string (file-name-nondirectory name)))
          (t (message "Quit")))
    (when new-kill-string
      (message "%s copied" new-kill-string)
      (kill-new new-kill-string)
      )
    )
  )

;; windows 中文字体卡的问题
;; (setq inhibit-compacting-font-caches t)

;; 大文件卡顿的问题
(defun large-file-check-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 100))
    (flycheck-mode 0)
    (company-mode 0)
    (yas-minor-mode 0)
    (helm-mode 0)
    (autopair-mode 0)
    )
  (when (> (buffer-size) (* 1024 100))
    (fundamental-mode))
  )

(add-hook 'find-file-hook 'large-file-check-hook)

;; markdown
(setq markdown-command
      "/usr/local/bin/pandoc -c ~/.emacs.d/pandoc_css/github-pandoc.css  --from markdown_github-ascii_identifiers -t html5 --toc --number-sections --mathjax --highlight-style pygments --standalone")

;; //////////// Other ///////////////

