(import-macros {: alias! : m!} :hilbish-macros)

(m! (hp :helpers) (h :hilbish) (f :fennel) (lu :lume))

(local hilbish-options
       {
        :runner-mode     f.eval
        :greeting-enable false
        :motd-enable     false
       })
 
(local env
       {
        :bin-dir    (or (hp.set-env-dir "bin" h.home) (hp.set-env-dir! "/.local/bin" h.home))
        :config-dir (or (hp.set-env-dir "cfg" h.home) (hp.set-env-dir! "/.config" h.home))
        :cache-dir  (or (hp.set-env-dir "cch" h.home) (hp.set-env-dir! "/.cache" h.home))
        :data-dir   (or (hp.set-env-dir "lcl/share" h.home) (hp.set-env-dir! "/.local/share" h.home))
        :state-dir  (or (hp.set-env-dir "lcl/state" h.home) (hp.set-env-dir! "/.cache" h.home))
        :editor     (or "emacs" "nvim")
	:libva-driver "iHD"
       })

(local tools
       {
        :volta-home-dir      (hp.set-env-dir "volta" h.userDir.data)
        :ghcup-xdg           "true"  
        :cabal-dir           (hp.set-env-dir "cabal" h.userDir.config)
        :stack-root-dir      (hp.set-env-dir "stack" h.userDir.config)
        :asdf-dir            (hp.set-env-dir "common-lisp/source" h.userDir.data)
       })

(local xtra
       {
        :nyxt-bin-dir (hp.set-env-dir "nyxt" tools.asdf-dir)
	:nyxt-shell-nix-file (hp.set-nix-file-dir "utl/nix_shells/" "shell_nyxt.nix" h.home)
       })

(local paths { :paths [env.bin-dir
                       tools.volta-home-dir] })

(local aliases
       [
        (alias! "wm!" "$XDG_BIN_HOME/sx")
        (alias! "c"   "clear")
        (alias! "l"   "ls -AFhlv --group-directories-first --color=always")
 		 
        (alias! ":dfu" "sudo dnf update")
        (alias! ":dfi" "sudo dnf install -y")
        (alias! ":dfr" "sudo dnf remove")
        (alias! ":dfs" "sudo dnf search")

        (alias! ":gc" "git clone")
        (alias! ":gp" "git pull")
        (alias! ":gc" "mkdir -p")
 
        (alias! ":nx!" "nix-shell --command 'hilbish -c=$NYXT_BIN_DIR/nyxt' $NYXT_SHELL_NIX")
        (alias! ":s"   "sleep")
        (alias! ":sc!" "maim -s -m 10 $HOME/doc/$(date).png")
        (alias! ":fnc" "fennel --compile")
        (alias! ":fnl" "fennel --load")
      ])

(local user
       (lu.merge hilbish-options
                 env
                 tools
	         xtra
	         paths
	         aliases))

user
