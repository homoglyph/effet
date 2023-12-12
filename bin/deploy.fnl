#!/usr/bin/env fennel

(comment
  "Dummy and WIP script for now...")

(fn fnl->lua []
  "This is probably not a good idea ..."
  (os.execute "cp $XDG_CONFIG_HOME/awesome/rc.lua $XDG_CONFIG_HOME/awesome/rc.lua.bk")
  (os.execute "cp $XDG_CONFIG_HOME/hilbish/init.lua $XDG_CONFIG_HOME/hilbish/init.lua.bk")
  (os.execute "fennel --compile $PWD/cfg/awesome/rc.fnl > $XDG_CONFIG_HOME/awesome/rc.lua")
  (os.execute "fennel --compile $PWD/cfg/hilbish/init.fnl > $XDG_CONFIG_HOME/hilbish/init.lua"))

(fn parse-args []
  (while (. arg 1)
    (when (= "--unsafe" (. arg 1))
      (do
        (print "Backuping old lua files and compiling fennel files to lua.")
        (fnl->lua)
        (os.exit 0))))

(fn main- []
  (parse-args))

(main-)
