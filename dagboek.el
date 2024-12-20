;;; dagboek.el --- effectively manage and create diary/journal entries -*- lexical-binding: t -*-

;; Copyright (C) 2024 Free Software Foundation, Inc.

;; Version: 0.1.1
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

(defcustom dagboek-entry-format "%d"
  "Date-time format to be used for dagboek entry files."
  :type 'string
  :group 'dagboek)

(defcustom dagboek-entry-destination "%Y/%m"
  "Date-time format to be used for dagboek entry files."
  :type 'string
  :group 'dagboek)

(defcustom dagboek-entry-location "~/Ontwikkeling/Persoonlijk/private-notes/Dagboek"
  "Location for dagboek entry files."
  :type 'string
  :group 'dagboek)

(defcustom dagboek-questions-template "
describe day and/or momentary feelings
discuss events/feelings/future plans
conclude with final remark/plans/future course of action
goals
things that inspired you today
  "
  "Template to be used for new dagboek entries."
  :type 'string
  :group 'dagboek)

(defun dagboek-today-entry ()
  "Find today's dagboek entry."
  (interactive)
  (let ((dagboek-today-dir (string-join
                            (list dagboek-entry-location
                                  "/"
                                  (format-time-string dagboek-entry-destination))))
        (dagboek-today-file (string-join
                             (list dagboek-entry-location
                                   (string-join (list (format-time-string dagboek-entry-destination)
                                                      "/"
                                                      (format-time-string dagboek-entry-format) ".org")))
                             "/")))
    (make-directory dagboek-today-dir t)
    (if (file-exists-p dagboek-today-file)
        (progn
          (message "opening today's dagboek entry...")
          (find-file dagboek-today-file))
      (progn
        (message "creating today's dagboek entry...")
        (find-file dagboek-today-file)
        (with-current-buffer dagboek-today-file
          (progn
            (insert (org-timestamp))
            (insert "\n")
            (insert dagboek-questions-template)
            ))))
    ))

;;; dagboek.el ends here

