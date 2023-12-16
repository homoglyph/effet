(import-macros {: m!
		: p!} :hilbish-macros)

(m! ({: runner!} :core.helpers)
    ({: greeting-enable
      : motd-enable
      : runner-mode} :user))

(fn hilbish- []
  "... 🌺" 
  (runner! runner-mode)
  (set hilbish.opts.greeting greeting-enable)
  (set hilbish.opts.motd motd-enable))

(hilbish-)
