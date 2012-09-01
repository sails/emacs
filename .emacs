(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)


;;**********************                        common                        *********************
;;以 y/n 替代 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;;显示行号
(global-linum-mode 1)
;;设置字体大小
(set-default-font "Ubuntu Mono-11")
;;因为不想将修改emacs的ctrl-space，所以修改ibus的为shift-space切换
(require 'ibus)
(add-hook 'after-init-hook 'ibus-mode-on)


;;全屏
(defun my-fullscreen ()
  (interactive)
      (x-send-client-message
             nil 0 nil "_NET_WM_STATE" 32
                       '(2 "_NET_WM_STATE_FULLSCREEN" 0)))
(global-set-key [f11] 'my-fullscreen);F11 全屏


;;**********************                        common                        *********************


;; config file for yasnippet
(eval-after-load 'yasnippet-autoloads
  '(progn

     (require 'yasnippet)
     (require 'dropdown-list)
     (setq yas/prompt-functions '(yas/dropdown-prompt))
     (setq yas/wrap-around-region 'cua)
     ;; Toggle Yas/Minor mode in all buffers.
     (yas/global-mode 1)

   )
)

(eval-after-load 'auto-complete-autoloads
  '(progn

     (require 'auto-complete-config)
     (defun ac-config-default ()
       (setq-default ac-sources '(ac-source-yasnippet ac-source-files-in-current-dir ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
       (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
       (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
       (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
       (add-hook 'css-mode-hook 'ac-css-mode-setup)
       (add-hook 'auto-complete-mode-hook 'ac-common-setup)
       (global-auto-complete-mode t))
     (ac-config-default)
     (setq ac-use-menu-map t)
     (global-set-key "\M-/" 'auto-complete)
     
     )
)
;; autopair mode
(eval-after-load 'autopair-autoloads
  '(progn
     
     (autopair-global-mode)
     
     )
)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes nil)
 '(custom-safe-themes (quote ("5e1d1564b6a2435a2054aa345e81c89539a72c4cad8536cfe02583e0b7d5e2fa" "211bb9b24001d066a646809727efb9c9a2665c270c753aa125bace5e899cb523" default)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
