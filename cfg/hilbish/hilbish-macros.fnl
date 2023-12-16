(fn map [func coll]
 "Map a function over a table (collection)"
 (let [out {}]
   (each [idx value (ipairs coll)]
     (tset out idx (func value)))
   out))

(fn a! [...]
  "Better handling for hilbish.alias/add."
   (let [aliases ...]
      (map (λ [alias] `(hilbish.alias ,alias.a ,alias.c))
             aliases)))

(fn env! [name value]
  "For set/getting ENVIRONMENT vars."
  (if (not= value nil)
  `(os.setenv ,name ,value)
  `(os.getenv ,name)))

(fn e! [...]
  "Better handling for os.{set/get}env."
   (let [evars ...]
     (map (λ [e] `(env! ,e.e ,e.v))
            evars)))

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

{: a!
 : env!
 : e!
 : m!
 : p!}
