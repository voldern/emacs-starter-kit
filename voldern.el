;; Color themes
(add-to-list 'load-path "~/.emacs.d/vendor/color-theme")
(require 'color-theme)
;;(color-theme-initialize)
(load-file "~/.emacs.d/elpa-to-submit/twilight.el")
(color-theme-twilight)

;; Set default font
;;(set-default-font
;; "-apple-andale-mono-medium-r-normal--13-0-72-72-m-0-iso10646-1")
(set-default-font "-*-proggyclean-*-*-*-*-13-80-96-96-*-*-iso8859-1")
;; (set-face-font 'default
;;                "-apple-andale mono-medium-r-normal--13-0-72-72-m-0-iso10646-1")
(setq initial-frame-alist '((width . 106) (height . 64)))

;; nXhtml-mode
(add-to-list 'load-path "~/.emacs.d/vendor/nxhtml")
(load "~/.emacs.d/vendor/nxhtml/autostart.el")


;; Ruby
(add-hook 'ruby-mode-hook 'highlight-80+-mode)
(require 'rvm)
(rvm-use-default)
(add-to-list 'load-path "~/.emacs.d/vendor/rinari")
(require 'rinari)

;; Haml
(add-to-list 'auto-mode-alist '("\\.haml\\'" . haml-mode))
(add-hook 'haml-mode-hook 'rinari-minor-mode)

;; Load php-mode
;; (require 'php-mode)
(setq php-mode-force-pear 'true)
(defun wicked/php-mode-init ()
  (highlight-80+-mode)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (setq fill-column 80)
  (setq show-paren-mode t)
  (setq c-default-style "php"))
(add-hook 'php-mode-hook 'wicked/php-mode-init)


;; org-mode
(setq org-use-fast-todo-selection 'true)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/Dropbox/Org/gtd.org"
                             "~/Dropbox/Org/gtd_archive.org"
                             "~/Dropbox/Org/someday.org"))

;; nxml-mode
;; (require 'nxml-mode)
(defun my-nxml-mode-hook ()
  (setq tab-width 4
        indent-tabs-mode nil
        nxml-child-indent 4
        nxml-attribute-indent 4))

(add-hook 'nxml-mode-hook 'my-nxml-mode-hook)

;; enable column-number-mode
(column-number-mode t)

;; Map M-RET and M-return to newline in ruby-mode
(eval-after-load 'ruby-mode
  '(progn
     (define-key ruby-mode-map (kbd "<M-return>") 'newline)
     (define-key ruby-mode-map (kbd "M-RET") 'newline)))

;; Make c++ use the storstroup indent mode
(eval-after-load 'c++-mode
  '(c-set-style 'stroustrup))


;; LaTeX
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)



;; Function to revert all buffers. Usefull when doing external changes
;; to a lot of files
(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files"
  (interactive)
  (let* ((list (buffer-list))
         (buffer (car list)))
    (while buffer
      (when (and (buffer-file-name buffer) 
                 (not (buffer-modified-p buffer)))
        (set-buffer buffer)
        (revert-buffer t t t))
      (setq list (cdr list))
      (setq buffer (car list))))
  (message "Refreshed open files"))

