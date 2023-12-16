(import-macros {: m!
                : env!} :hilbish-macros)

(m! ({: join} :fs)
    ({: runnerMode
      : runner} :hilbish))

(fn runner! [mode]
  "Set the mode of the shell since hilbish is special!" 
  (local input {})
  (runnerMode (λ [input]
                (let [ok (pcall mode input {:useMetadata true})]
                  (when ok (lua "return input, 0, nil"))
                    (runner.sh input)))))

(fn set-env-dir
  [evar dir]
  (fs.join evar dir))

(fn set-nix-file-dir
  [evar dir nix-file]
  (fs.join evar dir nix-file))

{: runner!
 : set-env-dir
 : set-nix-file-dir}
 
