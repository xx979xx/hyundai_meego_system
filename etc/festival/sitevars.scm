;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Site specific variable settings for Festival
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The system-voice-path is an additional path in which to look
;; for voices. If you install voices not provided in the form of
;; rpm package, you should then set this to match. The default
;; provided here, "/usr/local/share/festival/lib/voices/", is
;; probably a good choice. You could also set this in
;; ~/.festivalvarsrc, if you want to use a voice not provided to
;; the system as a whole.

(set! system-voice-path '("/usr/local/share/festival/lib/voices/"))
(set! system-voice-path-multisyn
               '("/usr/local/share/festival/lib/voices-multisyn/"))



(provide 'sitevars)
