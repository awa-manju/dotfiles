(el-get-bundle! yasnippet
  (setq yas-snippet-dirs
        (list
         (locate-user-emacs-file "snippets")
         "~/.yasnippet"
         'yas-installed-snippets-dir
         ))
  (yas-global-mode 1)

  (eval-after-load 'yasnippet
    '(progn
       (define-key yas-keymap (kbd "RET") 'yas-next-field-or-maybe-expand)))

  (setq yas-prompt-functions '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))
  )

;; use popup menu for yas-choose-value
;; https://www.emacswiki.org/emacs/Yasnippet
(el-get-bundle! popup
  ;; add some shotcuts in popup menu mode
  (define-key popup-menu-keymap (kbd "C-n") 'popup-next)
  (define-key popup-menu-keymap (kbd "TAB") 'popup-next)
  (define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
  (define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
  (define-key popup-menu-keymap (kbd "C-p") 'popup-previous)

  (defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
    (when (featurep 'popup)
      (popup-menu*
       (mapcar
        (lambda (choice)
          (popup-make-item
           (or (and display-fn (funcall display-fn choice))
               choice)
           :value choice))
        choices)
       :prompt prompt
       ;; start isearch mode immediately
       :isearch t
       )))
  )