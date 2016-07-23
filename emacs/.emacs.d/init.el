(setq read-file-name-completion-ignore-case 'non-nil)
 ;; (setq initial-frame-alist '((top . 0) (left . 0)   (width . 147) (height . 34)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-c-headers-path-system
   (quote
    ("/usr/include/c++/5/" "/usr/include/" "/usr/local/include/")))
 '(company-clang-arguments (quote ("-std=c++11")))
 '(company-idle-delay 0)
 '(company-minimum-prefix-length 2)
 '(custom-enabled-themes (quote (manoj-dark)))
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
(setq default-frame-alist '((top . 0) (right . 0)   (width .80) (height . 34)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))

(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

 ;; linum
(add-hook 'find-file-hook (lambda () (linum-mode 1)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

 ;; Arduino-mode
(setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist))
(autoload 'arduino-mode "arduino-mode" "Arduino editing mode." t)

 ;; company-mode
(autoload 'company-mode "company" nil t)
(add-hook 'after-init-hook 'global-company-mode)

 ;; melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize) 

 ;; company-c-headers
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-c-headers))
