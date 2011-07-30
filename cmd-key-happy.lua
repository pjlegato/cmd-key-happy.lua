function Set(t)
   local s = {}
   for _,v in pairs(t) do s[v] = true end
   return s
end

function set_contains(t, e)
   return t[e]
end

-- The set of global shortcuts for which we don't ever want to swap cmd/alt.

global_excludes = Set{ "shift-cmd-tab",
		       "cmd-tab",
                       "cmd-q", -- quit
                       "cmd-p", -- print
                       "cmd-c", -- copy
                       "cmd-v", -- paste
                       "cmd-x", -- cut
                       "cmd-a", -- select all
                       "cmd-=", -- zoom in
                       "cmd--", -- zoom out

                    }

-- The set of apps we want to consider swapping keys for, with some
-- notable exclusions. The exclusion means that a "cmd-w" will do the
-- normal OS Terminal behaviour. If you omit items then you would
-- have to use "alt-w" to close a terminal window.

apps = {
   ["Google Chrome"] = { exclude = Set {
                            "cmd-f", -- find
                            "cmd-g", -- find again
                            "cmd-t", -- new tab
                            "cmd-d", -- create bookmark
                            "cmd-left", -- back 1 page
                            "cmd-right", -- forward 1 page
                            "cmd-r" -- reload page
                    }},
   Terminal = { exclude = Set{ "shift-cmd-[",
                               "shift-cmd-]",
                               "cmd-c",
                               "cmd-v",
                               "cmd-w",
                               "cmd-1",
                               "cmd-2",
                               "cmd-3",
                               "cmd-t",
                               "cmd-n",
                               "cmd-`",
			 } },
   iTerm = { exclude = Set { 
                "cmd-1", -- tab switching
                "cmd-2",
                "cmd-3",
                "cmd-4",
                "cmd-5",
                "cmd-left", -- back 1 tab
                "cmd-right", -- forward 1 tab
                       }},

   Eclipse  = { exclude = {} },
   Xcode    = { exclude = {"cmd-s", "cmd-q", "cmd-b"} },
   TextMate = { exclude = Set { "cmd-1",
				"cmd-2",
				"cmd-3",
				"cmd-4",
				"cmd-t" ,
				"cmd-fn-right",
				"cmd-fn-left",
			  } },
}

-- Return true to swap cmd/alt, otherwise false.

-- This function is passed a table comprising the following keys:
--
--   key_str_seq	key sequence (e.g., "shift-cmd-e")
--   alt		true if the alt key was pressed
--   fn                 true if the fn key was pressed
--   control            true if the control key was pressed
--   shift              true if the shift key was pressed
--   cmd                true if the command key was pressed
--   keycode		numeric virtual keycode (e.g., 48)
--   appname            the frontmost application (e.g., Terminal)
--
-- The order of the modifier keys in key-str-eq is always:
--   shift control alt cmd fn, separated by a hyphen ("-").

function swap_keys(t)
   -- for i,v in pairs(t) do print(i,v) end

   -- print("")
   -- print(t.appname)
   -- print(t.key_str_seq)

   if set_contains(global_excludes, t.key_str_seq) then
      --print(" - Global exclude.")
      return false
   end
   if not apps[t.appname] then
      --print(" - not in apps list")
      return true
   end
   local excludes = apps[t.appname]["exclude"]
   if set_contains(excludes, t.key_str_seq) then
      --print("excluding: ", t.key_str_seq)
      return false
   end

   --print(" ** true **")
   return true
end
