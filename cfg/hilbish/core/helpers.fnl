(import-macros {: m! : env!} :hilbish-macros)

(m! ({: runnerMode : runner} :hilbish))

(fn runner! [mode]
  "Set the mode of the shell since hilbish is special!" 
  (local input {})
  (runnerMode (λ [input]
                (let [ok (pcall mode input {:useMetadata true})]
                  (when ok (lua "return input, 0, nil"))
                    (runner.sh input)))))
		    
(fn set-env-dir
  [dir evar]
  (string.format (.. "%s/" dir) evar))

(fn set-nix-file-dir
  [dir nix-file evar]
  (string.format (.. "%s/" dir "/" nix-file) evar))

{: runner!
 : set-env-dir
 : set-nix-file-dir}
 
