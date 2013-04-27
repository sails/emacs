(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)


;;**********************                        common                        ********************
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/")
;;(load-theme 'zen-and-art t)
;;以 y/n 替代 yes/no
(fset 'yes-or-no-p 'y-or-n-p)
;;显示行号
(global-linum-mode 1)
;;设置字体大小
(set-default-font "Ubuntu Mono-11")

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

     ;;common auto-complete     
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

     ;;clang
          (require 'auto-complete-clang-async) 
     (defun my-ac-clang-config ()  
       (setq ac-clang-flags  
	     (mapcar(lambda (item)(concat "-I" item))  
		    (split-string  
		     "  
 /usr/include/c++/4.7  
 /usr/include/clang/3.0/include
 /usr/include/c++/4.7/i486-linux-gnu  
 /usr/include/c++/4.7/backward  
 /usr/local/include  
 /usr/lib/gcc/i486-linux-gnu/4.7/include  
 /usr/lib/gcc/i486-linux-gnu/4.7/include-fixed  
 /usr/include/i486-linux-gnu  
 /usr/include  
"
		     ))))
     
     (defun my-ac-cc-mode-setup ()  
       (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))  
     (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)  


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



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(ansi-term-color-vector [unspecified "#1F1611" "#660000" "#144212" "#EFC232" "#5798AE" "#BE73FD" "#93C1BC" "#E6E1DC"])
 '(custom-enabled-themes (quote (wombat)))
 '(ecb-source-path (quote (("/" "/"))))
 '(fci-rule-character-color "#452E2E")
 '(fci-rule-color "#c7c7c7")
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
