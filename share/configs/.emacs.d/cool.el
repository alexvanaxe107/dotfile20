(defun choose-player()
  (let (
  (players (split-string (shell-command-to-string "player_ctl.sh -v") "\n")))
      (completing-read "Chose: " players)))

(defun play_radio()
      (let (
      (output (split-string (shell-command-to-string "play_radio.sh -l") "\n")))
    (let (
      (choosen_radio (completing-read "Choose an station to listen, and enjoy some good music." output)))

        (save-match-data ; is usually a good idea
            (and (string-match "[[:space:]]*\\([0-9]*\\).*" choosen_radio)
                (setq indice (match-string 1 choosen_radio)
                      ) ))
        (shell-command (concat "play_radio.sh -r " indice " &") nil)
        )))

(defun play_paste()
   (shell-command "play_radio.sh -P" nil)
 )

(defun play_paste_audio()
   (shell-command "play_radio.sh -sP" nil)
 )

(defun player-ctl (action)
    (when (equal action "save")
        (shell-command (concat "player_ctl.sh -S " "'" (choose-player) "'") nil))

    (when (equal action "play_pause")
    (let (
	(players (split-string (shell-command-to-string "player_ctl.sh -v") "\n")))
    (let (
	    (chosen_player (completing-read "Chose: " players)))
	    (shell-command (concat "player_ctl.sh -p " "'" chosen_player "'")) )))

    (when (equal action "stop")
    (let (
	(players (split-string (shell-command-to-string "player_ctl.sh -v") "\n")))
    (let (
	    (chosen_player (completing-read "Chose: " players)))
	    (shell-command (concat "player_ctl.sh -s " "'" chosen_player "'")) )))
    (when (equal action "asaudio")
    (let (
	(players (split-string (shell-command-to-string "player_ctl.sh -v") "\n")))
    (let (
	    (chosen_player (completing-read "Chose: " players)))
	    (shell-command (concat "player_ctl.sh -i 1 " chosen_player)) )))
    )

(defun change-light ()
(let (
        (light-str (completing-read "Light Number (0-100): " '())))
    (shell-command (concat "avalight.sh -I " light-str))))

(defun disable-all-themes()
  "Disable all active themes"
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))

(defun reload-theme()
  (dolist (theme custom-enabled-themes)
    (load-theme theme)))

(defun change-theme()
  "First disable all themes and then chose a theme and font"
  (disable-all-themes)
  (load-theme (get-theme) t)
  (ava/update-transparency)
  (set-face-attribute 'default nil :font (get-font) :height ava/default-font-size))
