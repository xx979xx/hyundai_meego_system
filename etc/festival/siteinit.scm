;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Site specific initialization file for Festival
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Note that many configuration settings are better made in
;; individual ~/.festivalrc files. For example, if you want to
;; enable ESD audio and do it here, it'll break screen reading
;; on the login screen. Instead, put the (uncommented) line
;(Parameter.def 'Audio_Method 'esdaudio)
;; in your individual initialization file.

;; You can change the default voice with something like:
;(set! voice_default 'voice_nitech_us_awb_arctic_hts)

;; If you want to install voices into a non-default location,
;; see sitevars.scm for the appropriate settings.

(provide 'siteinit)
(Parameter.set 'Audio_Method 'Audio_Command)
(Parameter.set 'Audio_Command "aplay -D plughw:0 -q -f S16_LE -r $SR $FILE")
