;; extends

; Treat CMake if()/endif() blocks as function-like textobjects so `vaf`
; selects the whole conditional block in CMake files.
(if_condition) @function.outer

(if_condition
  .
  (if_command)
  _+ @function.inner
  (endif_command) .)
