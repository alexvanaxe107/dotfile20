(server-start)
(defun ava/run-in-background (command)
(let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun ava/exwm-rename-buffer ()
  (interactive)
  (exwm-workspace-rename-buffer
   (concat exwm-class-name ":"
           (if (<= (length exwm-title) 50) exwm-title
             (concat (substring exwm-title 0 49) "...")))))

;; Put here the inital programs to run
(defun ava/exwm-init-hook ()
  ;; (start-process-shell-command "set_wallpaper" nil "wallpaper_changer.sh")
  ;; (start-process-shell-command "set_theme" nil "theme_select.sh -emacs")
  (ava/run-in-background "nitrogen --restore")
  (with-eval-after-load 'doom-themes (load-theme (get-theme) t))
  )

(defun ava/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun ava/exwm-update-title ()
  (pcase exwm-class-name
    ("Firefox" (exwm-workspace-rename-buffer (format "Firefox: %s" exwm-title)))))

;; (defun ava/configure-window-by-class ()
;;   (interactive)
;;   (pcase exwm-class-name
;;     ("Firefox" (exwm-workspace-move-window 2))
;;     ("Sol" (exwm-workspace-move-window 3))
;;     ("mpv" (exwm-floating-toggle-floating)
;;      (exwm-layout-toggle-mode-line))))

(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 10)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
        '(?\C-x
          ?\M-x
          ?\s-d
          f5
          ))  ;; Ctrl+Space


  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'ava/exwm-update-class)

  ;; When window title updates, use it to set the buffer name
  ;; (add-hook 'exwm-update-title-hook #'ava/exwm-update-title)

  ;; Add these hooks in a suitable place (e.g., as done in exwm-config-default)
  (add-hook 'exwm-update-class-hook 'ava/exwm-rename-buffer)
  (add-hook 'exwm-update-title-hook 'ava/exwm-rename-buffer)

  ;; Configure windows as they're created
  ;; (add-hook 'exwm-manage-finish-hook #'ava/configure-window-by-class)


  ;; When EXWM starts up, do some extra confifuration
  (add-hook 'exwm-init-hook #'ava/exwm-init-hook)

  (require 'exwm-randr)
  (exwm-randr-enable)
  ;; Configure the kmap and change caps for control
  (start-process-shell-command "kmap" nil "setkmap")

  ;; Turnoff the sleep timer of the monitor
  (start-process-shell-command "nosleep" nil "saver.sh &")
  ;; Give three monitors to the second screen. It can be changed on time.
  (setq exwm-randr-workspace-output-plist '(0 "eDP1" 9 "eDP1" 8 "eDP1"))

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  (setq exwm-input-global-keys
        `(
          ([?\s-r] . exwm-reset)
          ([?\s-d] . counsel-linux-app)

          ;; Launch applications via shell command
          ([?\s-$] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Move Window keys
          ([?\s-h] . windmove-left)
          ([?\s-l] . windmove-right)
          ([?\s-k] . windmove-up)
          ([?\s-j] . windmove-down)
          ;; Movement keys
          ([?\s-H] . windower-swap-left)
          ([?\s-L] . windower-swap-right)
          ([?\s-K] . windower-swap-above)
          ([?\s-J] . windower-swap-below)

          ([?\s-%] . evil-window-vsplit)
          ([?\s-\"] . evil-window-split)
          ([?\s-Q] . kill-buffer)
          ([?\s-q] . evil-quit)
          ([?\s-i] . exwm-input-toggle-keyboard)
          ;; ([?\s-v] . exwm-workspace-delete)
          ([?\s-v] . hide-mode-line-mode)
          ([?\s-a] . exwm-workspace-add)
          ([?\s-w] . exwm-workspace-switch)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))
  (exwm-enable)

  )

(use-package desktop-environment
  :after exwm
  :config
  (progn
  (unbind-key "s-l" desktop-environment-mode-map)
  (bind-key "s-x" 'desktop-environment-lock-screen)
  (desktop-environment-mode))
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-")
  (exwm-input--update-global-prefix-keys)
  )
