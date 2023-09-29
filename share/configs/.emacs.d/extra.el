;; You will most likely need to adjust this font size for your system!
(defvar ava/default-font-size 180)
(defvar ava/default-variable-font-size 180)

;; (defvar ava/transparency-level '(93 . 93))
;; (defvar ava/transparency-level-list '(alpha . (93 . 93)))

(defvar ava/leader-key "SPC")

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("org" . "https://orgmode.org/elpa/")
                        ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
(package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
(package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
(setq user-emacs-directory "~/Documents/.emacs")
(setq user-emacs-configs-directory (concat (getenv "HOME") "/.emacs.d/"))

(use-package no-littering)

(setq backup-directory-alist '(("." . "/home/alexvanaxe/Documents/.emacs_save")))

(setq extra-config-file "~/.emacs.d/rice.el")
(load extra-config-file)
(setq ava-cool-stuffs "~/.emacs.d/cool.el")
(load ava-cool-stuffs)

;;(defvar bootstrap-version)
;;(let ((bootstrap-file
;;       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;      (bootstrap-version 5))
;;  (unless (file-exists-p bootstrap-file)
;;    (with-current-buffer
;;        (url-retrieve-synchronously
;;         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
;;         'silent 'inhibit-cookies)
;;      (goto-char (point-max))
;;      (eval-print-last-sexp)))
;;  (load bootstrap-file nil 'nomessage))

(use-package lolsmacs
  :disabled
  :straight (:host github
             :repo "grettke/lolsmacs"
             :files ("*.el"))
  :init
  (require 'lolsmacs)
  (lolsmacs-init)
  :config
  (desktop-save-mode 0)
  (setq lolsmacs-save-on-hooks nil)
)

(set-charset-priority 'unicode)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

(setq-default
   help-window-select t        ;; Focus new help windows when opened
   debug-on-error nil   ;; Set to t to debug on error
   indent-tabs-mode nil        ;; Adjust indent using 'space', not 'tab'
   jit-lock-defer-time 0       ;; Defer fontification while there is input pending
   window-combination-resize t ;; Resize windows proportionally
   history-delete-duplicates t
   auto-save-default nil
   make-backup-files nil
   auto-save-default nil
   savehist-save-minibuffer-history t
   indicate-buffer-boundaries 'left
   show-paren-style 'parenthesis  ;; Hightlights all the contents. It is somewhat usefull but sometimes ugly Maybe put an lisp hook?
   scroll-preserve-screen-position t
   scroll-conservatively 101
   make-pointer-invisible t
   history-delete-duplicates t
   large-file-warning-threshold (* 1024 1024)
   create-lockfiles nil
   history-length 25
   use-dialog-box nil
  )


(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring
        last-kbd-macro
        kmacro-ring
        shell-command-history))

(auto-save-visited-mode t)
(savehist-mode 1)
(electric-pair-mode 1)
(save-place-mode 1)
(recentf-mode 1)

(show-paren-mode t)
(global-hl-line-mode t)
(setq prettify-symbols-unprettify-at-point 'right-edge)
(global-prettify-symbols-mode)

(with-current-buffer "*scratch*"
  (emacs-lock-mode 'kill))

(customize-set-variable 'display-buffer-base-action
  '((display-buffer-reuse-window display-buffer-same-window)
    (reusable-frames . t)))

(customize-set-variable 'even-window-sizes nil)     ; avoid resizing

(setq inhibit-startup-message t)
(setq visible-bell t) ;; Set up the visible bell

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(menu-bar-mode -1)            ; Disable the menu bar

(set-fringe-mode 10)        ; Give some breathing room

(setq auto-save-default nil)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Set the lines
(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

; Disable line numbers for some modes
;(dolist (mode '(org-mode-hook
;                term-mode-hook
;                shell-mode-hook
;                treemacs-mode-hook
;                eshell-mode-hook))
;   (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq doom-modeline-modal-icon t)


;; (set-face-attribute 'variable-pitch nil :font "Cantarell" :height ava/default-variable-font-size :weight 'regular)

; START TABS CONFIG
;; Create a variable for our preferred tab width
(setq custom-tab-width 4)

;; Two callable functions for enabling/disabling tabs in Emacs
(defun disable-tabs () (setq indent-tabs-mode nil))
(defun enable-tabs  ()
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))

;; Hooks to Enable Tabs
(add-hook 'prog-mode-hook 'disable-tabs)
(add-hook 'mhtml-mode-hook 'disable-tabs)
;; Hooks to Disable Tabs
(add-hook 'lisp-mode-hook 'disable-tabs)
(add-hook 'emacs-lisp-mode-hook 'disable-tabs)

;; Language-Specific Tweaks
(setq-default python-indent-offset custom-tab-width) ;; Python
(setq-default js-indent-level custom-tab-width)      ;; Javascript

;; Making electric-indent behave sanely
(setq-default electric-indent-inhibit t)

;; Make the backspace properly erase the tab instead of
;; removing 1 space at a time.
(setq backward-delete-char-untabify-method 'hungry)

;; (OPTIONAL) Shift width for evil-mode users
;; For the vim-like motions of ">>" and "<<".
(setq-default evil-shift-width custom-tab-width)
;; WARNING: This will change your life
;; (OPTIONAL) Visualize tabs as a pipe character - "|"
;; This will also show trailing characters as they are useful to spot.
(setq whitespace-style '(face tabs tab-mark trailing))
(custom-set-faces
 '(whitespace-tab ((t (:foreground "#636363")))))
(setq whitespace-display-mappings
  '((tab-mark 9 [124 9] [92 9]))) ; 124 is the ascii ID for '\|'
(global-whitespace-mode) ; Enable whitespace mode everywhere
; END TABS CONFIG

(defun ava/configure-python()
    (setq fill-column 80)
    (display-fill-column-indicator-mode t)
)

;; Configure the django for specific projects
(defun ava/django-config()
    (when (string-match-p "zentrader" (file-name-directory (buffer-file-name)))
        (pyvenv-workon "zentrader")
        (pyvenv-mode t)
        (setq python-shell-process-environment '("DJANGO_SETTINGS_MODULE=zentrader.settings"))
        (setq python-shell-extra-pythonpaths '("/home/alexvanaxe/Documents/Development/zentrader/source/zentrader_api"))
        (djangonaut-mode t)
        (message "Django Configured.")))

(defun ava/configure-column()
    (setq fill-column 120)
    (display-fill-column-indicator-mode t)
)

;;Function to get a random value from the list passed
(defun random-choice (items)
(let* ((size (length items))
        (index (random size)))
    (nth index items)))

(defun ava/load-transparency()
(set-frame-parameter (selected-frame) 'alpha ava/transparency-level))

;; TODO Ver depois, nao funfa
(defun ava/change-transparency(changer)
        (setq ava/transparency-level (cons(+ changer (car ava/transparency-level)) (+ changer (car ava/transparency-level))))
        (ava/load-transparency)
        )

(defun ava/update-transparency()
    (when (string-equal (getenv "theme_name") "day")
        (setq ava/transparency-level '(85 . 85))
        (setq ava/transparency-level-list '(alpha . (85 . 85))))

    (when (string-equal (getenv "theme_name") "shabbat")
        (setq ava/transparency-level '(93 . 93))
        (setq ava/transparency-level-list '(alpha . (93 . 93))))

    (when (string-equal (getenv "theme_name") "night")
        (message "Night updating")
        (setq ava/transparency-level '(87 . 87))
        (setq ava/transparency-level-list '(alpha . (87 . 87)))))

    (defun get-theme()
    (when (string-equal (getenv "theme_name") "day")  (setq result (random-choice '(kaolin-valley-light))))
    (when (string-equal (getenv "theme_name") "shabbat")  (setq result (random-choice '(kaolin-breeze))))
    (when (string-equal (getenv "theme_name") "night") (setq result (random-choice '(doom-moonlight doom-material kaolin-galaxy))))
    result)

    (defun get-font()
    ;;(when (string-equal (getenv "theme_name") "day")  (setq result (random-choice '("Fantasque Sans Mono"
    ;;"Anonymous Pro" "Source Code Pro" "Space Mono"))))
    (when (string-equal (getenv "theme_name") "day")  (setq result (random-choice '("JetBrains Mono"))))
    (when (string-equal (getenv "theme_name") "shabbat")  (setq result (random-choice '("IntelOne Mono"))))
    (when (string-equal (getenv "theme_name") "night") (setq result (random-choice '("Iosevka Nerd Font Mono"))))
    result)

(defun toggle-transparency ()
    (interactive)
    (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
        nil 'alpha
        (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha))) 100)
            ava/transparency-level '(100 . 100)))))

(add-hook 'emacs-startup-hook #'ava/rice-the-emacs)

(use-package rainbow-delimiters
:hook (prog-mode . rainbow-delimiters-mode))

(use-package hydra
    :after general)

(use-package which-key
:defer 0
:diminish which-key-mode
:config (which-key-mode)
(setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("<f6>" . 'switch-to-buffer)
         :map minibuffer-local-map
         ("C-q" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy-rich
    :after ivy
    :init
    (ivy-rich-mode 1))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map ("C-c C-;" . flyspell-correct-wrapper)))

(use-package flyspell-correct-ivy
  :after flyspell-correct)

(use-package helpful
:commands (helpful-callable helpful-variable helpful-command helpful-key)
:custom
(counsel-describe-function-function #'helpful-callable)
(counsel-describe-variable-function #'helpful-variable)
:bind
([remap describe-function] . counsel-describe-function)
([remap describe-command] . helpful-command)
([remap describe-variable] . counsel-describe-variable)
([remap describe-key] . helpful-key))

(use-package windower
  :ensure t
  :config
  (add-to-list 'package-selected-packages 'windower))

(use-package perspective
  :bind
  (("<f9>" . persp-list-buffers)
   ("<f8>" . persp-switch)
   ("<f5>" . persp-ivy-switch-buffer))   ; or use a nicer switcher, see below
  :config
  (persp-mode))

(windmove-default-keybindings 'meta)

(use-package general
:after evil
:config
(general-define-key
  "M-h" 'windmove-left
  "M-l" 'windmove-right
  "M-k" 'windmove-down
  "M-j" 'windmove-up
 )

(general-create-definer ava/leader-keys
:keymaps '(normal emacs)
:prefix ava/leader-key)

(ava/leader-keys
    "t"  '(:ignore t :which-key "Tabs Handling")
    "tt" '(tab-new :which-key "New tab")
    "td" '(tab-close :which-key "Close the tab")
    "tc" '(tab-bar-mode :which-key "Hide the tab panel")
    "tn" '(tab-next :which-key "Go to the next tab")
    "tg" '(tab-bar-select-tab-by-name :which-key "Select the tab")
    "i1" '(lambda() (interactive)(find-file "~/.emacs.d/init.el")))
)

(use-package evil
:init
(setq evil-want-integration t)
(setq evil-want-keybinding nil)
(setq evil-want-C-u-scroll t)
(setq evil-want-C-i-jump nil)
:config
(evil-mode 1)
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
(define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
(define-key evil-normal-state-map (kbd (concat ava/leader-key " %")) 'evil-window-vsplit)
(define-key evil-normal-state-map (kbd (concat ava/leader-key " \"")) 'evil-window-split)
(define-key evil-normal-state-map (kbd (concat ava/leader-key " l")) 'evil-window-right)
(define-key evil-normal-state-map (kbd (concat ava/leader-key " h")) 'evil-window-left)
(define-key evil-normal-state-map (kbd (concat ava/leader-key " j")) 'evil-window-down)
(define-key evil-normal-state-map (kbd (concat ava/leader-key " k")) 'evil-window-up)
(define-key evil-insert-state-map (kbd "C-f") 'company-files)

;; Use visual line motions even outside of visual-line-mode buffers
;; (evil-global-set-key 'motion "j" 'evil-next-visual-line)
;; (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

(evil-set-initial-state 'messages-buffer-mode 'normal)
(evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
:after evil
:config
(evil-collection-init))

(use-package key-chord
  :init
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
  (key-chord-define evil-insert-state-map "jw" 'save-buffer)
  (key-chord-mode 1)
  :custom
  (key-chord-two-keys-delay 0.5)
)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("<f4>" . projectile-command-map))
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Documents/Projects/")
  (setq projectile-project-search-path '("~/Documents/Projects/")))
  (setq projectile-switch-project-action #'projectile-dired)

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

(use-package evil-surround
  :defer 0
  :config
  (global-evil-surround-mode 1))

(use-package emmet-mode
  :hook ((sgml-mode-hook . emmet-mode))
  (css-mode-hook . emmet-mode))

(use-package highlight-indent-guides
  :config
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-character ?┆)
  (setq highlight-indent-guides-auto-odd-face-perc 15)
  (setq highlight-indent-guides-auto-even-face-perc 15)
  (setq highlight-indent-guides-auto-character-face-perc 15)
  :hook (prog-mode . highlight-indent-guides-mode))

(use-package yasnippet
  :hook (lsp-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnipped)

(use-package minimap
  :defer 0)

(use-package magit
:commands magit-status)
;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started

;; (use-package forge
;;  :after magit)

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (sh-mode . lsp-deferred)
         (js-mode . lsp-deferred)
         (mhtml-mode . lsp-deferred)
         (html-mode . lsp-deferred)
         ;; if you want which-key integration
         )
  :commands lsp-deferred
  :config
  (add-to-list 'lsp-enabled-clients 'bash-ls)
  (add-to-list 'lsp-enabled-clients 'html-ls)
  (add-to-list 'lsp-enabled-clients 'angular-ls)
  (add-to-list 'lsp-enabled-clients 'ts-ls)
  (add-to-list 'lsp-enabled-clients 'pyright)
  (add-to-list 'lsp-enabled-clients 'svelte-ls)
  (lsp-enable-which-key-integration t))

(use-package lsp-pyright
:ensure t
:hook (python-mode . (lambda ()
                        (require 'lsp-pyright)
                        (lsp-deferred))))  ; or lsp-deferred


(use-package lsp-ivy
  :after lsp-mode
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-ui
  :after lsp-mode
  :config
  (setq lsp-ui-doc-position 'bottom))

(use-package web-mode
  :after lsp-mode
  :mode "\\.svelte\\'"
  :hook (web-mode . lsp-deferred)
  :commands lsp-ivy-workspace-symbol)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind ("C-c c" . company-complete)
  :config
  (setq company-idle-delay 0) ;; To disable set to nil
  )

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq lsp-diagnostic-package :none))

(use-package djangonaut
  :ensure t
  :defer t
  :init
  (add-hook 'python-mode-hook #'ava/django-config))

(use-package pyvenv
  :ensure t
  :init
  (setenv "WORKON_HOME" "~/.pyenv/versions"))

(use-package zoom-window
  :defer 0
  :custom
  (zoom-window-mode-line-color "black"))

(use-package typescript-mode
  :after lsp-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (with-eval-after-load "lsp-mode"
    (setq typescript-indent-level 2)
    (add-to-list 'lsp-enabled-clients 'ts-ls)
    ))

(use-package vue-mode
  :after lsp-mode
  :mode "\\.vue\\'"
  :hook (vue-mode . lsp-deferred)
  :config
  (with-eval-after-load "lsp-mode"
    (add-to-list 'lsp-enabled-clients 'vls)
    (add-to-list 'lsp-enabled-clients 'volar-api)
    (add-to-list 'lsp-enabled-clients 'volar-doc)
    (add-to-list 'lsp-enabled-clients 'volar-html)))

(use-package sass-mode
  :after typescript-mode)

(use-package vdiff
  :config
  (evil-define-key 'normal vdiff-mode-map ava/leader-key vdiff-mode-prefix-map))

(defun ava/configure-eshell ()
  ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

  ;; Truncate buffer for performance
  (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

  ;; Bind some useful keys for evil-mode
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
  (evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
  (evil-normalize-keymaps)

  (setq eshell-history-size         10000
        eshell-buffer-maximum-lines 10000
        eshell-hist-ignoredups t
        eshell-scroll-to-bottom-on-input t))

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :hook (eshell-first-time-mode . ava/configure-eshell)
  :config

  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim"))))

                                        ;(eshell-git-prompt-use-theme 'powerline))

;; Try to use the vterm
(use-package vterm
  :commands vterm
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  ;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-l --group-directories-first"))
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(setq dired-dwim-target t)

(use-package dired-single
  :commands (dired dired-jump))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(use-package doom-themes)
;; Removing theme for testing porposes
;;        :init (load-theme 'doom-city-lights t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom (
           (doom-modeline-height 0)
           (doom-modeline-bar-width 4)
           (doom-modeline-window-width-limit fill-column)
           ))

(use-package smart-mode-line
  :disabled
  :init (sml/setup)
  :custom
  (sml/theme 'respectful))

(use-package telephone-line
  :disabled
  :init (telephone-line-mode 1))

(use-package base16-theme
  :disabled
  :ensure t)

;; Or if you have use-package installed
(use-package kaolin-themes)

(use-package cyberpunk-theme)

(use-package hide-mode-line
  :ensure t)

(use-package visual-fill-column
  :hook ((typescript-mode . ava/configure-column)
         (python-mode . ava/configure-python)
         ))

(setq display-buffer-base-action
      '((display-buffer-reuse-window
         display-buffer-reuse-mode-window
         display-buffer-same-window
         display-buffer-in-previous-window)))

(with-eval-after-load 'general
  (defhydra window-resize (global-map "<F8>")
    "Resize the window"
    ("k" enlarge-window)
    ("j" shrink-window)
    ("l" enlarge-window-horizontally)
    ("h" shrink-window-horizontally)
    ("f" nil "finished" :exit t))
  (defhydra transparency-change (global-map "<F8>")
    "Transparency"
    ("u" (ava/change-transparency +2))
    ("d" (ava/change-transparency -2))
    ("f" nil "finished" :exit t))
  )

  (ava/leader-keys
    "c"  '(:ignore c :which-key "Some cool stuffs")
    "o"  '(:ignore o :which-key "Org shortcuts")
    "cp"  '(:ignore c :which-key "Lounge center.")
    "a" '(org-agenda :which-key "Open the agenda")
    "y" '((lambda () (interactive) (change-theme)) :which-key "Yay! Change the theme")
    "Y" '((lambda () (interactive) (reload-theme)) :which-key "Yay! Change the theme")
    "r" '(window-resize/body :which-key "Resize the window")
    "T" '(transparency-change/body :which-key "Change transparency")
    "b" '(toggle-transparency :which-key "Toggle transparency")
    "v" '(hide-mode-line-mode :which-key "Hides the modebar to get more room.")
    "ci" '((lambda () (interactive) (change-light)) :which-key "Screens light")
    "cpr" '((lambda () (interactive) (play_radio)) :which-key "The old radio")
    "cpn" '((lambda () (interactive) (play_paste)) :which-key "Play clipboard")
    "cpa" '((lambda () (interactive) (play_paste_audio)) :which-key "Play clipboard as audio")
    "cpp" '((lambda () (interactive) (player-ctl "play_pause")) :which-key "Play/Pause player")
    "cps" '((lambda () (interactive) (player-ctl "stop")) :which-key "Stop player")
    "cpS" '((lambda () (interactive) (player-ctl "save")) :which-key "Save the play for later")
    ;; Esse o emacs nao consegue rodar. Muita pressao pra ele
    "cpA" '((lambda () (interactive) (player-ctl "asaudio")) :which-key "Invert audio/video")
    "z" '(zoom-window-zoom :which-key "Tmux zoom like")
    "n" '(zoom-window-next :which-key "Next zoom window")
    ;; Org keymaps
    "oci" '(org-clock-in :which-key "Start the clock in current task")
    "oco" '(org-clock-out :which-key "Stop the clock in current task")
    "occ" '(org-clock-cancel :which-key "Cancel the timer")
    "ocg" '(org-clock-goto :which-key "Go to the clock entry or last one")
    "otb" '((lambda() (interactive) (org-timer-set-timer 25)) :which-key "Start a pomodoro")
    "ots" '(org-timer-stop :which-key "Stop a timer")
    ;; Move windows arround
    "H" '(windower-swap-left :which-key "Swap left")
    "J" '(windower-swap-bellow :which-key "Swap bellow")
    "K" '(windower-swap-above :which-key "Swap above")
    "L" '(windower-swap-right :which-key "Swap right")
    ;; Perspective (Others are set on the plugin config)
    ">" '(persp-next :which-key "Move to the next perspective")
    "<" '(persp-prev :which-key "Move to the prev perspective")
    "s" '(persp-switch-to-scratch-buffer :which-key "Switch to the buffer")
    "f" '(persp-forget-buffer :which-key "Forget the buffer of the persp")
    "A" '(persp-set-buffer :which-key "Set the buffer to this persp and remove from the other")
    )

(defun ava/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name)) user-emacs-configs-directory)
    (org-babel-tangle)
    (message "tangled")))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'ava/org-babel-tangle-config)))
