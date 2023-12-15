(import-macros {: env!
                : m!
		: p!} :hilbish-macros)

(m! ({: runner!} :core.helpers)
    ({: asdf-dir
      : bin-dir
      : cabal-dir
      : cache-dir
      : config-dir
      : data-dir
      : editor
      : ghcup-xdg
      : greeting-enable
      : libva-driver
      : motd-enable
      : nyxt-bin-dir
      : nyxt-shell-nix-file
      : paths
      : runner-mode
      : stack-root-dir
      : state-dir
      : volta-home-dir} :user))

(runner! runner-mode)
(set hilbish.opts.greeting greeting-enable)
(set hilbish.opts.motd motd-enable)

(env! :XDG_BIN_HOME       bin-dir) 
(env! :XDG_CONFIG_HOME    config-dir) 
(env! :XDG_CACHE_HOME     cache-dir)  
(env! :XDG_DATA_HOME      data-dir) 
(env! :XDG_STATE_HOME     state-dir)
(env! :EDITOR             editor)
(env! :LIBVA_DRIVER_NAME  libva-driver)
(env! :VOLTA_HOME         volta-home-dir)
(env! :GHCUP_USE_XDG_DIRS ghcup-xdg)
(env! :CABAL_DIR          cabal-dir)    
(env! :CABAL_CONFIG       (env! :CABAL_DIR))
(env! :STACK_ROOT         stack-root-dir)
(env! :ASDF_PROJECTS      asdf-dir)
(env! :NYXT_BIN_DIR       nyxt-bin-dir)
(env! :NYXT_SHELL_NIX     nyxt-shell-nix-file)

(p! paths)
;; (a! aliases)

