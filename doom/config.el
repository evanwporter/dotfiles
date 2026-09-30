;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
(add-to-list 'custom-theme-load-path
             (expand-file-name "straight/repos/doom-gruvbox-material-theme/"
                               doom-local-dir))
(setq doom-gruvbox-material-background "medium"
      doom-gruvbox-material-palette "material"
      doom-theme 'doom-gruvbox-material)

;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Quit immediately, and restore the latest session without asking first.
(setq confirm-kill-emacs nil)
(defun my/doom-quickload-session-without-confirmation (fn &rest _args)
  "Restore Doom's latest session without a confirmation prompt."
  (funcall fn t))
(advice-add #'doom/quickload-session :around
            #'my/doom-quickload-session-without-confirmation)

;; The :lang cc +lsp module starts Eglot automatically for C-family buffers.
;; Use clangd explicitly, including project-wide background indexing.
(with-eval-after-load 'cc-mode
  (set-eglot-client! 'cc-mode '("clangd" "--background-index")))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Format Emacs Lisp automatically when saving.
(use-package! elisp-autofmt
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :hook (emacs-lisp-mode . elisp-autofmt-mode)
  :config
  (setq elisp-autofmt-on-save-p 'always))

;; flash.nvim-style navigation.  RET starts a jump in Normal state; `gs'
;; remains available as an operator-pending Evil motion (e.g. `dgs').
(use-package! flash
  :commands (flash-jump)
  :init
  (with-eval-after-load 'evil
    (require 'flash-evil)
    (flash-evil-setup t)))

(map! :after evil
      :n "<return>" #'flash-jump)


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Use bash internally to prevent Fish shell issues
(setq shell-file-name (executable-find "bash"))

;; Keep Fish as your interactive terminal emulator inside Emacs
(setq-default vterm-shell "/run/current-system/sw/bin/fish")
(setq-default explicit-shell-file-name "/run/current-system/sw/bin/fish")

;; Toggle a project terminal from the leader key.
(map! :leader
      "/" #'+vterm/toggle)

;; `C-/` is commonly reported as `C-_` in terminal Emacs.
(map! :g "C-/" #'+vterm/toggle
      :g "C-_" #'+vterm/toggle)

;; Use Dirvish for Dired buffers and open it from the file-explorer leader key.
(use-package! dirvish
  :after dired
  :config
  (setq dirvish-attributes
        '(vc-state subtree-state nerd-icons collapse git-msg file-time file-size))
  (dirvish-override-dired-mode))

(map! :leader
      :desc "Dirvish"
      "e" #'dirvish)

; Source - https://stackoverflow.com/a/62824543
; Posted by fossegrim
; Retrieved 2026-09-26, License - CC BY-SA 4.0

(setq display-line-numbers-type 'relative)
