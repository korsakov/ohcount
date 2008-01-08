(if (string-equal "21" (substring (emacs-version) 10 12))
	(progn
		(blink-cursor-mode 0)
		;; Insert newline when you press `C-n' (next-line)
		;; at the end of the buffer

		(setq next-line-add-newlines t)
		;; Turn on image viewing
		(auto-image-file-mode t)
		;; Turn on menu bar (this bar has text)
		;; (Use numeric argument to turn on)
		(menu-bar-mode 1)
		;; Turn off tool bar (this bar has icons)
		;; (Use numeric argument to turn on)
		(tool-bar-mode nil)
		;; Turn off tooltip mode for tool bar
		;; (This mode causes icon explanations to pop up)
		;; (Use numeric argument to turn on)
		(tooltip-mode nil)
		;; If tooltips turned on, make tips appear promptly
		(setq tooltip-delay 0.1)  ; default is one second
		))
