(import-macros {: alias! : m! : env!} :config-macros)

(m! (b :bait) (c :commander) (f :fennel) (h :hilbish)
    (lc :lunacolors))
    
(fn runner! [mode]
  (local input {})
  (h.runnerMode (λ [input]
                   (let [ok (pcall mode input {:useMetadata true})]
                     (when ok (lua "return input, 0, nil"))
                   (h.runner.sh input)))))

(runner! f.eval)

;; helpers
(fn genv-bin [name]
  (when (not= name nil)
    (.. (os.getenv name) "/bin")))

(fn bin-path! [dir]
  (when (not= dir nil)
    (hilbish.appendPath (genv-bin dir))))

(fn p-path! [dir]
  (when (not= dir nil)
    (hilbish.prependPath (env! dir))))

;; general options
(set h.opts.greeting false)
(set h.opts.motd false)
(c.register "ver"    (λ [] (print h.ver)))
(c.register "udir"   (λ [] (print h.userDir.data)))
(c.register "uconf"  (λ [] (print h.userDir.config)))
(c.register "ucache" (λ [] (print (env! :XDG_CACHE_HOME))))

;; general ENVIRONMENT
(env! :XDG_BIN_HOME    (string.format "%s/bin" (os.getenv :HOME))) ;; $HOME/.local/bin
(env! :XDG_CONFIG_HOME (string.format "%s/cfg" (os.getenv :HOME))) ;; $HOME/.config
(env! :XDG_CACHE_HOME  (string.format "%s/cch" (os.getenv :HOME))) ;; $HOME/.cache
(env! :XDG_DATA_HOME   (string.format "%s/lcl/share" (os.getenv :HOME))) ;; $HOME/.local/share
(env! :XDG_STATE_HOME  (string.format "%s/lcl/state" (os.getenv :HOME))) ;; $HOME/.local/state
(env! :LIBVA_DRIVER_NAME "iHD")
(env! :EDITOR "emacs")
(env! :VOLTA_HOME (string.format "%s/volta" h.userDir.data))
(env! :GHCUP_USE_XDG_DIRS "true")
(env! :CABAL_DIR (string.format "%s/cabal" h.userDir.config))    
(env! :CABAL_CONFIG (env! :CABAL_DIR))
(env! :STACK_ROOT (string.format "%s/stack" h.userDir.config))

;; NYXT stuff
(env! :WEBKIT_DISABLE_COMPOSITING_MODE "1")
(env! :ASDF_PROJECTS  (string.format "%s/common-lisp/source" h.userDir.data))
(env! :NYXT_BIN_DIR   (string.format "%s/nyxt/" (os.getenv :ASDF_PROJECTS)))
(env! :NYXT_SHELL_NIX (string.format "%s/utl/nix_shells/shell_nyxt.nix" (os.getenv :HOME)))

;; dirs in PATH
(p-path!   :XDG_BIN_HOME)
(bin-path! :VOLTA_HOME)

;; aliases
(alias! "wm!" "$XDG_BIN_HOME/sx")
(alias! "pw!" "poweroff")
(alias! "re!" "reboot")
(alias! "nx!" "nix-shell --command 'hilbish --command=$NYXT_BIN_DIR/nyxt' $NYXT_SHELL_NIX")
(alias! c   "clear")
(alias! l   "ls -AFhlv --group-directories-first --color=always")
(alias! "rb!" "sudo systemctl restart bluetooth")
(alias! ":dfu" "sudo dnf update")
(alias! ":dfi" "sudo dnf install -y")
(alias! ":dfr" "sudo dnf remove")
(alias! ":dfs" "sudo dnf search")
(alias! ":gc" "git clone")
(alias! ":gp" "git pull")

;; WIP ZONE
(comment
 "(fn send-message! [job-name ?ico txt tl ?ch ?su]
    (b.catch :job.done
      (λ [job]
        (when (not (job.cmd:match "^job-name")) (lua "return "))
      (h.messages.send {:icon (or ?ico "•")
                        :text    txt
                        :title   tl
	    	        :channel ?ch
	  	        :summary ?su}))))
		      
  (fn notify! [message pos duration]
    (b.catch :h.notification
      (λ [] (h.prompt (lc.blue message) pos)
            (h.timeout (λ [] (h.prompt "" pos)) duration))))	
  
  (send-message! "dnf update" _ "DNF finished pkgs update!")
  (send-message! "ls" _ "ls finshed displaying dirs in $PWD")
  (notify! "• 1 new notification" :right 3000)" ) 
