;; You will most likely need to adjust this font size for your system!
(defvar ava/default-font-size 105)
(defvar ava/default-variable-font-size 105)

(defvar ava/transparency-level '(93 . 93))
(defvar ava/transparency-level-list '(alpha . (93 . 93)))

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

(defun ava/configure-python()
      (setq fill-column 80)
      (display-fill-column-indicator-mode t) 
  )

  (defun ava/configure-column()
      (setq fill-column 120)
      (display-fill-column-indicator-mode t) 
  )

  ;; Configure the django for specific projects
  (defun ava/django-config()
      (when (string-match-p "money_watch" (file-name-directory (buffer-file-name)))
          (pyvenv-workon "money")
          (pyvenv-mode t)
          (setq python-shell-process-environment '("DJANGO_SETTINGS_MODULE=money_watch.settings"))
          (setq python-shell-extra-pythonpaths '("/home/alexvanaxe/Documents/Projects/MoneyWatch/coding-steps/MoneyWatch-api/money_watch"))
          (djangonaut-mode t)
          (message "Django Configured.")))

;;Function to get a random value from the list passed 
  (defun random-choice (items)
  (let* ((size (length items))
          (index (random size)))
      (nth index items)))

  (defun get-theme()
  (when (string-equal (getenv "theme_name") "day")  (setq result (random-choice '(doom-gruvbox-light doom-one-light
                  spacemacs-light kaolin-breeze kaolin-valley-light doom-nord-light))))
  (when (string-equal (getenv "theme_name") "shabbat")  (setq result (random-choice '(spacemacs-light kaolin-breeze kaolin-valley-light))))
  (when (string-equal (getenv "theme_name") "night") (setq result (random-choice '(doom-gruvbox doom-one doom-city-lights
                  kaolin-aurora kaolin-eclipse kaolin-valley-dark doom-moonlight doom-city-lights doom-material
                  doom-dracula doom-palenight))))
  result)

  (defun get-font()
   ;;(when (string-equal (getenv "theme_name") "day")  (setq result (random-choice '("Fantasque Sans Mono"
    ;;"Anonymous Pro" "Source Code Pro" "Space Mono"))))
   (when (string-equal (getenv "theme_name") "day")  (setq result (random-choice '("Fantasque Sans Mono"))))
   (when (string-equal (getenv "theme_name") "shabbat")  (setq result (random-choice '("Space Mono"))))
  (when (string-equal (getenv "theme_name") "night") (setq result (random-choice '("Envy Code R" "Iosevka" "Monoid"))))
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

;;(set-frame-parameter (selected-frame) 'alpha '(<active> . <inactive>))
;;(set-frame-parameter (selected-frame) 'alpha <both>)
(set-frame-parameter (selected-frame) 'alpha ava/transparency-level)
(add-to-list 'default-frame-alist ava/transparency-level-list)

(add-hook 'emacs-startup-hook #'ava/rice-the-emacs)

(use-package command-log-mode
  :disabled)

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
:bind (("<f5>" . 'counsel-switch-buffer)
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
              ;; if you want which-key integration
              )
      :commands lsp-deferred
      :config
          (add-to-list 'lsp-enabled-clients 'bash-ls)
          (lsp-enable-which-key-integration t))

      (use-package lsp-jedi
      :after lsp-mode
      :ensure t
      :config
      (with-eval-after-load "lsp-mode"
          (add-to-list 'lsp-disabled-clients 'pyls)
          (add-to-list 'lsp-enabled-clients 'jedi)))

      (use-package lsp-ivy 
          :after lsp-mode
          :commands lsp-ivy-workspace-symbol)

;;      (use-package lsp-ui
;;          :after lsp-mode
;;          :config
;;          (setq lsp-ui-doc-position 'bottom))

(use-package company
      :after lsp-mode
      :hook (lsp-mode . company-mode)
      :bind ("C-c c" . company-complete)
      :config
      (setq company-idle-delay nil)
      )

(use-package org
:pin org
:commands (org-capture org-agenda)
:hook (org-mode . ava/org-mode-setup)
:config
(setq org-ellipsis " ▾")

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)

(setq org-agenda-files
        '("~/Documents/Projects/orgs/rice.org"))

(use-package org-bullets
:hook (org-mode . org-bullets-mode)
:custom
(org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))))

(use-package visual-fill-column
    :init 
          (add-hook 'org-mode-hook #'ava/org-mode-visual-fill)
          (add-hook 'dired-mode-hook #'ava/dired-mode-visual-fill))


      ;; (use-package company-box
      ;;   :hook (company-mode . company-mode-box)
      ;;   )


      ;; Ensure that anything that should be fixed-pitch in Org files appears that way
      ;; (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
      ;; (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
      ;; (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)

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

(use-package org-roam
:ensure t
:init
(setq org-roam-v2-ack t)
:custom
(org-roam-directory "~/Documents/orgs")
(org-roam-completion-everywhere t)
:bind (("C-c n l" . org-roam-buffer-toggle)
       ("C-c n f" . org-roam-node-find)
       ("C-c n i" . org-roam-node-insert)
       :map org-mode-map
       ("C-M-i" . completion-at-point))
:config
(org-roam-setup))

(use-package typescript-mode
    :after lsp-mode
    :mode "\\.ts\\'"
    :hook (typescript-mode . lsp-deferred)
    :config
  (with-eval-after-load "lsp-mode"
    (setq typescript-indent-level 2)
    (add-to-list 'lsp-enabled-clients 'ts-ls)
))

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

;; Or if you have use-package installed
(use-package kaolin-themes)

(use-package cyberpunk-theme)

(use-package org-present
   :after org
   :init
    (defun ava/present-mode-enter()
                        (org-present-big)
                        (org-display-inline-images)
                        (org-present-hide-cursor)
                        (org-present-read-only))

    (defun ava/present-mode-quit()
                        (org-present-small)
                        (org-remove-inline-images)
                        (org-present-show-cursor)
                        (org-present-read-write))
    (add-hook 'org-present-mode-hook #'ava/present-mode-enter)
    (add-hook 'org-present-mode-quit-hook #'ava/present-mode-quit))

(use-package visual-fill-column 
    :hook ((typescript-mode . ava/configure-column)
           (python-mode . ava/configure-python)
           ))

(defun ava/org-mode-setup ()
(org-indent-mode)
(visual-line-mode 1))

(defun ava/org-mode-visual-fill ()
(setq visual-fill-column-width 150
  visual-fill-column-center-text t)
(visual-fill-column-mode 1))

(defun ava/dired-mode-visual-fill ()
(setq visual-fill-column-width 080)
(visual-fill-column-mode 1))

(with-eval-after-load 'org
;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("json" . "src js")))

(with-eval-after-load 'org-faces
    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :weight 'regular :height (cdr face))))
    ;; (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face))))
(setq org-confirm-babel-evaluate nil)

(with-eval-after-load 'org
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      (python . t)
      (js . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes))



;;(setq display-buffer-base-action
;;      '((display-buffer-reuse-window
;;	 display-buffer-reuse-mode-window
;;	 display-buffer-same-window
;;	 display-buffer-in-previous-window)))

(with-eval-after-load 'general
  (defhydra window-resize (global-map "<F8>")
  "Resize the window"
  ("k" enlarge-window)
  ("j" shrink-window)
  ("l" enlarge-window-horizontally)
  ("h" shrink-window-horizontally)
  ("f" nil "finished" :exit t))

  (ava/leader-keys
      "c"  '(:ignore c :which-key "Some cool stuffs")
      "cp"  '(:ignore c :which-key "Lounge center.")
      "y" '((lambda () (interactive) (change-theme)) :which-key "Yay! Change the theme")
      "r" '(window-resize/body :which-key "Resize the window")
      "b" '(toggle-transparency :which-key "Toggle transparency")
      "ci" '((lambda () (interactive) (change-light)) :which-key "Screens light")
      "cpr" '((lambda () (interactive) (play_radio)) :which-key "The old radio")
      "cpn" '((lambda () (interactive) (play_paste)) :which-key "Play clipboard")
      "cpa" '((lambda () (interactive) (play_paste_audio)) :which-key "Play clipboard as audio")
      "cpp" '((lambda () (interactive) (player-ctl "play_pause")) :which-key "Play/Pause player")
      "cps" '((lambda () (interactive) (player-ctl "stop")) :which-key "Stop player")
      ;; Esse o emacs nao consegue rodar. Muita pressao pra ele
      "cpA" '((lambda () (interactive) (player-ctl "asaudio")) :which-key "Invert audio/video")
      "z" '(zoom-window-zoom :which-key "Tmux zoom like")
      "n" '(zoom-window-next :which-key "Next zoom window")
      ))

(defun ava/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name)) user-emacs-configs-directory)
      (org-babel-tangle)
      (message "tangled")))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'ava/org-babel-tangle-config)))
