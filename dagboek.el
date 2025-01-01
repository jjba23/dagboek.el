;;; dagboek.el --- effectively manage and create diary/journal entries -*- lexical-binding: t -*-

;; Copyright (C) 2024 Free Software Foundation, Inc.

;; Version: 0.1.2
;; Author: Josep Bigorra <jjbigorra@gmail.com>
;; Maintainer: Josep Bigorra <jjbigorra@gmail.com>
;; URL: https://codeberg.org/jjba23/dagboek.el
;; Keywords: diary, journal, dagboek, org
;; Package: dagboek
;; Package-Requires: ((emacs "24.1"))

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; dagboek/ means diary in the Dutch language.

;; dagboek.el is an Emacs package that allows you to effectively and simply manage and create diary/journal entries.

;;; Code:

(defgroup dagboek ()
  "Dagboek customization group."
  :group 'tools)

(defcustom dagboek-entry-format "%e"
  "Date-time format to be used for dagboek entry files."
  :type 'string
  :group 'dagboek)

(defcustom dagboek-entry-destination "%Y/%m"
  "Date-time format to be used for dagboek entry files."
  :type 'string
  :group 'dagboek)

(defcustom dagboek-detailed-ts-format "%e/%m/%Y"
  "Date-time format to be used inside dagboek entry files."
  :type 'string
  :group 'dagboek)

(defcustom dagboek-entry-location "~/Ontwikkeling/Persoonlijk/private-notes/Dagboek"
  "Location for dagboek entry files."
  :type 'string
  :group 'dagboek)

(defcustom dagboek-questions-template "
** How was your day today ?

/describe day and/or momentary feelings/

** What inspired, affected or upset you ?

/things that inspired you today/

** Events, feelings, plans

/discuss events/feelings/future plans/

** Conclusions and goals

/conclude with final remark/plans/future course of action/"
  "Template to be used for new dagboek entries."
  :type 'string
  :group 'dagboek)

(defun current-time-days+ (days)
  (let ((now (current-time)))
    (list (car now)
          (+ (cadr now) (* days 86400))
          (caddr now)
          (cadddr now))))

(defun current-time-days- (days)
  (let ((now (current-time)))
    (list (car now)
          (- (cadr now) (* days 86400))
          (caddr now)
          (cadddr now))))

(defun dagboek-find-entry (time)
  "Find a certain dagboek entry."
  (let ((entry-dir (string-join
                    (list dagboek-entry-location
                          "/"
                          (format-time-string dagboek-entry-destination time))))
        (entry-file (string-join
                     (list dagboek-entry-location
                           (string-join (list (format-time-string dagboek-entry-destination time)
                                              "/"
                                              (format-time-string dagboek-entry-format time) ".org")))
                     "/")))
    (if (file-exists-p entry-file)
        (progn
          (message "opening today's dagboek entry...")
          (find-file entry-file))
      (progn
        (message "creating today's dagboek entry...")
        (make-directory entry-dir t)
        (find-file entry-file)
        (with-current-buffer (string-trim (string-join (list (format-time-string dagboek-entry-format time) ".org") ))
          (progn
            (insert "#+title: ")
            (insert (format-time-string  dagboek-detailed-ts-format time))
            (insert "\n")
            (insert dagboek-questions-template)
            (org-mode)
            ))))))

(defun dagboek-today-entry ()
  "Find today's dagboek entry."
  (interactive)
  (dagboek-find-entry (current-time))
  )

(defun dagboek-yesterday-entry ()
  "Find yesterday's dagboek entry."
  (interactive)
  (dagboek-find-entry (current-time-days- 1))
  )

(defun dagboek-day-before-yesterday-entry ()
  "Find day before yesterday's dagboek entry."
  (interactive)
  (dagboek-find-entry (current-time-days- 2))
  )

(defun dagboek-tomorrow-entry ()
  "Find tomorrow's dagboek entry."
  (interactive)
  (dagboek-find-entry (current-time-days+ 1))
  )

;;; dagboek.el ends here

