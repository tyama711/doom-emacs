;;; config/default/autoload/search.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +default/search-cwd (&optional arg)
  "Conduct a text search in files under the current folder.
If prefix ARG is set, prompt for a directory to search from."
  (interactive "P")
  (let ((default-directory
          (if arg
              (read-directory-name "Search directory: ")
            default-directory)))
    (call-interactively
     (cond ((featurep! :completion ivy)  #'+ivy/project-search-from-cwd)
           ((featurep! :completion helm) #'+helm/project-search-from-cwd)
           (#'rgrep)))))

;;;###autoload
(defun +default/search-other-cwd ()
  "Conduct a text search in another directory."
  (interactive)
  (+default/search-cwd 'other))

;;;###autoload
(defun +default/search-project (&optional arg)
  "Conduct a text search in the current project root.
If prefix ARG is set, prompt for a known project to search from."
  (interactive "P")
  (let* ((disabled-command-function nil)
         (default-directory
           (if arg
               (if-let (projects (projectile-relevant-known-projects))
                   (completing-read "Search project: " projects
                                    nil t nil nil (doom-project-root))
                 (user-error "There are no known projects"))
             default-directory)))
    (call-interactively
     (cond ((featurep! :completion ivy)  #'+ivy/project-search)
           ((featurep! :completion helm) #'+helm/project-search)
           (#'projectile-ripgrep)))))

;;;###autoload
(defun +default/search-other-project ()
  "Conduct a text search in a known project."
  (interactive)
  (+default/search-project 'other))

;;;###autoload
(defun +default/search-project-for-symbol-at-point (&optional symbol arg)
  "Search current project for symbol at point.
If prefix ARG is set, prompt for a known project to search from."
  (interactive
   (list (rxt-quote-pcre (or (doom-thing-at-point-or-region) ""))
         current-prefix-arg))
  (let ((default-directory
          (if arg
              (if-let (projects (projectile-relevant-known-projects))
                  (completing-read "Switch to project: " projects
                                   nil t nil nil (doom-project-root))
                (user-error "There are no known projects"))
            default-directory)))
    (cond ((featurep! :completion ivy)
           (+ivy/project-search nil symbol))
          ((featurep! :completion helm)
           (+helm/project-search nil symbol))
          ((rgrep (regexp-quote symbol))))))

;;;###autoload
(defun +default/search-notes-for-symbol-at-point (&optional symbol)
  "Conduct a text search in the current project for symbol at point. If prefix
ARG is set, prompt for a known project to search from."
  (interactive
   (list (rxt-quote-pcre (or (doom-thing-at-point-or-region) ""))))
  (require 'org)
  (let ((default-directory org-directory))
    (+default/search-project-for-symbol-at-point
     nil symbol)))

;;;###autoload
(defun +default/org-notes-search ()
  "Perform a text search on `org-directory'."
  (interactive)
  (require 'org)
  (let ((default-directory org-directory))
    (+default/search-project-for-symbol-at-point "")))

;;;###autoload
(defun +default/org-notes-headlines ()
  "Jump to an Org headline in `org-agenda-files'."
  (interactive)
  (doom-completing-read-org-headings
   "Jump to org headline: " org-agenda-files 3 t))
