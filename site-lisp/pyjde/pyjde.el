(defun reload-pyjde() 
  (interactive)
  (if (buffer-live-p (get-buffer "*Pymacs*" ))
      (kill-buffer (get-buffer
		    "*Pymacs*")))
  (pymacs-load "/usr/share/emacs23/site-lisp/pyjde/pyjde")
  )

(defun pyjde-do-find-descendants() 
  (interactive)(pyjde-find-descendants) )

(defun pyjde-do-find-file-at-symbol() 
  (interactive)(pyjde-find-file-at-symbol)
  )

(defun pyjde-do-goto-definition() 
  (interactive)(pyjde-goto-definition)
  )

(defun pyjde-do-find-public-methods() 
  (interactive)(pyjde-find-public-methods)
  )

(defun pyjde-do-find-imports() 
  (interactive)(pyjde-find-imports)
  )

(defun pyjde-do-pick-method() 
  (interactive)(pyjde-pick-method)
  )

(defun pyjde-do-pick-import() 
  (interactive)(pyjde-pick-import)
  )

;; we had to seperate calculating borders for highlight from the 
;; actual h'lighting because if there is a single Pymacs call inside 
;; our method, then no highlighting can take place. so we have 
;; two functions two key clicks. it's kludgy but it works for now.

(defvar high-begin)
(defvar high-end)
(defvar called-once)
(setq called-once nil)

(defun pyjde-do-get-borders() 
  (interactive)
  (setq high-begin (pyjde-param-highlight-begin))
  (setq high-end (pyjde-param-highlight-end))
  (message "Done")
  )

(defun pyjde-do-highlight() 
  (interactive)
  (message "high-begin")
  ;;(message high-begin)
  (goto-char high-begin)
  (cua-set-mark)
  (message "high-end")
  ;;(message high-end)
  (goto-char high-end)
  )

(defun pyjde-do-test() 
  (interactive)(pyjde-test)
)

(defun pyjde-do-get-borders-and-highlight() 
  (interactive)
  (if (equal called-once nil) 
      (progn 
	(message "getting borders")
	(setq called-once t)
	(pyjde-do-get-borders)
	)  
    (progn 
      (message "highlighting")
      (setq called-once nil)
      (pyjde-do-highlight)
      ))
  )

(global-set-key [f5] 'pyjde-do-test)
(global-set-key [f11] 'reload-pyjde)
(global-set-key "\C-x\p\p" 'pyjde-do-find-public-methods)
(global-set-key "\C-x\p\m" 'pyjde-do-pick-method)
(global-set-key "\C-x\p\i" 'pyjde-do-pick-import)
(global-set-key "\M-#" 'pyjde-do-get-borders-and-highlight)

(reload-pyjde)

