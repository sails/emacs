(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;********************** common ********************
;;以 y/n 替代 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;;显示行号
(global-linum-mode 1)
;;设置字体大小
(set-default-font "Ubuntu Mono-11")
(set-fontset-font t 'han (font-spec :family "新宋体" :size 12))


(defun my-c-style-set()
;;  (c-set-style "K&R")
;;  (c-set-offset 'innamespace 0)
  (setq c-basic-offset 4)
  ;;tab用空格代替
  (setq-default indent-tabs-mode nil)
  ;; cscope 查找代码很方便,先通过cscope-indexer -r来生成索引
  (cscope-minor-mode 1)
  (semantic-mode 1)

  )

;; google c++ style 检查
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c-mode-common-hook 'my-c-style-set)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
;; flycheck 会让emacs变慢,默认不开
;; (add-hook 'c-mode-common-hook 'flycheck-mode)


(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(global-set-key (kbd "C-=") 'hs-show-block)
(global-set-key (kbd "C--") 'hs-hide-block)


;; 窗口间方便跳转
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

;;全屏
(defun my-fullscreen ()
  (interactive)
      (x-send-client-message
             nil 0 nil "_NET_WM_STATE" 32
                       '(2 "_NET_WM_STATE_FULLSCREEN" 0)))
(global-set-key [f11] 'my-fullscreen);F11 全屏

;;********************** common *********************

;; config file for yasnippet
(eval-after-load 'yasnippet-autoloads
  '(progn

     (require 'yasnippet)
     (setq yas/prompt-functions '(yas/dropdown-prompt))
     (yas-global-mode 1)

   )
)

(eval-after-load 'auto-complete-autoloads
  '(progn


     ;;common auto-complete
     (require 'auto-complete-config)
     (defun ac-config-default ()
       (setq-default ac-sources '(ac-source-yasnippet ac-source-semantic ac-source-files-in-current-dir ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
       (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
       (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
       (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
       (add-hook 'css-mode-hook 'ac-css-mode-setup)
       (add-hook 'auto-complete-mode-hook 'ac-common-setup)
       )

     (ac-config-default)
     (setq ac-use-menu-map t)
     (global-set-key "\M-/" 'auto-complete)

     ;;clang
     (require 'auto-complete-clang-async)
     (defun ac-cc-mode-setup ()
       (setq ac-clang-complete-executable "~/software/clang-autocomplete-server/clang-complete")
       (setq ac-sources '(ac-source-clang-async))
       (ac-clang-launch-completion-process)
       )
     (defun my-ac-config ()
       (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
       (add-hook 'auto-complete-mode-hook 'ac-common-setup)
       (global-auto-complete-mode t)
       )

     (my-ac-config)

     )
)

;; autopair mode
(eval-after-load 'autopair-autoloads
  '(progn
     (autopair-global-mode)
     )
)

;; power line
(eval-after-load 'powerline-autoloads
  '(progn

    )
)

;; sr-speedbar
(eval-after-load 'sr-speedbar-autoloads
  '(progn
     (require 'sr-speedbar)
    )
)

;; ecb-mode
(eval-after-load 'ecb-autoloads
  '(progn
     (setq ecb-tip-of-the-day nil)
     ;;设置可用鼠标点击
     (custom-set-variables
      '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1)))
     )
  )

;; flycheck, 其中cppcheck默认就会调用cpplint
(eval-after-load 'flycheck
  '(progn
     (require 'flycheck-google-cpplint)
     ;; Add Google C++ Style checker.
     ;; In default, syntax checked by Clang and Cppcheck.
     (flycheck-add-next-checker 'c/c++-cppcheck
				'(warning . c/c++-googlelint))))


;; org-mode
;; org 自动换行
(add-hook 'org-mode-hook 
(lambda () (setq truncate-lines nil)))


;;org 代码高亮
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)


;; comment
(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key "\M-;" 'qiang-comment-dwim-line)



;; 第三方主题
(defun load-customize-theme()
  ;;(load-theme 'cherry-blossom)
)


(add-hook 'after-init-hook 'load-customize-theme)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(scroll-bar-mode nil)
 '(menu-bar-mode nil)
 '(tool-bar-mode nil))
