(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;**********************                        common                        ********************
;;以 y/n 替代 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;;显示行号
(global-linum-mode 1)
;;设置字体大小
;;(set-default-font "Ubuntu Mono-11")
;;(set-default-font "Inconsolata Medium 11")
;;(set-frame-width (selected-frame) 120)
;;(set-frame-height (selected-frame) 40)

;; C language setting
(add-hook 'c-mode-hook
          '(lambda ()
             (c-set-style "K&R")
             (setq tab-width 8)
             (setq indent-tabs-mode t)
             (setq c-basic-offset 8)))

;; C++ language setting
(add-hook 'c++-mode-hook
          '(lambda ()
             (c-set-style "K&R")
             ;;(c-toggle-auto-state)
             (setq tab-width 8)
             (setq indent-tabs-mode t)
             (setq c-basic-offset 8)))

;;因为不想将修改emacs的ctrl-space，所以修改ibus的为shift-space切换
;;(require 'ibus)
;;(add-hook 'after-init-hook 'ibus-mode-on)

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


;; cedet
(load-file "~/.emacs.d/cedet-1.1/common/cedet.el")
(global-ede-mode 1)
(semantic-load-enable-code-helpers)


;;**********************                        common                        *********************

;; config file for yasnippet
(eval-after-load 'yasnippet-autoloads
  '(progn

     (require 'yasnippet)
     (setq yas/prompt-functions '(yas/dropdown-prompt))
     (setq yas-snippet-dirs '("~/.emacs.d/snippets"
			     ))
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

;;sr-speedbar
(eval-after-load 'sr-speedbar-autoloads
  '(progn
     (require 'sr-speedbar)
    )
)

;;ecb-mode
(eval-after-load 'ecb-autoloads
  '(progn
     (setq ecb-tip-of-the-day nil)
     (setq ecb-layout-name "left3")
     ;;设置可用鼠标点击
     (custom-set-variables
      '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1)))
    )
)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "unknown" :slant normal :weight normal :height 113 :width normal)))))
