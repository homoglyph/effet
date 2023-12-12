(fn map [func coll]
 "Map a function over a table (collection)"
 (let [out {}]
   (each [idx value (ipairs coll)]
     (tset out idx (func value)))
   out))

(fn /< [...]
  "Create a 'mixed' table like in standard Lua.
  The table can contain both sequential and non-sequential keys.
  Like:
    (/< (awful.titlebar.widget.iconwidget c)
        :buttons buttons
        :layout wibox.layout.fixed.horizontal)
  Useful for wibox declarations."
  (let [tbl {}]
    (var skip 0)
    (each [i v (ipairs [...])]
      (when (~= i skip)
        (let [tv (type v)]
          (match tv
                 "string" (do
                            (set skip (+ i 1))
                            (tset tbl v (. [...] skip)))
                 "table"  (table.insert tbl v)
                 _        (error (.. tv " key literal in mixed table"))))))
    tbl))

(fn c-kb! [...]
  "Better handling for client keybindings"
  (let [binds ...]
    `(awful.keyboard.append_client_keybindings
       ,(map (λ [bind]
                `(awful.key
		  {:key          ,bind.key
		   :modifiers    ,bind.mods
		   :keygroup     ,bind.keygroup
                   :description  ,bind.description
		   :name         ,bind.name
		   :group        ,bind.group
		   :on_press     ,bind.action
		   :on_release   ,bind.action_release}))
              binds))))

(fn btn [arg1 arg2 arg3]
  "Better handling for awful.button"
  (if (= arg3 nil)
    `(awful.button {} ,arg1 ,arg2)
    `(awful.button ,arg1 ,arg2 ,arg3)))

(fn kb! [...]
  "Better handling for global keybindings"
  (let [binds ...]
    `(awful.keyboard.append_global_keybindings
       ,(map (λ [bind]
                `(awful.key
		  {:key          ,bind.key
		   :modifiers    ,bind.mods
		   :keygroup     ,bind.keygroup
                   :description  ,bind.description
		   :name         ,bind.name
		   :group        ,bind.group
		   :on_press     ,bind.action
		   :on_release   ,bind.action_release}))
              binds))))
	      
(fn m! [...]
  "Silly modules macro ..."
  (var ret {})
  (for [i 1 (length [...])]
    (if (list? (. [...] i))
        (table.insert ret `(local ,(. (. [...] i) 1) (require ,(. (. [...] i) 2))))
        (table.insert ret `(require ,(. [...] i)))))
  ret)

 {: /< : c-kb! : btn : kb! : m!} 
