(import-macros {: alias!
                : m!} :hilbish-macros)

(m! ({: set-env-dir
      : set-nix-file-dir} :core.helpers)
    ({: home
      : userDir} :hilbish)
    ({: eval} :fennel)
    ({: merge} :lume))

(local hilbish-options
       {
        :runner-mode     eval
        :greeting-enable false
        :motd-enable     false
       })
 
(local env
       {
        :bin-dir      (set-env-dir "bin" home)
        :config-dir   (set-env-dir "cfg" home)
        :cache-dir    (set-env-dir "cch" home)
        :data-dir     (set-env-dir "lcl/share" home)
        :state-dir    (set-env-dir "lcl/state" home)
        :editor       "emacs"
	:libva-driver "iHD"
       })

(local tools
       {
        :volta-home-dir (set-env-dir "volta" userDir.data)
        :ghcup-xdg      "true"  
        :cabal-dir      (set-env-dir "cabal" userDir.config)
        :stack-root-dir (set-env-dir "stack" userDir.config)
        :asdf-dir       (set-env-dir "common-lisp/source" userDir.data)
       })

(local xtra
       {
        :nyxt-bin-dir        (set-env-dir "nyxt" tools.asdf-dir)
	:nyxt-shell-nix-file (set-nix-file-dir "utl/nix_shells/" "shell_nyxt.nix" home)
       })

(local paths {:paths [env.bin-dir
                      tools.volta-home-dir]})

(comment
  "!: This section looks repetitive in comparison with rest of the config.
   ?: Is there a way to make it more tidy? 
   a: Probably defining and using a macro like:
      (a! a-list) where a-list has the following structure:
      [{:a "my-alias" :c "command"}
       {...} ...]")
    
(local aliases
       [
        (alias! "c"    "clear")
        (alias! "l"    "ls -AFhlv --group-directories-first --color=always")
        (alias! ":q"   "exit")
        (alias! ":wm!" "$XDG_BIN_HOME/sx")
	
        (alias! ":dfi" "sudo dnf install -y")
        (alias! ":dfr" "sudo dnf remove")
        (alias! ":dfs" "sudo dnf search")
        (alias! ":dfu" "sudo dnf update")
       
        (alias! ":fnc" "fennel --compile")
        (alias! ":fnl" "fennel --load")
	(alias! ":nx!" "nix-shell --command 'hilbish -c=$NYXT_BIN_DIR/nyxt' $NYXT_SHELL_NIX")
      ])

(local user
       (merge hilbish-options
              env
              tools
	      xtra
	      paths
	      aliases))

user
