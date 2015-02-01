;; Global editor behavior
(use-package expand-region
  :commands (er/expand-region er/contract-region))

(use-package rotate-text
  :commands (rotate-word-at-point rotate-region))

(use-package smartparens
  :init (require 'smartparens-config)
  :config
  (progn
    (smartparens-global-mode 1)

    (setq blink-matching-paren t)
    (setq sp-autowrap-region nil            ; let evil-surround handle this
          sp-highlight-pair-overlay nil
          sp-show-pair-delay 0
          sp-autoescape-string-quote nil)

    ;; Handle newlines + spaces
    (sp-pair "{" "}" :post-handlers '(("||\n[i]" "RET") ("| " "SPC")) :unless '(sp-point-before-word-p sp-point-before-same-p))
    (sp-pair "(" ")" :post-handlers '(("||\n[i]" "RET") ("| " "SPC")) :unless '(sp-point-before-word-p sp-point-before-same-p))

    ;; Auto-close more conservatively
    (sp-pair "[" nil  :unless '(sp-point-before-word-p sp-point-before-same-p))
    (sp-pair "'" nil  :unless '(sp-point-after-word-p sp-point-before-word-p sp-point-before-same-p))
    (sp-pair "\"" nil :unless '(sp-point-after-word-p sp-point-before-word-p sp-point-before-same-p))

    (sp-with-modes '(json-mode js2-mode ruby-mode enh-ruby-mode python-mode)
      (sp-local-pair "[" "]" :post-handlers '(:add "| " "SPC")))

    (after "yasnippet"
      (defadvice yas-expand (before advice-for-yas-expand activate)
        (sp-remove-active-pair-overlay)))))


(provide 'core-editor)
;;; core-editor.el ends here
