(comment
  "Rewrite of awesomewm default config in fennel
   Macros and extras from: https://github.com/L3afMe/awesome_fennel/
                           https://github.com/shtwzrd/awesome-wm-config
			   https://gitlab.com/renzix/Dotfiles")

(import-macros {: /< : c-kb! : btn : kb! : m!} :awm-macros)
                                         
(m! (awful :awful) (beautiful :beautiful) (gears :gears) (hotkeys-popup :awful.hotkeys_popup)
    (menubar :menubar) (naughty :naughty) (ruled :ruled) (wibox :wibox)
    :awful.autofocus :awful.hotkeys_popup.keys)

(local theme-dir (.. (os.getenv :HOME) "/cfg/awesome/themes/"))
(local theme-name "effet")
(local effet (require (.. "themes." theme-name ".theme")))

(local terminal "emacsclient ")
(local editor (os.getenv :EDITOR))
(local editor-cmd (.. terminal " -e " editor))
(local modkey "Mod4")

(set menubar.utils.terminal terminal)

(local mylauncher (awful.widget.launcher {:image beautiful.awesome_icon :menu mymainmenu}))

(local myawesomemenu
  [[:hotkeys      (λ [] (hotkeys-popup.show_help nil (awful.screen.focused)))]
   [:editor       terminal]
   [:manual       (.. terminal " -e man awesome")]
   ["edit config" (.. editor-cmd " " awesome.conffile)]
   [:restart      (λ [] (awesome.restart))]
   [:quit         (λ [] (awesome.quit))]])

(local mymainmenu (awful.menu {:items [[:awesome myawesomemenu beautiful.awesome_icon]
                                       ["open terminal" terminal]]}))

(fn startup-error! [message startup]
  (naughty.notification {: message
                         :title (.. "Oops, an error happened"  (or (and startup " during startup!") "!"))
                         :urgency :critical}))

(fn init-theme! [t] (beautiful.init t))

(fn set-wallpaper! [s]
  (let [th-assets (.. (os.getenv :XDG_CONFIG_HOME) "/awesome/themes/effet/assets")
        w         (.. (os.getenv :HOME) th-assets "/walls/wallpaper.png")]
  (gears.wallpaper.maximized w s)))

(local mykeyboardlayout (awful.widget.keyboardlayout))
(local mytextclock (wibox.widget.textclock))

(local layout-buttons [
                       (btn 1 (λ [] (awful.layout.inc 1)))
                       (btn 3 (λ [] (awful.layout.inc (- 1))))
                       (btn 4 (λ [] (awful.layout.inc (- 1))))
                       (btn 5 (λ [] (awful.layout.inc 1)))
	              ])

(local taglist-buttons [
                        (btn 1          (λ [t] (t:view_only)))
                        (btn [modkey] 1 (λ [t] (when client.focus (client.focus:move_to_tag t))))
                        (btn 3          (λ [] (awful.tag.viewtoggle)))
		        (btn [modkey] 3 (λ [t] (when client.focus (client.focus:toggle_tag t))))
                        (btn 4          (λ [t] (awful.tag.viewprev t.screen)))
                        (btn 5          (λ [t] (awful.tag.viewnext t.screen)))
		       ])

(local tasklist-buttons [
                         (btn 1 (λ [c] (c:activate {:action :toggle_minimization :context :tasklist})))
                         (btn 3 (λ [] (awful.menu.client_list {:theme {:width 250}})))
                         (btn 4 (λ [] (awful.client.focus.byidx (- 1))))
                         (btn 5 (λ [] (awful.client.focus.byidx 1)))
			])

(fn desktop-decors! [s]
  (awful.tag [:1] s (. awful.layout.layouts 1))

  (set s.mypromptbox (awful.widget.prompt))
  
  (set s.mylayoutbox (awful.widget.layoutbox {:screen s
                                              :buttons layout-buttons}))
					      
  (set s.mytaglist (awful.widget.taglist {:screen s
                                          :filter awful.widget.taglist.filter.all
        		       	          :buttons taglist-buttons}))
					    
  (set s.mytasklist (awful.widget.tasklist {:screen s
                                            :filter awful.widget.tasklist.filter.currenttags
                                            :buttons tasklist-buttons}))
					     
  (set s.mywibox (awful.wibar {:screen s
                               :position :bottom}))
  (: s.mywibox :setup (/< :layout wibox.layout.align.horizontal
	                (/< :layout wibox.layout.fixed.horizontal
			     mylauncher
                             s.mytaglist
                             s.mypromptbox)
                        s.mytasklist
                        (/< :layout wibox.layout.fixed.horizontal
			     mykeyboardlayout
                             (wibox.widget.systray)
                             mytextclock
                             s.mylayoutbox))))

(fn desktop-layouts! []
  (awful.layout.append_default_layouts [awful.layout.suit.floating
                                        awful.layout.suit.max.fullscreen]))

(fn default-global-mouse-keybindings! []
  (awful.mouse.append_global_mousebindings [(btn 3 (λ [] (mymainmenu:toggle)))]))

(fn default-mouse-keybindings! []
  (awful.mouse.append_client_mousebindings
    [(btn 1          (λ [c] (c:activate {:context :mouse_click})))
     (btn [modkey] 1 (λ [c] (c:activate {:action :mouse_move :context :mouse_click})))
     (btn [modkey] 3 (λ [c] (c:activate {:action :mouse_resize :context :mouse_click})))]))

(fn general-awm-keys! []
  (kb!
    [
     {:description "show help" :group :awesome
      :mods [modkey] :key :s
      :action (λ [] (hotkeys_popup.show_help))}
     
     {:description "show main menu" :group :awesome
      :mods [modkey] :key :w
      :action (λ [] (mymainmenu:show))}
    
     {:description "reload awesome" :group :awesome
      :mods [modkey :Control] :key :r
      :action (λ [] (awesome.restart))}
    
     {:description "quit awesome" :group :awesome
      :mods [modkey :Control] :key :q
      :action (λ [] (awesome.quit))}
    
     {:description "lua execute prompt" :group :awesome
      :mods [modkey] :key :x
      :action (λ []
                (awful.prompt.run 
                  {:prompt "<b>Run Lua code:</b> "
                   :textbox (let [screen (awful.screen.focused)]
                              screen.mypromptbox.widget)
                   :exe_callback awful.util.eval
                   :history_path (.. (awful.util.get_cache_dir) "/history_eval")}))}
		 
     {:description "open a terminal" :group :launcher
      :mods [modkey] :key :Return
      :action (λ [] (awful.spawn terminal))}
    
     {:description "run a prompt" :group :launcher
      :mods [modkey] :key :r
      :action (λ []
                (let [s (awful.screen.focused)]
                  (s.mypromptbox:run)))}
		
     {:description "show the menubar" :group :launcher
      :mods [modkey] :key :p
      :action (λ [] (menubar.show))}
    ]))

(fn tags-related-keys! []
  (c-kb! [
          {:description "view previous" :group :tag
           :mods [modkey] :key :Left
           :action (λ [] (awful.tag.viewprev))}
	    
          {:description "view next" :group :tag
	   :mods [modkey] :key :Right
	   :action (λ [] (awful.tag.viewnext))}
	    
          {:description "go back" :group :tag
	   :mods [modkey] :key :Escape
	   :action (λ [] (awful.tag.history.restore))}
	  ]))

(fn focus-related-keys! []
  (kb!
    [
     {:description "focus next by index" :group :client
      :mods [modkey] :key :j
      :action (λ [] (awful.client.focus.byidx 1))}
    
     {:description "focus previous by index" :group :client
      :mods [modkey] :key :k
      :action (λ [] (awful.client.focus.byidx (- 1)))}
    
     {:description "go back" :group :client
      :mods [modkey] :key :Tab
      :action (λ [] (awful.client.focus.history.previous)
                    (when client.focus (client.focus:raise)))}
		   
     {:description "focus the next screen" :group :screen
      :mods [modkey :Control] :key  :j
      :action (λ [] (awful.screen.focus_relative 1))}
   
     {:description "focus the previous screen" :group :screen
      :mods [modkey :Control] :key :k
      :action (λ [] (awful.screen.focus_relative (- 1)))}
   
     {:description "restore minimized" :group :client
      :mods [modkey :Control] :key :n
      :action (λ [] (let [c (awful.client.restore)]
                         (when c (c:activate {:context :key.unminimize
     		                              :raise true}))))}
    ]))
 
(fn awm-keys! [] 
  (c-kb!
    [
     {:description "toggle fullscreen" :group :client
      :mods [modkey] :key :f
      :action (λ [c] (set c.fullscreen (not c.fullscreen)) (c:raise))}
        
     {:description "kill client" :group :client
      :mods [modkey :Shift] :key :c
      :action (λ [c] (c:kill))}
	
     {:description "toggle floating" :group :client
      :mods [modkey :Control] :key :space
      :action (λ [] (awful.client.floating.toggle))}
	
     {:description "move to master" :group :client
      :mods [modkey :Control] :key :Return
      :action (λ [c] (c:swap (awful.client.getmaster)))}
	
     {:description "move to screen" :group :client
      :mods [modkey] :key :o
      :action (λ [c] (c:move_to_screen))}
	
     {:description "toggle keep on top" :group :client
      :mods [modkey] :key :t
      :action (λ [c] (set c.ontop  (not c.ontop)))}
	
     {:description :minimize :group :client
      :mods [modkey] :key :n
      :action (λ [c] (set c.minimized true))}
	
     {:description "(un)maximize" :group :client
      :mods [modkey] :key :m
      :action (λ [c] (not c.maximized) (c:raise))}
	
     {:description "(un)maximize vertically" :group :client
      :mods [modkey :Control] :key :m
      :action (λ [c] (set c.maximized_vertical (not c.maximized_vertical)) (c:raise))}
	
     {:description "(un)maximize horizontally" :group :client
      :mods [modkey :Shift] :key :m
      :action (λ [c] (set c.maximized_horizontal (not c.maximized_horizontal)) (c:raise))}
    ]))

(fn awm-keys-group! []
  (general-awm-keys!)
  (tags-related-keys!)
  (focus-related-keys!))

(fn rules! []
  (ruled.client.append_rule
    {:id :global
     :rule {}
     :properties {:focus awful.client.focus.filter
                  :raise true
		  :screen awful.screen.preferred
                  :placement (+ awful.placement.no_overlap awful.placement.no_offscreen)}})
    
  (ruled.client.append_rule {:id floating
                             :rule_any {
			                :instance [:copyq :pinentry]
			                :class [
					        :Arandr
                                                :Blueman-manager
                                                :Gpick
                                                :Kruler
                                                :Sxiv
                                                "Tor Browser"
                                                :Wpa_gui
                                                :veromix
                                                :xtightvncviewer
					       ]
					:name ["Event Tester"]
					:role [
					       :AlarmWindow
                                               :ConfigManager
                                               :pop-up
					      ]}
			     :properties {:floating true}})

  (ruled.client.append_rule {:id :titlebars
                             :rule_any   {:type [:normal :dialog]}
                             :properties {:titlebars_enabled true}}))

(fn titlebars! [c]
 (let [buttons [(btn 1 (λ [] (c:activate {:action :mouse_move :context :titlebar})))
                (btn 3 (λ [] (c:activate {:action :mouse_resize :context :titlebar})))]
		titlebar (awful.titlebar c)]
  (: titlebar :setup (/< :layout wibox.layout.align.horizontal
    		       (/< :layout wibox.layout.fixed.horizontal
		  	   (awful.titlebar.widget.iconwidget c)
                           :buttons buttons)            
                       (/< :layout wibox.layout.flex.horizontal
		           :halign :center
                           :widget (awful.titlebar.widget.titlewidget c)
                           :buttons buttons)
		       (/< :layout (wibox.layout.fixed.horizontal)
		    	   (awful.titlebar.widget.floatingbutton c)
                           (awful.titlebar.widget.maximizedbutton c)
                           (awful.titlebar.widget.stickybutton c)
                           (awful.titlebar.widget.ontopbutton c)
                           (awful.titlebar.widget.closebutton c))))))	

(fn notifications-rule! []
  (ruled.notification.append_rule {:rule {}
                                   :properties {:screen awful.screen.preferred
				                :implicit_timeout 5}}))

(fn notify! [n] (naughty.layout.box {:notification n}))

(fn sloppy-focus! [c]
  (c:activate {:context :mouse_enter
               :raise false}))

(init-theme! effet)

(naughty.connect_signal             "request::display_error"      startup-error!)
(screen.connect_signal              "request::wallpaper"          set-wallpaper!)
(screen.connect_signal              "request::desktop_decoration" desktop-decors!)
(client.connect_signal              "mouse::enter"                sloppy-focus!)
(ruled.notification.connect_signal  "request::rules"              notifications-rule!)
(naughty.connect_signal             "request::display"            notify!)
(tag.connect_signal                 "request::default_layouts"    desktop-layouts!)

(default-global-mouse-keybindings!)
(client.connect_signal              "request::default_mousebindings" default-mouse-keybindings!)
(awm-keys-group!)

(client.connect_signal              "request::default_keybindings" awm-keys!)
(client.connect_signal              "request::titlebars"           titlebars!)
(ruled.client.connect_signal        "request::rules"               rules!)

