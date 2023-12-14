(import-macros {: env! : m! : p!} :hilbish-macros)

(m! (b :bait) (c :commander) (f :fennel) (h :hilbish)
    (hp :helpers) (lc :lunacolors) (u :user))

(hp.runner! u.runner-mode)

;; HILBISH options
(set h.opts.greeting u.greeting-enable)
(set h.opts.motd u.motd-enable)
(c.register "ver" (λ [] (print h.ver)))

;; ENVIRONMENT
(env! :XDG_BIN_HOME       u.bin-dir) 
(env! :XDG_CONFIG_HOME    u.config-dir) 
(env! :XDG_CACHE_HOME     u.cache-dir)  
(env! :XDG_DATA_HOME      u.data-dir) 
(env! :XDG_STATE_HOME     u.state-dir)
(env! :EDITOR             u.editor)
(env! :LIBVA_DRIVER_NAME  u.libva-driver)
(env! :VOLTA_HOME         u.volta-home-dir)
(env! :GHCUP_USE_XDG_DIRS u.ghcup-xdg)
(env! :CABAL_DIR          u.cabal-dir)    
(env! :CABAL_CONFIG       (env! :CABAL_DIR))
(env! :STACK_ROOT         u.stack-root-dir)
(env! :ASDF_PROJECTS      u.asdf-dir)

;; NYXT stuff
(env! :NYXT_BIN_DIR   u.nyxt-bin-dir)
(env! :NYXT_SHELL_NIX u.nyxt-shell-nix-file)

;; $PATH
(p! u.paths)
