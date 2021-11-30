(defvar ava/default-font-size 105)
(defvar ava/default-variable-font-size 105)

(defun ava/rice-the-emacs ()
    (load-theme (get-theme) t)
    (set-face-attribute 'default nil :font (get-font) :height ava/default-font-size)
)
