 ;; melpa install company, magit, smex, company-c-headers
 ;; melpa-stable install markdown-mode 

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(display-battery-mode 1)
(display-time-mode 1)
(setq read-file-name-completion-ignore-case 'non-nil)
(setq comint-process-echoes t)
;; (setq initial-frame-alist '((top . 0) (left . 0)   (width . 147) (height . 34)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-c-headers-path-system
   (quote
    ("/usr/include/c++/6/" "/usr/include/" "/usr/local/include/")))
 '(company-clang-arguments (quote ("-std=c++11")))
 '(company-idle-delay 0)
 '(company-minimum-prefix-length 2)
 '(custom-enabled-themes (quote (solarized)))
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(frame-background-mode (quote dark))
 '(inhibit-startup-screen t)
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(python-indent-guess-indent-offset nil)
 '(python-indent-offset 4))
(setq default-frame-alist '((top . 0) (right . 0)   (width . 80) (height . 34)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

 ;; solarized theme
(add-to-list 'custom-theme-load-path (expand-file-name "themes/emacs-color-theme-solarized" user-emacs-directory))
(load-theme 'solarized t)

(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

 ;; linum
 ;; (add-hook 'find-file-hook (lambda () (linum-mode 1)))
(add-hook 'text-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'linum-mode)


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

 ;; melpa and melpa-stable
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
 ;; (add-to-list 'package-archives
 ;; 	     '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize) 

 ;; company-c-headers
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-c-headers))

 ;; smex
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
 ;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

 ;; magit
(global-set-key (kbd "C-x g") 'magit-status)

