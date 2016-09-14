(import chicken bind foreign srfi-4 extras regex)

(import-for-syntax regex matchable)

(include "struct-by-value-transformer.scm")

;; dummy declaration to avoid unbound identifier error
(define struct-by-value-transformer #f)

;; these headers are modified for compatibility with chicken bind
(bind-include-path "./include")

;; strip "cp.." prefix
(bind-rename/pattern "^cp" "")

(bind-options default-renaming: ""
	      foreign-transformer: struct-by-value-transformer
	      export-constants: true)

;;;; Override definitions

(bind "#define CP_EXPORT")
(bind "#define CP_PI 3.14159265358979")

;; REVIEW what type to use?
;; chicken-bind doesn't support the default uintptr_t
(bind "#define CP_GROUP_TYPE unsigned int")
(bind "#define CP_HASH_VALUE_TYPE unsigned int")
(bind "#define CP_COLLISION_TYPE_TYPE unsigned int")

(define uint
  (foreign-lambda* unsigned-int ((int x))
    "unsigned int n = x;
     C_return(n);") )

(bind-file "include/chipmunk.h")

;;;; Uncomment below and run 'chicken-install to generate chipmunk-getter-with-setters.scm

;; (define-for-syntax usual-naming-transform
;;   (let ()
;;     (define (downcase-string str) ; so we don't have to use srfi-13
;;       (let ([s2 (string-copy str)]
;; 	    [n (string-length str)] )
;; 	(do ([i 0 (fx+ i 1)])
;; 	    ((fx>= i n) s2)
;; 	  (string-set! s2 i (char-downcase (string-ref str i))) ) ) )
;;     (lambda (m)
;;       (downcase-string
;;        (string-translate
;; 	(string-substitute "([a-z])([A-Z])" "\\1-\\2" m #t)
;; 	"_" "-") ) ) ) )



;; (begin-for-syntax


;; (define-for-syntax foo (append-map
;; 			(lambda (x)
;; 			  (if (string? (car x))
;; 			      (match (string-match (regexp "cp([A-Z][A-Za-z]+)(Is|Get|Set|Add)([A-Za-z]+)") (car x))
;; 				[(m class op attribute)
;; 				 (list (map (compose string->symbol usual-naming-transform) (list class attribute op)))]
;; 				[ow (list)])
;; 			      (list)))
;; 			function-names))


;;  (define-syntax define-attr-access
;;    (syntax-rules ()
;;      ((define-attr-access attr-list class attr op)
;; 					;(pretty-print `(expr ,class ,attr ,op))
;;       (if (member (list class attr 'set) attr-list) ;; has a setter?
;; 	  `(define ,(symbol-append class '- attr)
;; 	     (getter-with-setter
;; 	      ,(symbol-append class '-get- attr)
;; 	      ,(symbol-append class '-set- attr)))
;; 	  `(define ,(symbol-append class '- attr)
;; 	     ,(symbol-append class '-get- attr))))))

;;  (with-output-to-file "chipmunk-getter-with-setters.scm"
;;    (lambda ()
;;      (for-each
;;       (lambda (x)
;; 	(apply (lambda (class attr op)
;; 		 (when (equal? op 'get)
;; 		   (pretty-print (define-attr-access foo class attr op))))
;; 	       x))

;;       (append-map
;;        (lambda (x)
;; 	 (if (string? (car x))
;; 	     (match (string-match (regexp "cp([A-Z][A-Za-z]+)(Is|Get|Set|Add)([A-Za-z]+)") (car x))
;; 	       [(m class op attribute)
;; 		(list (map (compose string->symbol usual-naming-transform) (list class attribute op)))]
;; 	       [ow (list)])
;; 	     (list)))
;;        function-names)))))
