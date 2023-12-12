#!/usr/bin/env fennel

(fn say-hi []
  (print "hi!"))

(fn parse-args []
  (while (. arg 1)
    (when (= "--please" (. arg 1))
      (do
        (print "You said the magic word")
        (say-hi)
        (os.exit 0)))))

(fn main- []
  (parse-args)) 

(main-) 
 
