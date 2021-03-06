; autotest.el
; 
; Copyright (c) Tomoyuki Matsumoto
; BSD license - http://www.opensource.org/licenses/bsd-license.php
; 
; Configurations:
;  1. Make sure autotest.el is in your load-path
;  2. Add following code to your .emacs file:  
;     (require 'autotest)
;     ; Optional: if you want to use spork
;     (setq autotest-use-spork t)
;     ; Optional: if you want to set default rails app dir
;     (setq autotest-default-directory "/path/to/app/")
;
; Note:
;  When you run autotest with spork, this elisp don't wait to
;  run autotest until your spork starts, so you will probably
;  see a warning message like 'No DRb server is running. 
;  Running in local process instead ...', but autotest should
;  use spork after it started. So don't worry.
;  (I might change this elisp to wait spork server to start.)

(require 'shell)

(defcustom autotest-use-spork nil
  "Use spork server"
  :type 'boolean
  :group 'better-autotest)

(defcustom autotest-command "autotest"
  "Command to run autotest"
  :group 'autotest
  :type 'string)

(defcustom autotest-spork-command "spork"
  "Command to run spork"
  :group 'autotest
  :type 'string)

(defcustom autotest-buffer "*autotest*"
  "Autotest buffer name"
  :type 'string
  :group 'autotest)

(defcustom autotest-spork-buffer "*spork*"
  "Spork buffer name"
  :type 'string
  :group 'autotest)

(defcustom autotest-spork-port 8989
  "Spork port number"
  :type 'number
  :group 'autotest)

(defcustom autotest-maximum-lines 5000
  "Maximum number of lines to display"
  :type 'number
  :group 'autotest)

(defcustom autotest-default-directory nil
  "Default rails application directory"
  :type 'string
  :group 'autotest)

(defvar rails-app-directory)

(defun autotest-spork-running-p ()
  (let ((cmd (concat "netstat -ltn | grep " (int-to-string autotest-spork-port))))
    (not (string= (shell-command-to-string cmd) ""))))

(defun comint-simple-send* (buffer-name command)
  (let ((buffer (shell buffer-name)))
    (set (make-local-variable 'comint-output-filter-functions)
         '(comint-truncate-buffer comint-postoutput-scroll-to-bottom ansi-color-process-output))
    (set (make-local-variable 'comint-buffer-maximum-size) autotest-maximum-lines)
    (set (make-local-variable 'comint-scroll-show-maximum-output) t)
    (set (make-local-variable 'comint-scroll-to-bottom-on-output) t)
    (compilation-shell-minor-mode)
    (comint-simple-send buffer (concat "cd " rails-app-directory " && " command))))

(defun* autotest ()
  "Start autotest"
  (interactive)
  (let* ((default (or autotest-default-directory default-directory))
         (dir (read-directory-name "Rails app dir: " default)))
    (unless (file-accessible-directory-p dir)
      (message "Directory is not accessible")
      (return-from autotest))
    (setq rails-app-directory dir))
  (when (and autotest-use-spork (not (autotest-spork-running-p)))
    (let ((window (selected-window)))
      (comint-simple-send* autotest-spork-buffer autotest-spork-command)
      (select-window window)))
  (if (get-buffer autotest-buffer)
      (message "Already running autotest? Try `M-x autotest-restart` instead.")
    (comint-simple-send* autotest-buffer autotest-command)
    (message "Autotest starting...")))

(defun autotest-stop ()
  "Stop autotest"
  (interactive)
  (when (get-buffer autotest-buffer)
    (kill-buffer autotest-buffer))
  (when (and autotest-use-spork (get-buffer autotest-spork-buffer))
    (kill-buffer autotest-spork-buffer))
  (message "Autotest stopped!"))

(defun autotest-restart ()
  "Restart autotest"
  (interactive)
  (autotest-stop)
  (autotest))

(provide 'autotest)
