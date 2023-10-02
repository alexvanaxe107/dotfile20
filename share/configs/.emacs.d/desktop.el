(defun ava/run-in-background (command)
(let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun ava/inc-volume()
  (shell-command "pulseaudio-ctl up 2"))

(defun ava/dec-volume()
  (shell-command "pulseaudio-ctl down 2"))

(defun ava/mute-volume()
  (shell-command "pulseaudio-ctl mute"))

(defun change-theme()
  "First disable all themes and then chose a theme and font"
  (shell-command "nitrogen --restore")
  ;;(shell-command "picom")
  (ava/update-transparency)
  (disable-all-themes)
  (load-theme (get-theme) t)
  (set-frame-parameter (selected-frame) 'alpha-background ava/transparency-level)
  (add-to-list 'default-frame-alist ava/transparency-level-list)
  (set-face-attribute 'default nil :font (get-font) :height ava/default-font-size))

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
  (shell-command "start_picom.sh emacs")
  (shell-command "dunstctl set-paused true")
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


    ;; Total focus
;;    (setq exwm-workspace-minibuffer-position 'bottom)

    ;; Char mode by default
    (setq exwm-manage-configurations '((t char-mode t)))
    ;; These keys should always pass through to Emacs
    (setq exwm-input-prefix-keys
          '(?\C-x
            ?\M-x
            ?\s-d
            f5
            ))


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
    ;;(start-process-shell-command "kmap" nil "setkmap")

    ;; Turnoff the sleep timer of the monitor
    ;;(start-process-shell-command "nosleep" nil "saver.sh &")

    ;; Get the first monitor
    ;;(let (
    ;;      (monitor (shell-command-to-string "monitors_info.sh -m | head -n 1")))

    ;;  (setq exwm-randr-workspace-output-plist (list 0 monitor 1 monitor 2 monitor))

    ;;  )

    ;; Get the second monitor
    (let (
          (monitor (shell-command-to-string "monitors_info.sh -m | tail -n 1")))

      (setq exwm-randr-workspace-output-plist (list 8 monitor 9 monitor))

      )

    ;; Give three monitors to the second screen. It can be changed on time.

    ;; Ctrl+Q will enable the next key to be sent directly
    (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)
    (setq exwm-workspace-show-all-buffers t)
    (setq exwm-layout-show-all-buffers t)

    ;; Set up global key bindings.  These always work, no matter the input state!
    (setq exwm-input-global-keys
          `(
            ([f5] . persp-ivy-switch-buffer)
            ([f9] . persp-list-buffers)
            ([f8] . persp-switch)
            ([?\s-f] . persp-forget-buffer)
            ([?\s-R] . exwm-reset)
            ;;([?\s-d] . counsel-linux-app)
            ([?\s-d] . (lambda ()
                      (interactive)
                      (start-process "" nil "wezterm")))

            ([?\s-r] . window-resize/body)
            ;; Launch applications via shell command
            ([?\s-$] . (lambda (command)
                         (interactive (list (read-shell-command "$ ")))
                         (start-process-shell-command command nil command)))

            ;; Move Window keys
            ([?\s-h] . windmove-left)
            ([?\s-l] . windmove-right)
            ([?\s-k] . windmove-up)
            ([?\s-j] . windmove-down)

            ([XF86AudioMute] . (lambda () (interactive)(ava/mute-volume)))
            ([XF86AudioRaiseVolume] . (lambda () (interactive)(ava/inc-volume)))
            ([XF86AudioLowerVolume] . (lambda () (interactive)(ava/dec-volume)))

            ;; Movement keys
            ([?\s-H] . windower-swap-left)
            ([?\s-L] . windower-swap-right)
            ([?\s-K] . windower-swap-above)
            ([?\s-J] . windower-swap-below)
            ([?\s-t] . (lambda () (interactive) (exwm-workspace-switch (car (delete exwm-workspace--current (seq-filter #'exwm-workspace--active-p exwm-workspace--list))))))


            ([?\s-%] . split-window-right)
            ([?\s-e] . split-window-right)
            ([?\s-\"] . split-window-below)
            ([?\s-b] . split-window-below)
            ([?\s-Q] . kill-buffer)
            ([?\s-q] . delete-window)
            ([?\s-i] . exwm-input-toggle-keyboard)
            ;; ([?\s-v] . exwm-workspace-delete)
            ([?\s-v] . hide-mode-line-mode)
            ([?\s-A] . exwm-workspace-add)
            ([?\s-a] . (lambda () (interactive)(change_sink)))
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
  :disabled
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
