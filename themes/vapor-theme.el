;;; vapor-theme.el --- A dark vapor-inspired theme

;;; Commentary:
;; A port of the vapor colorscheme from vaporlush for Neovim

;;; Code:

(deftheme vapor
  "A dark vapor-inspired theme with blue and purple tones")

(let ((class '((class color) (min-colors 89)))
      ;; Background colors
      (bg "#0e102d")
      (bg-highlight "#0a2846")
      
      ;; Foreground colors
      (fg "#079ef0")
      (fg-highlight "#5885ed")
      
      ;; Primary colors
      (primary0 "#0700de")
      (primary1 "#0b03fc")
      (primary2 "#352ff5")
      (primary3 "#4e47ff")
      
      ;; Secondary colors
      (secondary0 "#b50465")
      (secondary1 "#e60580")
      (secondary2 "#fa34a1")
      (secondary3 "#fc65b8")
      
      ;; Tertiary colors
      (tertiary0 "#3f10cc")
      (tertiary1 "#6439e6")
      (tertiary2 "#8864f5")
      (tertiary3 "#af95fc")
      
      ;; Quartary colors
      (quartary0 "#fc5e03")
      (quartary1 "#fc853f")
      (quartary2 "#f59b67")
      (quartary3 "#ffb68c")
      
      ;; Git and status colors
      (info "#006655")
      (add "#00ccaa")
      (change "#e3307a")
      (danger "#c71e26")
      
      ;; Comment color
      (comment "#8da0b8"))

  (custom-theme-set-faces
   'vapor
   
   ;; Basic faces
   `(default ((,class (:background ,bg :foreground ,fg))))
   `(cursor ((,class (:background ,fg))))
   `(region ((,class (:background ,bg-highlight))))
   `(highlight ((,class (:background ,bg-highlight))))
   `(hl-line ((,class (:background ,bg-highlight))))
   `(fringe ((,class (:background ,bg))))
   `(vertical-border ((,class (:foreground ,comment))))
   
   ;; Font lock faces (mapped from vapor base.lua)
   `(font-lock-builtin-face ((,class (:foreground ,tertiary0))))  ; Special
   `(font-lock-comment-face ((,class (:foreground ,comment :slant italic))))  ; Comment
   `(font-lock-constant-face ((,class (:foreground ,secondary1))))  ; Constant
   `(font-lock-function-name-face ((,class (:foreground ,primary3 :weight bold :slant italic))))  ; Function
   `(font-lock-keyword-face ((,class (:foreground ,quartary1 :weight bold))))  ; Keyword
   `(font-lock-string-face ((,class (:foreground ,primary1))))  ; String
   `(font-lock-type-face ((,class (:foreground ,quartary0))))  ; Type
   `(font-lock-variable-name-face ((,class (:foreground ,secondary2 :slant italic))))  ; Identifier
   `(font-lock-warning-face ((,class (:foreground ,danger))))
   
   ;; Mode line with vapor-themed enhancements
   `(mode-line ((,class (:background ,bg-highlight :foreground ,fg :box (:line-width 2 :color ,primary2)))))
   `(mode-line-inactive ((,class (:background ,bg :foreground ,comment :box (:line-width 1 :color ,comment)))))
   
   ;; Doom-modeline faces for maximum visual impact
   `(doom-modeline-bar ((,class (:background ,primary2))))
   `(doom-modeline-bar-inactive ((,class (:background ,comment))))
   `(doom-modeline-project-name ((,class (:foreground ,secondary2 :weight bold))))
   `(doom-modeline-project-parent-dir ((,class (:foreground ,tertiary2))))
   `(doom-modeline-project-dir ((,class (:foreground ,primary3))))
   `(doom-modeline-buffer-path ((,class (:foreground ,fg-highlight))))
   `(doom-modeline-buffer-file ((,class (:foreground ,fg :weight bold))))
   `(doom-modeline-buffer-modified ((,class (:foreground ,quartary1 :weight bold))))
   `(doom-modeline-buffer-major-mode ((,class (:foreground ,primary2 :weight bold))))
   `(doom-modeline-buffer-minor-mode ((,class (:foreground ,tertiary3))))
   `(doom-modeline-debug ((,class (:foreground ,danger :weight bold))))
   `(doom-modeline-info ((,class (:foreground ,info))))
   `(doom-modeline-warning ((,class (:foreground ,quartary1))))
   `(doom-modeline-urgent ((,class (:foreground ,secondary1 :weight bold))))
   `(doom-modeline-notification ((,class (:foreground ,secondary2))))
   `(doom-modeline-unread-number ((,class (:foreground ,bg :background ,secondary1))))
   `(doom-modeline-persp-name ((,class (:foreground ,tertiary2))))
   `(doom-modeline-persp-buffer-not-in-persp ((,class (:foreground ,comment))))
   `(doom-modeline-lsp-success ((,class (:foreground ,add))))
   `(doom-modeline-lsp-warning ((,class (:foreground ,quartary1))))
   `(doom-modeline-lsp-error ((,class (:foreground ,danger))))
   `(doom-modeline-lsp-running ((,class (:foreground ,primary3))))
   `(doom-modeline-battery-charging ((,class (:foreground ,add))))
   `(doom-modeline-battery-full ((,class (:foreground ,add))))
   `(doom-modeline-battery-normal ((,class (:foreground ,primary2))))
   `(doom-modeline-battery-low ((,class (:foreground ,quartary1))))
   `(doom-modeline-battery-critical ((,class (:foreground ,danger))))
   `(doom-modeline-time ((,class (:foreground ,fg-highlight))))
   `(doom-modeline-input-method ((,class (:foreground ,secondary2))))
   `(doom-modeline-input-method-alt ((,class (:foreground ,tertiary2))))
   
   ;; Minibuffer
   `(minibuffer-prompt ((,class (:foreground ,primary2))))
   
   ;; Line numbers
   `(line-number ((,class (:foreground ,comment :background ,bg))))
   `(line-number-current-line ((,class (:foreground ,fg :background ,bg-highlight))))
   
   ;; Links
   `(link ((,class (:foreground ,primary2 :underline t))))
   `(link-visited ((,class (:foreground ,tertiary2 :underline t))))
   
   ;; Search
   `(isearch ((,class (:background ,secondary1 :foreground ,bg))))
   `(lazy-highlight ((,class (:background ,secondary0 :foreground ,bg))))
   
   ;; Error and warning faces
   `(error ((,class (:foreground ,danger))))
   `(warning ((,class (:foreground ,quartary1))))
   `(success ((,class (:foreground ,add))))
   
   ;; Helm faces
   `(helm-source-header ((,class (:background ,bg-highlight :foreground ,fg :weight bold))))
   `(helm-selection ((,class (:background ,bg-highlight))))
   `(helm-match ((,class (:foreground ,secondary2))))
   `(helm-ff-directory ((,class (:foreground ,primary2))))
   `(helm-ff-file ((,class (:foreground ,fg))))
   `(helm-ff-executable ((,class (:foreground ,add))))
   
   ;; Which-key faces
   `(which-key-key-face ((,class (:foreground ,primary2))))
   `(which-key-separator-face ((,class (:foreground ,comment))))
   `(which-key-note-face ((,class (:foreground ,tertiary2))))
   `(which-key-command-description-face ((,class (:foreground ,fg))))
   `(which-key-group-description-face ((,class (:foreground ,secondary2))))
   
   ;; Company faces
   `(company-tooltip ((,class (:background ,bg-highlight :foreground ,fg))))
   `(company-tooltip-selection ((,class (:background ,primary0 :foreground ,fg))))
   `(company-tooltip-common ((,class (:foreground ,secondary2))))
   `(company-scrollbar-bg ((,class (:background ,bg))))
   `(company-scrollbar-fg ((,class (:background ,comment))))
   
   ;; Evil faces
   `(evil-ex-info ((,class (:foreground ,danger))))
   `(evil-ex-search ((,class (:background ,secondary1 :foreground ,bg))))
   
   ;; Magit faces
   `(magit-section-heading ((,class (:foreground ,primary2 :weight bold))))
   `(magit-branch-local ((,class (:foreground ,primary3))))
   `(magit-branch-remote ((,class (:foreground ,add))))
   `(magit-diff-added ((,class (:foreground ,add))))
   `(magit-diff-removed ((,class (:foreground ,danger))))
   `(magit-diff-context ((,class (:foreground ,comment))))
   `(magit-hash ((,class (:foreground ,tertiary2))))
   
   ;; Flycheck faces
   `(flycheck-error ((,class (:underline (:style wave :color ,danger)))))
   `(flycheck-warning ((,class (:underline (:style wave :color ,quartary1)))))
   `(flycheck-info ((,class (:underline (:style wave :color ,info)))))))

(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'vapor)

;;; vapor-theme.el ends here