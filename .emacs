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
          (require 'auto-complete-clang) 
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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(ansi-term-color-vector [unspecified "#1F1611" "#660000" "#144212" "#EFC232" "#5798AE" "#BE73FD" "#93C1BC" "#E6E1DC"])
 '(custom-enabled-themes (quote (wombat)))
 '(custom-safe-themes (quote ("5cb805901c33a175f7505c8a8b83c43c39fb84fbae4e14cfb4d1a6c83dabbfba" "27470eddcaeb3507eca2760710cc7c43f1b53854372592a3afa008268bcf7a75" "cfde97b1d5ed1770b8e2e1b739611820c3a3e370cbda75d96e78ef2a5f359b27" "1aa022f083027dc8b1fe127427ee7b0d2cda6e334ae5869a5ab25570fc0f2090" "e85dd0d1b43cc1d725db627298c2753b0c3e90dc0b195e80f09f97a4e1e5660c" "64b7be5703b90e05f7bc1f63a9f689a7c931626462697bea9476b397da194bd9" "8281168b824a806489ca7d22e60bb15020bf6eecd64c25088c85b3fd806fc341" "944f3086f68cc5ea9dfbdc9e5846ad91667af9472b3d0e1e35a9633dcab984d5" "0ef08a15ee92e04b60d0db3a660c50315ec676190ee8ac105481d21e3650d2dc" "5e1d1564b6a2435a2054aa345e81c89539a72c4cad8536cfe02583e0b7d5e2fa" "211bb9b24001d066a646809727efb9c9a2665c270c753aa125bace5e899cb523" default)))
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
