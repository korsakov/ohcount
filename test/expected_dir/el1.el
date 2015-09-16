emacslisp	code	(if (string-equal "21" (substring (emacs-version) 10 12))
emacslisp	code		(progn
emacslisp	code			(blink-cursor-mode 0)
emacslisp	comment			;; Insert newline when you press `C-n' (next-line)
emacslisp	comment			;; at the end of the buffer
emacslisp	blank	
emacslisp	code			(setq next-line-add-newlines t)
emacslisp	comment			;; Turn on image viewing
emacslisp	code			(auto-image-file-mode t)
emacslisp	comment			;; Turn on menu bar (this bar has text)
emacslisp	comment			;; (Use numeric argument to turn on)
emacslisp	code			(menu-bar-mode 1)
emacslisp	comment			;; Turn off tool bar (this bar has icons)
emacslisp	comment			;; (Use numeric argument to turn on)
emacslisp	code			(tool-bar-mode nil)
emacslisp	comment			;; Turn off tooltip mode for tool bar
emacslisp	comment			;; (This mode causes icon explanations to pop up)
emacslisp	comment			;; (Use numeric argument to turn on)
emacslisp	code			(tooltip-mode nil)
emacslisp	comment			;; If tooltips turned on, make tips appear promptly
emacslisp	code			(setq tooltip-delay 0.1)  ; default is one second
emacslisp	code			))
