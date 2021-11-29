(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(setq extra-config-file "~/.emacs.d/extra.el")
(load extra-config-file)
(put 'dired-find-alternate-file 'disabled nil)
