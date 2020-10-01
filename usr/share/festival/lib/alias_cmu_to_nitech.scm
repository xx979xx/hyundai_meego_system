;
; This file is trivial and I make no claims of copyright. However, I should 
; certainly credit Nickolay V. Shmyrev, who sent me a snippet of code on
; which this is based.
;                     -- Matthew Miller <mattdm@mattdm.org>
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Make aliases for cmu_us_*_arctic_hts voices previously shipped with
;;; Fedora which are now replaced by the nitech_us_*_arctic_hts versions
;;; of the same voices.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (and (member 'nitech_us_awb_arctic_hts (voice.list))
         (not (member 'cmu_us_awb_arctic_hts (voice.list))))
 (define (voice_cmu_us_awb_arctic_hts)
    (voice_nitech_us_awb_arctic_hts)
    'cmu_us_awb_arctic_hts))

(if (and (member 'nitech_us_bdl_arctic_hts (voice.list))
         (not (member 'cmu_us_bdl_arctic_hts (voice.list))))
 (define (voice_cmu_us_bdl_arctic_hts)
    (voice_nitech_us_bdl_arctic_hts)
    'cmu_us_bdl_arctic_hts))

(if (and (member 'nitech_us_jmk_arctic_hts (voice.list))
         (not (member 'cmu_us_jmk_arctic_hts (voice.list))))
 (define (voice_cmu_us_jmk_arctic_hts)
    (voice_nitech_us_jmk_arctic_hts)
    'cmu_us_jmk_arctic_hts))

(if (and (member 'nitech_us_slt_arctic_hts (voice.list))
         (not (member 'cmu_us_slt_arctic_hts (voice.list))))
 (define (voice_cmu_us_slt_arctic_hts)
    (voice_nitech_us_slt_arctic_hts)
    'cmu_us_slt_arctic_hts))

