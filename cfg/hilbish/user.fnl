(comment
  "Effet's machine hilbish config.
   Macros and extras from: https://gitlab.com/renzix/Dotfiles
			   https://github.com/TorchedSammy/dotfiles/
   Depends on: https://github.com/rxi/lume
               https://github.com/bakpakin/Fennel")

(import-macros {: a!
                : e!
		: env!
                : m!
		: p!} :hilbish-macros)

(m! ({: set-env-dir
      : set-nix-file-dir} :core.helpers)
    ({: home
      : userDir} :hilbish)
    ({: eval} :fennel)
    ({: merge} :lume))

(local hilbish-options
  {:runner-mode     eval
   :greeting-enable false
   :motd-enable     false})
 
(local env
  {:bin-dir      (set-env-dir home "bin")
   :config-dir   (set-env-dir home "cfg")
   :cache-dir    (set-env-dir home "cch" )
   :data-dir     (set-env-dir home "lcl/share")
   :state-dir    (set-env-dir home "lcl/state")
   :editor       "emacs"
   :libva-driver "iHD"})

(local tools
  {:volta-home-dir (set-env-dir userDir.data "volta")
   :ghcup-xdg      "true"  
   :cabal-dir      (set-env-dir userDir.config "cabal")
   :stack-root-dir (set-env-dir userDir.config "stack")
   :asdf-dir       (set-env-dir userDir.data "common-lisp/source")})

(local xtra
  {:nyxt-bin-dir        (set-env-dir tools.asdf-dir "nyxt")
   :nyxt-shell-nix-file (set-nix-file-dir home  "utl/nix_shells/" "shell_nyxt.nix")})

(local evars 
  (e! [{:e :XDG_BIN_HOME       :v env.bin-dir}
       {:e :XDG_CONFIG_HOME    :v env.config-dir}
       {:e :XDG_CACHE_HOME     :v env.cache-dir}  
       {:e :XDG_DATA_HOME      :v env.data-dir}
       {:e :XDG_STATE_HOME     :v env.state-dir}
       {:e :EDITOR             :v env.editor}
       {:e :LIBVA_DRIVER_NAME  :v env.libva-driver}
       {:e :VOLTA_HOME         :v tools.volta-home-dir}
       {:e :GHCUP_USE_XDG_DIRS :v tools.ghcup-xdg}
       {:e :CABAL_DIR          :v tools.cabal-dir}    
       {:e :CABAL_CONFIG       :v (env! :CABAL_DIR)}
       {:e :STACK_ROOT         :v tools.stack-root-dir}
       {:e :ASDF_PROJECTS      :v tools.asdf-dir}
       {:e :NYXT_BIN_DIR       :v xtra.nyxt-bin-dir}
       {:e :NYXT_SHELL_NIX     :v xtra.nyxt-shell-nix-file}]))

(local paths (p! env.bin-dir
                 tools.volta-home-dir))

(local aliases
 (a! [{:a "c"    :c "clear"}
      {:a "l"    :c "ls -AFhlv --group-directories-first --color=always"}
      {:a ":q"   :c "exit"}
      {:a ":wm!" :c "$XDG_BIN_HOME/sx"}
      {:a ":dfi" :c "sudo dnf install -y"}
      {:a ":dfr" :c "sudo dnf remove"}
      {:a ":dfs" :c "sudo dnf search"}
      {:a ":dfu" :c "sudo dnf update"}
      {:a ":fnc" :c "fennel --compile"}
      {:a ":fnl" :c "fennel --load"}
      {:a ":nx!" :c "nix-shell --command 'hilbish -c=$NYXT_BIN_DIR/nyxt' $NYXT_SHELL_NIX"}]))

(local user
  (merge hilbish-options
         env
         tools
         xtra
	 evars
         paths
	 aliases))

user
