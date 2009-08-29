;; swank-clojure
(add-to-list 'load-path "~/.emacs.d/vendor/swank-clojure")
(require 'swank-clojure-autoload)
(swank-clojure-config
 (setq swank-clojure-jar-path "~/Library/Clojure/lib/clojure.jar")
 (setq swank-clojure-extra-classpaths
       (list "~/Library/Clojure/lib/clojure-contrib.rar")))

;; slime
(eval-after-load "slime"
  '(progn (slime-setup '(slime-repl))))

(add-to-list 'load-path "~/.emacs.d/vendor/slime")
(require 'slime)
(slime-setup)