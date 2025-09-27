;;; init.el --- Emacs Configuration

;;; Commentary:
;; Basic Emacs configuration with all-the-icons and vapor theme

;;; Code:

;; Package management setup
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package if not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Basic UI improvements
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

;; Font configuration
(when (display-graphic-p)
  ;; Set default font
  (set-face-attribute 'default nil
                      :font "VictorMono Nerd Font Propo"
                      :height 140)
  ;; Set fixed-pitch font (for code)
  (set-face-attribute 'fixed-pitch nil
                      :font "VictorMono Nerd Font Propo"
                      :height 160)
  ;; Set variable-pitch font (for text)
  (set-face-attribute 'variable-pitch nil
                      :font "VictorMono Nerd Font Propo"
                      :height 180)
  ;; Ensure font is applied to frames
  (add-to-list 'default-frame-alist '(font . "VictorMono Nerd Font Propo-16")))

;; All-the-icons package
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

;; Nerd icons (alternative/complement to all-the-icons)
(use-package nerd-icons
  :ensure t)

;; Ligature support
(use-package ligature
  :ensure t
  :config
  ;; Enable ligatures in programming modes
  (ligature-set-ligatures 'prog-mode 
    '("--" "---" "==" "===" "!=" "!==" "=!=" "=:=" "=/=" "<=" ">=" "&&" "&&&" "&=" "++" 
      "+++" "***" ";;" "!!" "??" "?:" "?." "?=" "<:" ":<" ":>" ">:" "<>" "<<<" ">>>" 
      "<<" ">>" "||" "-|" "_|_" "|-" "|=" "||=" "##" "###" "####" "#####" "#(" "#?" 
      "#[" "#{" "#_" "#_(" "#:" "#!" "#=" "^=" "<$>" "<*" "<*>" "<+>" "<-" "<--" 
      "<->" "->" "-->" "-<" "-<<" "=<<" "=<=" "<=<" "<==" "<=>" "<==>" "==>" "=>" 
      "=>>" ">=>" ">>=" ">>-" ">-" ">--" "-~" "~-" "~@" "~=" "~>" "~~>" "%%" 
      "***" "*>" "*/" "\\\\" "\\\\\\" "{-" "-}" "{{" "}}" "[[" "]]" ".." "..." 
      "..=" "..<" ".?" "::" ":::" ":=" "::=" ":?" ":?>" "//" "///" "/=" "/==" "/>" 
      "//*" "*/" "|||" "||" "|>" "^^" "^?" "|->" "|=>" "|>-" "|>>"))
  
  ;; Enable ligatures globally
  (global-ligature-mode t))

;; Evil mode for vim keybindings
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  
  ;; Dvorak movement mappings (h=left, t=down, n=up, s=right)
  (define-key evil-normal-state-map "t" 'evil-next-line)
  (define-key evil-normal-state-map "n" 'evil-previous-line)
  (define-key evil-normal-state-map "s" 'evil-forward-char)
  (define-key evil-normal-state-map "k" 'evil-search-next)
  
  ;; Visual mode dvorak mappings
  (define-key evil-visual-state-map "t" 'evil-next-line)
  (define-key evil-visual-state-map "n" 'evil-previous-line)
  (define-key evil-visual-state-map "s" 'evil-forward-char)
  
  ;; Window navigation with Ctrl + dvorak keys
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-t") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-n") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-s") 'evil-window-right)
  
  ;; Uppercase mappings
  (define-key evil-normal-state-map "T" 'evil-join)
  (define-key evil-normal-state-map "N" 'man)
  (define-key evil-normal-state-map "S" 'evil-window-bottom)
  (define-key evil-normal-state-map "K" 'evil-search-previous))

;; Evil collection for better evil integration
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;; Magit for git integration
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; Projectile for project management
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

;; LSP Mode
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  (rust-mode . lsp)
  (go-mode . lsp)
  (js-mode . lsp)
  (typescript-mode . lsp)
  (python-mode . lsp)
  (csharp-mode . lsp)
  (lua-mode . lsp)
  (elixir-mode . lsp)
  :commands lsp)

;; LSP UI for better interface
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-show-with-mouse t)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover t)
  (setq lsp-ui-peek-enable t))

;; LSP Ivy integration for fuzzy finding (telescope equivalent)
(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol lsp-ivy-global-workspace-symbol)

;; Consult LSP for additional fuzzy finding
(use-package consult-lsp
  :ensure t
  :commands consult-lsp-symbols consult-lsp-diagnostics)

;; DAP mode for debugging (like your Neovim DAP setup)
(use-package dap-mode
  :ensure t
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1))

;; DAP configurations are built into dap-mode
;; No separate packages needed for dap-go, dap-node, dap-python

;; Company for completion
(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

;; Flycheck for syntax checking
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Language-specific modes
(use-package rust-mode
  :ensure t)

(use-package go-mode
  :ensure t)

(use-package typescript-mode
  :ensure t)

(use-package csharp-mode
  :ensure t)

(use-package lua-mode
  :ensure t)

(use-package python-mode
  :ensure t)

(use-package elixir-mode
  :ensure t)

;; Gleam support (manual mode since gleam-mode isn't in MELPA)
;; Use rust-mode as a reasonable fallback for .gleam files
(add-to-list 'auto-mode-alist '("\\.gleam\\'" . rust-mode))

;; Enhanced Rust support (like your rustaceanvim)
(use-package rustic
  :ensure t
  :config
  (setq rustic-lsp-client 'lsp-mode)
  (setq rustic-format-on-save t))

;; Enhanced Go support
(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook (lambda ()
                            (setq tab-width 4)
                            (setq indent-tabs-mode t))))

;; Formatting tools (like your null-ls setup)
(use-package format-all
  :ensure t
  :commands format-all-mode format-all-buffer)

;; Tree-sitter for better syntax highlighting
(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter)

;; Consult for better searching (telescope equivalent)
(use-package consult
  :ensure t
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)))

;; 🌟 BANGER STATUS LINE CONFIGURATION 🌟
;; Custom doom-modeline with vapor theme integration

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  ;; Enable beautiful icons and segments
  (setq doom-modeline-height 35)              ; Taller for more presence
  (setq doom-modeline-bar-width 6)            ; Thicker accent bar
  (setq doom-modeline-hud t)                  ; Fancy scrollbar indicator
  (setq doom-modeline-window-width-limit fill-column)
  
  ;; Show all the cool stuff
  (setq doom-modeline-icon t)                 ; Beautiful icons
  (setq doom-modeline-major-mode-icon t)      ; Language icons
  (setq doom-modeline-major-mode-color-icon t) ; Colored language icons
  (setq doom-modeline-buffer-state-icon t)    ; Buffer state indicators
  (setq doom-modeline-buffer-modification-icon t) ; Modification indicators
  (setq doom-modeline-unicode-fallback t)     ; Unicode fallbacks
  (setq doom-modeline-minor-modes t)          ; Show minor modes
  (setq doom-modeline-enable-word-count t)    ; Word count for text
  (setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))
  
  ;; Project and version control
  (setq doom-modeline-project-detection 'projectile) ; Use projectile
  (setq doom-modeline-vcs-max-length 20)      ; Show git branch
  (setq doom-modeline-check-simple-format t)  ; Simple check format
  (setq doom-modeline-number-limit 99)        ; Limit numbers
  
  ;; LSP and syntax checking
  (setq doom-modeline-lsp t)                  ; Show LSP status
  (setq doom-modeline-lsp-icon t)             ; LSP icon
  (setq doom-modeline-checker-simple-format t) ; Simple checker format
  
  ;; Workspace and buffer info
  (setq doom-modeline-buffer-name t)          ; Show buffer name
  (setq doom-modeline-highlight-modified-buffer-name t) ; Highlight when modified
  (setq doom-modeline-workspace-name t)       ; Show workspace
  (setq doom-modeline-persp-name t)           ; Show perspective
  (setq doom-modeline-persp-icon t)           ; Perspective icon
  
  ;; Time and environment
  (setq doom-modeline-time t)                 ; Show time
  (setq doom-modeline-time-icon t)            ; Time icon
  (setq doom-modeline-env-version t)          ; Show language versions
  (setq doom-modeline-env-enable-python t)    ; Python version
  (setq doom-modeline-env-enable-ruby t)      ; Ruby version
  (setq doom-modeline-env-enable-perl t)      ; Perl version
  (setq doom-modeline-env-enable-go t)        ; Go version
  (setq doom-modeline-env-enable-elixir t)    ; Elixir version
  (setq doom-modeline-env-enable-rust t)      ; Rust version
  
  ;; Advanced features
  (setq doom-modeline-github t)               ; GitHub notifications
  (setq doom-modeline-github-interval (* 30 60)) ; Check every 30 minutes
  (setq doom-modeline-gnus t)                 ; Email notifications
  (setq doom-modeline-mu4e t)                 ; Mu4e integration
  (setq doom-modeline-irc t)                  ; IRC integration
  (setq doom-modeline-battery t)              ; Battery status on laptops
  
  ;; Customize segments order and appearance
  (doom-modeline-def-modeline 'adamkali-custom
    '(bar workspace-name window-number modals matches follow buffer-info remote-host buffer-position word-count parrot selection-info)
    '(compilation objed-state misc-info persp-name battery grip irc mu4e gnus github debug lsp minor-modes input-method indent-info buffer-encoding major-mode process vcs time))
  
  ;; Apply custom modeline
  (defun setup-custom-modeline ()
    (doom-modeline-set-modeline 'adamkali-custom 'default))
  
  (add-hook 'doom-modeline-mode-hook 'setup-custom-modeline))

;; Configure emacsclient to open dashboard by default
(defun adamkali/setup-client-dashboard ()
  "Setup dashboard for emacsclient connections."
  (when (daemonp)
    ;; Switch to dashboard when client connects
    (dashboard-refresh-buffer)
    (switch-to-buffer dashboard-buffer-name)))

;; Hook for new frames (emacsclient connections)
(add-hook 'server-after-make-frame-hook 'adamkali/setup-client-dashboard)

;; Also ensure dashboard shows on daemon startup
(add-hook 'after-init-hook 
          (lambda ()
            (when (daemonp)
              (dashboard-refresh-buffer))))

;; Beautiful minibuffer with icons (complements the status line)
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

;; Enhanced window dividers to match the status line aesthetics
;; Using built-in window-divider-mode (no package needed)
(when (display-graphic-p)
  (setq window-divider-default-bottom-width 3)
  (setq window-divider-default-right-width 3)
  (setq window-divider-default-places t)
  (window-divider-mode 1))

;; 🎭 EXTRA VISUAL FLAIR FOR THE STATUS LINE 🎭

;; Parrot mode - animated parrot in status line (because why not!)
(use-package parrot
  :ensure t
  :config
  (parrot-mode 1)
  (setq parrot-animate t)
  (setq parrot-animation-frame-interval 0.075)) ; Fast animation

;; Minions - collapsible minor modes display
(use-package minions
  :ensure t
  :config
  (minions-mode 1)
  (setq minions-mode-line-lighter "🧙"))  ; Wizard emoji for minor modes

;; Hide mode line in specific modes for clean look
(use-package hide-mode-line
  :ensure t
  :hook ((neotree-mode imenu-list-minor-mode minimap-mode) . hide-mode-line-mode))

;; Beautiful tab bar (if using multiple tabs)
(use-package centaur-tabs
  :ensure t
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-headline-match)
  (setq centaur-tabs-style "wave")
  (setq centaur-tabs-height 32)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-set-modified-marker t)
  (setq centaur-tabs-modified-marker "●")
  (setq centaur-tabs-cycle-scope 'tabs)
  (setq centaur-tabs-set-bar 'over))

;; Suppress compilation warnings
(setq warning-minimum-level :error)

;; 📝 ORG-MODE CONFIGURATION 📝
;; Comprehensive org-mode setup with todos, export, and documentation

(use-package org
  :ensure t
  :config
  ;; Set org directory
  (setq org-directory "~/orgmode/")
  (setq org-default-notes-file (concat org-directory "inbox.org"))
  
  ;; Org files for agenda
  (setq org-agenda-files (list org-directory))
  
  ;; Todo keywords with colors
  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN-PROGRESS(p)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  
  ;; Todo keyword faces (vapor theme colors)
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "#fc853f" :weight bold))          ; quartary1
          ("IN-PROGRESS" . (:foreground "#352ff5" :weight bold))   ; primary2
          ("WAITING" . (:foreground "#8864f5" :weight bold))       ; tertiary2
          ("DONE" . (:foreground "#00ccaa" :weight bold))          ; add
          ("CANCELLED" . (:foreground "#c71e26" :weight bold))))   ; danger
  
  ;; Org capture templates for quick notes and todos
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/orgmode/todos.org" "System Todos")
           "* TODO %?\n  %i\n  %a")
          ("n" "Note" entry (file+headline "~/orgmode/notes.org" "Quick Notes")
           "* %?\n  %i\n  %a")
          ("k" "Keybinding" entry (file+headline "~/orgmode/keybindings.org" "Emacs Keybindings")
           "* %?\n  %i\n  %a")
          ("p" "Project" entry (file+headline "~/orgmode/projects.org" "Projects")
           "* %? :PROJECT:\n  %i\n  %a")))
  
  ;; Variable heading sizes
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))
  
  ;; Better org appearance
  (setq org-hide-emphasis-markers t)
  (setq org-startup-indented t)
  (setq org-pretty-entities t)
  (setq org-startup-with-inline-images t)
  (setq org-fontify-whole-heading-line t)
  (setq org-fontify-done-headline t)
  (setq org-fontify-quote-and-verse-blocks t)
  
  ;; Agenda configuration
  (setq org-agenda-start-on-weekday nil)
  (setq org-agenda-start-day "today")
  (setq org-agenda-span 7)
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-scheduled-if-done t))

;; Org bullets for beautiful headings
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode)
  :config
  (setq org-bullets-bullet-list '("⚡" "🔥" "💎" "🌟" "✨" "💫" "⭐")))

;; Enhanced export capabilities (like obsidian)
(use-package ox-hugo
  :ensure t
  :after ox)

(use-package ox-gfm
  :ensure t
  :after ox)

(use-package htmlize
  :ensure t)

;; Org-roam for better note-taking (obsidian-like)
;; Temporarily disabled due to package availability
;; (use-package org-roam
;;   :ensure t
;;   :init
;;   (setq org-roam-v2-ack t)
;;   :custom
;;   (org-roam-directory "~/orgmode/roam/")
;;   (org-roam-completion-everywhere t)
;;   :config
;;   (org-roam-db-autosync-mode))

;; Dashboard for startup screen
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  
  ;; Set the banner
  (setq dashboard-startup-banner "/mnt/c/Users/adam/Downloads/infernape transporent.png")
  (setq dashboard-banner-logo-title "Welcome to Emacs!")
  (setq dashboard-center-content t)
  
  ;; Image size constraints (keep it reasonable)
  (setq dashboard-image-banner-max-height 200)
  (setq dashboard-image-banner-max-width 300)
  
  ;; Try to improve PNG transparency handling
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))
  
  ;; Set dashboard items
  (setq dashboard-items '((recents   . 5)
                          (projects  . 5)
                          (bookmarks . 5)))
  
  ;; Dashboard settings
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-init-info t)
  
  ;; Navigator buttons
  (setq dashboard-navigator-buttons
        `(((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
            "GitHub"
            "Browse GitHub"
            (lambda (&rest _) (browse-url "https://github.com")))
           (,(all-the-icons-faicon "gitlab" :height 1.1 :v-adjust 0.0)
            "GitLab" 
            "Browse GitLab"
            (lambda (&rest _) (browse-url "https://gitlab.com")))
           (,(all-the-icons-octicon "gear" :height 1.1 :v-adjust 0.0)
            "Config"
            "Open config"
            (lambda (&rest _) (find-file "~/.emacs.d/init.el"))))))
  
  ;; Footer
  (setq dashboard-footer-messages '("Happy coding!"))
  (setq dashboard-footer-icon (all-the-icons-octicon "dashboard"
                                                     :height 1.1
                                                     :v-adjust -0.05
                                                     :face 'font-lock-keyword-face))
  
  ;; Set dashboard as initial buffer
  (setq initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name))))

;; Which-key for command discovery (like Doom/Spacemacs)
(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-prefix-prefix "+"))

;; General for leader key management
(use-package general
  :ensure t
  :config
  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

;; Helm for fuzzy finding (telescope equivalent)
(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (setq helm-split-window-in-side-p t
        helm-move-to-line-cycle-in-source t
        helm-ff-search-library-in-sexp t
        helm-scroll-amount 8
        helm-ff-file-name-history-use-recentf t))

;; Helm-projectile integration
(use-package helm-projectile
  :ensure t
  :after (helm projectile)
  :config
  (helm-projectile-on))

;; 💻 TERMINAL INTEGRATION 💻
;; Modern terminal emulation with vterm and multi-terminal support

;; VTerm - High-performance terminal emulator
(use-package vterm
  :ensure t
  :config
  ;; Performance and behavior settings
  (setq vterm-max-scrollback 10000)
  (setq vterm-buffer-name-string "vterm %s")
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-clear-scrollback-when-clearing t)
  
  ;; Integration settings
  (setq vterm-copy-exclude-prompt t)
  (setq vterm-use-vterm-prompt-detection-method t)
  
  ;; Evil mode integration
  (evil-define-key 'insert vterm-mode-map (kbd "C-c") #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-d") #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-z") #'vterm--self-insert)
  (evil-define-key 'normal vterm-mode-map (kbd "C-c") #'vterm-send-C-c)
  (evil-define-key 'normal vterm-mode-map (kbd "C-d") #'vterm-send-C-d)
  
  ;; Custom vterm functions for better integration
  (defun vterm-other-window ()
    "Open vterm in other window."
    (interactive)
    (let ((current-window (selected-window)))
      (if (one-window-p)
          (split-window-right))
      (other-window 1)
      (vterm)
      (select-window current-window)))
  
  ;; Directory tracking
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq-local evil-insert-state-cursor 'box)
              (evil-insert-state))))

;; Multi-VTerm - Multiple terminal management
(use-package multi-vterm
  :ensure t
  :after vterm
  :config
  ;; Buffer naming
  (setq multi-vterm-buffer-name "terminal")
  (setq multi-vterm-dedicated-window-height-percent 30)
  
  ;; Dedicated terminal settings
  (setq multi-vterm-dedicated-select-after-open-p t)
  (setq multi-vterm-dedicated-close-on-exit t)
  
  ;; Custom functions for better workflow
  (defun multi-vterm-project ()
    "Create or switch to a vterm buffer for the current project."
    (interactive)
    (let ((project-name (projectile-project-name)))
      (if project-name
          (let ((buffer-name (format "vterm-%s" project-name)))
            (if (get-buffer buffer-name)
                (switch-to-buffer buffer-name)
              (multi-vterm)
              (rename-buffer buffer-name)))
        (multi-vterm))))
  
  (defun multi-vterm-here ()
    "Open vterm in current directory."
    (interactive)
    (let ((default-directory (if (buffer-file-name)
                                 (file-name-directory (buffer-file-name))
                               default-directory)))
      (multi-vterm))))

;; VTerm Toggle - Quick terminal toggle
(use-package vterm-toggle
  :ensure t
  :after vterm
  :config
  ;; Toggle settings
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (setq vterm-toggle-reset-window-configration-after-exit t)
  
  ;; Window management
  (setq vterm-toggle-cd-auto-create-buffer t)
  (setq vterm-toggle-use-dedicated-buffer t)
  
  ;; Key mappings for quick access
  (global-set-key (kbd "C-`") #'vterm-toggle)
  (global-set-key (kbd "C-~") #'vterm-toggle-cd)
  
  ;; Custom toggle functions
  (defun vterm-toggle-split-below ()
    "Open vterm in split below."
    (interactive)
    (let ((vterm-toggle-fullscreen-p nil))
      (vterm-toggle)
      (when (get-buffer-window vterm-toggle--buffer-name)
        (with-selected-window (get-buffer-window vterm-toggle--buffer-name)
          (delete-other-windows-vertically)))))
  
  (defun vterm-toggle-split-right ()
    "Open vterm in split right."
    (interactive)
    (let ((vterm-toggle-fullscreen-p nil))
      (split-window-right)
      (other-window 1)
      (vterm-toggle))))

;; EShell enhancements for when you prefer elisp-based shell
(use-package eshell
  :ensure nil ; built-in
  :config
  ;; EShell prompt customization
  (setq eshell-prompt-function
        (lambda ()
          (concat
           (propertize (format "%s" (eshell/pwd)) 'face '(:foreground "#8864f5"))
           (propertize " λ " 'face '(:foreground "#fc853f" :weight bold)))))
  
  (setq eshell-prompt-regexp "^[^λ]* λ ")
  (setq eshell-highlight-prompt nil)
  
  ;; History settings
  (setq eshell-history-size 1000)
  (setq eshell-save-history-on-exit t)
  (setq eshell-hist-ignoredups t)
  
  ;; Visual commands (run in term instead of eshell)
  (add-to-list 'eshell-visual-commands "htop")
  (add-to-list 'eshell-visual-commands "top")
  (add-to-list 'eshell-visual-commands "vim")
  (add-to-list 'eshell-visual-commands "nvim")
  (add-to-list 'eshell-visual-commands "ssh")
  (add-to-list 'eshell-visual-commands "tail")
  (add-to-list 'eshell-visual-commands "less")
  
  ;; Aliases for common commands
  (defun eshell/clear ()
    "Clear the eshell buffer."
    (eshell/cd)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (eshell-send-input)))
  
  (defun eshell/ff (&rest args)
    "Use helm-find-files from eshell."
    (helm-find-files (car args)))
  
  ;; Git integration
  (defun eshell/g (&rest args)
    "Wrapper around git command with magit integration."
    (cond
     ((equal args '("status")) (magit-status))
     ((equal args '("log")) (magit-log-current))
     (t (apply #'eshell-exec-visual (cons "git" args))))))

;; Eat - Another modern terminal emulator option
(use-package eat
  :ensure t
  :config
  ;; Integration with project
  (setq eat-kill-buffer-on-exit t)
  (setq eat-enable-yank-to-terminal t)
  
  ;; Custom eat function for project-aware terminals
  (defun eat-project ()
    "Start eat terminal in project root."
    (interactive)
    (let ((default-directory (projectile-project-root)))
      (eat))))

;; Terminal integration with projectile
(defun terminal-here ()
  "Open terminal in current directory or project root."
  (interactive)
  (let ((dir (if (and (bound-and-true-p projectile-mode)
                      (projectile-project-p))
                 (projectile-project-root)
               default-directory)))
    (let ((default-directory dir))
      (call-interactively #'vterm))))

;; Shell completion enhancement
(use-package shell-pop
  :ensure t
  :config
  (setq shell-pop-shell-type '("vterm" "*vterm*" (lambda () (vterm))))
  (setq shell-pop-window-size 30)
  (setq shell-pop-full-span t)
  (setq shell-pop-window-position "bottom"))

;; Leader key bindings (Space-based like Doom/Spacemacs)
(my/leader-keys
  "SPC" 'helm-M-x                    ; Space Space = command palette
  "TAB" 'evil-switch-to-windows-last-buffer  ; Space Tab = last buffer
  
  ;; File operations (Space f)
  "f" '(:ignore t :which-key "file")
  "ff" 'helm-find-files             ; Space f f = find files
  "fr" 'helm-recentf                ; Space f r = recent files
  "fs" 'save-buffer                 ; Space f s = save file
  "fS" 'write-file                  ; Space f S = save as
  "fd" 'dired                       ; Space f d = directory
  
  ;; Search operations (Space s) - enhanced with LSP like Neovim
  "s" '(:ignore t :which-key "search")
  "ss" 'helm-occur                  ; Space s s = search in buffer
  "sp" 'helm-projectile-grep        ; Space s p = search in project
  "sf" 'helm-projectile-find-file   ; Space s f = find file in project
  "sb" 'helm-mini                   ; Space s b = search buffers
  "sr" 'helm-resume                 ; Space s r = resume last search
  
  ;; LSP search operations (matches your <space>f telescope bindings)
  "sS" 'lsp-ivy-workspace-symbol    ; Space s S = workspace symbols (<space>fs)
  "sd" 'flycheck-list-errors        ; Space s d = diagnostics (<space>fd)
  "sR" 'lsp-ivy-global-workspace-symbol ; Space s R = global references (<space>fr)
  
  ;; Project operations (Space p)
  "p" '(:ignore t :which-key "project")
  "pp" 'helm-projectile-switch-project  ; Space p p = switch project
  "pf" 'helm-projectile-find-file       ; Space p f = find file in project
  "pb" 'helm-projectile-switch-to-buffer ; Space p b = switch buffer in project
  "pr" 'projectile-run-project          ; Space p r = run project
  "pc" 'projectile-compile-project      ; Space p c = compile project
  "pt" 'projectile-test-project         ; Space p t = test project
  
  ;; Buffer operations (Space b)
  "b" '(:ignore t :which-key "buffer")
  "bb" 'helm-mini                   ; Space b b = switch buffer
  "bd" 'kill-this-buffer            ; Space b d = delete buffer
  "bn" 'next-buffer                 ; Space b n = next buffer
  "bp" 'previous-buffer             ; Space b p = previous buffer
  "br" 'revert-buffer               ; Space b r = reload buffer
  
  ;; Git operations (Space g)
  "g" '(:ignore t :which-key "git")
  "gs" 'magit-status                ; Space g s = git status
  "gc" 'magit-commit                ; Space g c = git commit
  "gp" 'magit-push                  ; Space g p = git push
  "gl" 'magit-log                   ; Space g l = git log
  "gb" 'magit-blame                 ; Space g b = git blame
  
  ;; Window operations (Space w)
  "w" '(:ignore t :which-key "window")
  "wh" 'evil-window-left            ; Space w h = window left
  "wt" 'evil-window-down            ; Space w t = window down (dvorak)
  "wn" 'evil-window-up              ; Space w n = window up (dvorak)
  "ws" 'evil-window-right           ; Space w s = window right (dvorak)
  "wd" 'delete-window               ; Space w d = delete window
  "wD" 'delete-other-windows        ; Space w D = delete other windows
  "wv" 'split-window-right          ; Space w v = vertical split
  "wo" 'split-window-below          ; Space w o = horizontal split
  
  ;; LSP operations (Space l) - comprehensive like Neovim
  "l" '(:ignore t :which-key "lsp")
  
  ;; Core LSP navigation (matches your Neovim <BS> bindings)
  "lc" 'lsp-execute-code-action     ; Space l c = code action (<BS>c)
  "lD" 'lsp-find-declaration        ; Space l D = declaration (<BS>D)
  "ld" 'lsp-find-definition         ; Space l d = definition (<BS>d)
  "li" 'lsp-find-implementation     ; Space l i = implementation (<BS>i)
  "lk" 'lsp-describe-thing-at-point ; Space l k = hover/documentation (<BS>k)
  "lR" 'lsp-find-references         ; Space l R = references (<BS>R)
  "lr" 'lsp-rename                  ; Space l r = rename (<BS>r)
  
  ;; Diagnostics (matches your <BS>s/<BS>a pattern)
  "ls" 'flycheck-previous-error     ; Space l s = previous diagnostic
  "la" 'flycheck-next-error         ; Space l a = next diagnostic
  "le" 'flycheck-list-errors        ; Space l e = list all errors
  "lE" 'flycheck-explain-error-at-point ; Space l E = explain error
  
  ;; Formatting (matches your <space>lf)
  "lf" 'lsp-format-buffer           ; Space l f = format buffer
  "lF" 'lsp-format-region           ; Space l F = format region
  
  ;; LSP workspace operations
  "lw" '(:ignore t :which-key "workspace")
  "lwa" 'lsp-workspace-folders-add    ; Space l w a = add folder
  "lwr" 'lsp-workspace-folders-remove ; Space l w r = remove folder
  "lws" 'lsp-workspace-symbol         ; Space l w s = workspace symbols
  "lwS" 'lsp-workspace-restart        ; Space l w S = restart workspace
  
  ;; LSP UI operations
  "lu" '(:ignore t :which-key "ui")
  "lud" 'lsp-ui-doc-show           ; Space l u d = show documentation
  "luD" 'lsp-ui-doc-hide           ; Space l u D = hide documentation
  "lus" 'lsp-ui-sideline-toggle    ; Space l u s = toggle sideline
  "luf" 'lsp-ui-flycheck-list      ; Space l u f = flycheck list
  "lup" 'lsp-ui-peek-find-definitions ; Space l u p = peek definitions
  
  ;; LSP toggle operations
  "lt" '(:ignore t :which-key "toggle")
  "lts" 'lsp-ui-sideline-toggle    ; Space l t s = toggle sideline
  "ltd" 'lsp-ui-doc-mode           ; Space l t d = toggle doc mode
  "ltf" 'lsp-headerline-breadcrumb-mode ; Space l t f = toggle breadcrumb
  "ltl" 'lsp-lens-mode             ; Space l t l = toggle lens mode
  
  ;; Help operations (Space h)
  "h" '(:ignore t :which-key "help")
  "hf" 'describe-function           ; Space h f = describe function
  "hv" 'describe-variable           ; Space h v = describe variable
  "hk" 'describe-key                ; Space h k = describe key
  "hm" 'describe-mode               ; Space h m = describe mode
  "hp" 'describe-package            ; Space h p = describe package
  
  ;; Dashboard operations (Space d)
  "d" '(:ignore t :which-key "dashboard")
  "dd" 'dashboard-open              ; Space d d = open dashboard
  "dr" 'dashboard-refresh-buffer    ; Space d r = refresh dashboard
  
  ;; Toggle operations (Space t)
  "t" '(:ignore t :which-key "toggle")
  "tl" 'toggle-truncate-lines       ; Space t l = toggle line wrap
  "tn" 'display-line-numbers-mode   ; Space t n = toggle line numbers
  "tw" 'whitespace-mode             ; Space t w = toggle whitespace
  "tf" 'auto-fill-mode              ; Space t f = toggle auto-fill
  
  ;; Org-mode operations (Space o)
  "o" '(:ignore t :which-key "org-mode")
  "oa" 'org-agenda                  ; Space o a = org agenda
  "oc" 'org-capture                 ; Space o c = org capture
  "ol" 'org-store-link              ; Space o l = store link
  "oo" 'org-open-at-point           ; Space o o = open link
  "ot" 'org-todo                    ; Space o t = cycle todo state
  "os" 'org-schedule                ; Space o s = schedule item
  "od" 'org-deadline                ; Space o d = set deadline
  "op" 'org-priority                ; Space o p = set priority
  "oe" 'org-export-dispatch         ; Space o e = export menu
  "oR" 'org-refile                  ; Space o R = refile (capital R)
  "oA" 'org-archive-subtree         ; Space o A = archive
  
  ;; Org-roam operations (Space o r) - disabled until package available
  ;; "or" '(:ignore t :which-key "org-roam")
  ;; "orf" 'org-roam-node-find         ; Space o r f = find node
  ;; "ori" 'org-roam-node-insert       ; Space o r i = insert node
  ;; "org" 'org-roam-graph             ; Space o r g = show graph
  ;; "orc" 'org-roam-capture           ; Space o r c = roam capture
  ;; "orb" 'org-roam-buffer-toggle     ; Space o r b = toggle buffer
  
  ;; Debug operations (Space d for debugging like your DAP setup)
  "D" '(:ignore t :which-key "debug")
  "Dd" 'dap-debug                   ; Space D d = start debugging
  "Db" 'dap-breakpoint-toggle       ; Space D b = toggle breakpoint
  "Dc" 'dap-continue                ; Space D c = continue
  "Dn" 'dap-next                    ; Space D n = step over
  "Di" 'dap-step-in                 ; Space D i = step in
  "Do" 'dap-step-out                ; Space D o = step out
  "Dr" 'dap-restart                 ; Space D r = restart
  "Ds" 'dap-stop                    ; Space D s = stop
  "Du" 'dap-ui-locals               ; Space D u = show locals
  "De" 'dap-eval-thing-at-point     ; Space D e = eval at point
  
  ;; Rust-specific operations (Space m for language-specific like your <M-l>)
  "m" '(:ignore t :which-key "language-specific")
  "mr" '(:ignore t :which-key "rust")
  "mrd" 'rust-dbg-wrap-or-unwrap    ; Space m r d = rust debuggables
  "mrt" 'rust-test                  ; Space m r t = rust testables  
  "mra" 'rust-run                   ; Space m r a = rust run
  "mrc" 'rust-check                 ; Space m r c = rust check
  "mrC" 'rust-clippy                ; Space m r C = rust clippy
  
  ;; Terminal operations (Space `)
  "`" '(:ignore t :which-key "terminal")
  "``" 'vterm                       ; Space ` ` = open vterm
  "`v" 'vterm                       ; Space ` v = vertical terminal
  "`h" 'vterm-other-window          ; Space ` h = horizontal terminal
  "`t" 'multi-vterm                 ; Space ` t = multi-terminal
  "`n" 'multi-vterm-next            ; Space ` n = next terminal
  "`p" 'multi-vterm-prev            ; Space ` p = previous terminal
  "`d" 'multi-vterm-dedicated-toggle ; Space ` d = dedicated terminal
  "`r" 'vterm-rename-buffer         ; Space ` r = rename terminal
  "`k" 'kill-buffer                 ; Space ` k = kill terminal
  "`c" 'term                        ; Space ` c = classic term
  "`e" 'eshell                      ; Space ` e = eshell
  "`s" 'shell)                      ; Space ` s = shell

;; Load custom themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Disable other themes first, then load vapor theme
(mapc #'disable-theme custom-enabled-themes)
(load-theme 'vapor t)

;; Ensure theme is applied after package loading
(add-hook 'after-init-hook
          (lambda ()
            (mapc #'disable-theme custom-enabled-themes)
            (load-theme 'vapor t)))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages '(nerd-icons all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
