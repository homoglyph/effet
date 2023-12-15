(fn alias! [name ...]
  "Check if an alias can be assigned to an existing program."
  (var ret nil)
  (for [i 1 (length [...]) :until (not= ret nil)]
    (if (not= (hilbish.which (. [...] i)) "")
          (set ret `(hilbish.alias ,(tostring name) ,(. [...] i)))))
  ret)

(fn env! [name value]
  "For set/getting ENVIRONMENT vars."
  (if (not= value nil)
  `(os.setenv ,name ,value)
  `(os.getenv ,name)))

(fn m! [...]
  "Silly modules macro ..."
  (var ret {})
  (for [i 1 (length [...])]
    (if (list? (. [...] i))
        (table.insert ret `(local ,(. (. [...] i) 1) (require ,(. (. [...] i) 2))))
        (table.insert ret `(require ,(. [...] i)))))
  ret)
		     
(fn p! [...]
  "Append aliases to PATH."
  (var ret {})
  (each [_ value (ipairs [...])]
    (table.insert ret `(hilbish.appendPath ,value)))
  ret)

{: alias!
 : env!
 : m!
 : p!}
 
