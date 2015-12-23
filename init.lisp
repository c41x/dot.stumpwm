;; -*-lisp-*-
;;
;; stumpwm config

(in-package :stumpwm)

;; enable mode line
(if (not (head-mode-line (current-head)))
    (toggle-mode-line (current-screen) (current-head)))

;; windows key as prefix
(run-shell-command "xmodmap -e \"clear mod4\"")
(run-shell-command "xmodmap -e \"keycode 133 = F20\"")
(set-prefix-key (kbd "F20"))

;;(echo-string (stumpwm:current-screen) "start hook here")

;; focus follows mouse
(setf *mouse-focus-policy* :sloppy)

;; set background image (needs imagemagick to work)
(run-shell-command "display -window root ~/tmp/spooky-forrest.jpeg")

(defun cat (&rest strings) "Concatenates strings, like the Unix command 'cat'.
    A shortcut for (concatenate 'string foo bar)."
  (apply 'concatenate 'string strings))

(defcommand firefox () ()
  "start firefox or switch to it if already running."
  (run-or-raise "firefox" '(:class "Firefox")))

(defcommand allegro-vinyls (search)
  ((:string "Search in Allegro Vinyls for: "))
  "prompt the user for a search term and look it up in Allegro Vinyls "
  (check-type search string)
  (let ((uri (format nil "allegro.pl/listing/listing.php?order=p&string=~a&search_scope=category-279" search)))
    (run-shell-command
     (concatenate 'string "firefox \"" uri "\""))
    (run-or-raise "firefox" '(:class "Firefox"))))

(define-key *root-map* (kbd "x") "firefox")
(define-key *root-map* (kbd "z") "allegro-vinyls")

(defcommand sg-web ()()
  (run-commands "grename >web")
  (only)
  (hsplit "1/7")
  (fnext)
  (hsplit "5/6")
  (loop for w in (all-windows) do
	(hide-window w))
  (act-on-matching-windows (w) (classed-p w "Firefox")
			   (frame-raise-window (current-group) (frame-by-number (current-group) 1) w t)))

(defcommand sg-dev ()()
  (run-commands "grename >dev")
  (only)
  (hsplit "1/7")
  (fnext)
  (hsplit "5/6")
  (loop for w in (all-windows) do
	(hide-window w))
  (act-on-matching-windows (w) (or (classed-p w "Emacs24") (classed-p w "XTerm"))
			   (frame-raise-window (current-group) (frame-by-number (current-group) 1) w t)))

(defcommand sg-dev-web ()()
  (run-commands "grename >dev+web")
  (only)
  (hsplit "1/2")
  (loop for w in (all-windows) do
	(hide-window w))
  (act-on-matching-windows (w) (or (classed-p w "Emacs24") (classed-p w "XTerm"))
			   (frame-raise-window (current-group) (frame-by-number (current-group) 1) w t))
  (act-on-matching-windows (w) (classed-p w "Firefox")
			   (frame-raise-window (current-group) (frame-by-number (current-group) 0) w t)))

(define-key *root-map* (kbd "1") "sg-web")
(define-key *root-map* (kbd "2") "sg-dev")
(define-key *root-map* (kbd "3") "sg-dev-web")

;; rename "Default to web"
(run-commands "grename web")

;; ;; create groups
;; (run-commands "gnewbg dev"
;; 	      "gnewbg dev+web")

(run-commands "only" "fclear")
(hsplit "1/7")
(fnext)
(hsplit "5/6")

;; window placement rules
(clear-window-placement-rules)

(define-frame-preference "web"
  (1 t t :class "Firefox")
  (1 t t :class "Emacs24")
  (1 t t :class "XTerm"))

;; (define-frame-preference "dev"
;;   (0 t t :class "Emacs24"))

;; (define-frame-preference "dev+web"
;;   (0 t t :class "Firefox")
;;   (1 t t :class "Emacs24")
;;   (1 t t :class "XTerm"))

;; (defcommand aaa ()()
;;   "aaaa"
;;   (loop for w in (screen-windows (current-screen)) do
;;     (pull-w w)
;;     (when (equal (window-title w) "emacs")
;;       (echo "EMACS"))))
