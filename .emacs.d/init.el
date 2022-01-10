(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(setq extra-config-file "~/.emacs.d/extra.el")
(load extra-config-file)
(setq orgs-config-file "~/.emacs.d/orgs.el")
(load orgs-config-file)
(put 'dired-find-alternate-file 'disabled nil)
