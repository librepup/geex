------------------------------------------
-- Loji's/Nixpup's XMonad Configuration --
------------------------------------------

import XMonad
import Data.Monoid
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Layouts
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.ResizableTile

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.SetWMName

-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Util.Cursor (setDefaultCursor)
import Graphics.X11.Xlib (xC_left_ptr)

-- Actions
import XMonad.Actions.FloatKeys
import XMonad.Actions.WithAll
import XMonad.Actions.CycleWS
import XMonad.Actions.Warp
import XMonad.Actions.MouseResize

------------------------------------------------------------------------
-- Variables
------------------------------------------------------------------------
myModMask       = mod1Mask  -- Alt key (mod1)
myWinMask       = mod4Mask  -- Windows/Super key (mod4)
myTerminal      = "kitty"
myBorderWidth   = 2
myFocusedBorderColor = "#ffbf2d"
myNormalBorderColor  = "#1d1f21"

-- Old Theme | Marnie Theme
-- myFocusedBorderColor = "#ff2a54"  -- Marnie Theme pink
-- myNormalBorderColor  = "#1d1f21"  -- Dark gray

------------------------------------------------------------------------
-- Workspaces
------------------------------------------------------------------------
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]

------------------------------------------------------------------------
-- Tab Theme (Marnie Theme)
------------------------------------------------------------------------
-- Old Theme | Marnie Theme
-- activeColor         = "#ff2a54"
-- , activeBorderColor   = "#ff2a54"
-- , inactiveColor       = "#282A2E"
-- , inactiveBorderColor = "#282A2E"
myTabTheme = def
    { activeColor         = "#ffbf2d"
    , inactiveColor       = "#1d1f21"
    , urgentColor         = "#ff0000"
    , activeBorderColor   = "#ffbf2d"
    , inactiveBorderColor = "#1d1f21"
    , urgentBorderColor   = "#ff0000"
    , activeTextColor     = "#000000"
    , inactiveTextColor   = "#888888"
    , urgentTextColor     = "#ffffff"
    , fontName            = "xft:DejaVu Sans Mono:size=10"
    , decoHeight          = 14         -- Tab bar height
    }

------------------------------------------------------------------------
-- Prompt Config (Marnie Theme)
------------------------------------------------------------------------
-- Old Theme | Marnie Theme
-- , bgColor           = "#282A2E"
-- , bgHLight          = "#ff2a54"
-- , fgHLight          = "#000000"
-- , borderColor       = "#ff2a54"

myXPConfig :: XPConfig
myXPConfig = def
    { font              = "xft:DejaVu Sans Mono:size=10"
    , bgColor           = "#1d1f21"
    , fgColor           = "#ffffff"
    , bgHLight          = "#ffbf2d"
    , fgHLight          = "#1d1f21"
    , borderColor       = "#ffbf2d"
    , promptBorderWidth = 2
    , position          = Top
    , height            = 24
    , historySize       = 0
    , defaultText       = ""
    }

------------------------------------------------------------------------
-- Layouts
------------------------------------------------------------------------
--myLayout = avoidStruts $ spacingWithEdge 4 $
myLayout = smartBorders $ avoidStruts $ mkToggle (NBFULL ?? EOT) $ spacingWithEdge 4 $
           tabbed shrinkText myTabTheme |||
           spiral (6/7) |||
           --Tall 1 (3/100) (1/2) |||
           ResizableTall 1 (3/100) (1/2) [] |||
           Accordion |||
           noBorders Full
  where
     -- Spacing between windows (inner 4, outer 1 from i3 config)
     spacingWithEdge i = spacingRaw True (Border i i i i) True (Border i i i i) True

------------------------------------------------------------------------
-- Window rules
------------------------------------------------------------------------
myManageHook = composeAll
    [ className =? "discord"              --> doShift "2"
    , title =? "FLOAT_MP"                 --> doCenterFloat
    , title =? "Volume Control"           --> doFloat
    , isDialog                            --> doCenterFloat
    ]

------------------------------------------------------------------------
-- Startup hook
------------------------------------------------------------------------
myStartupHook = do
    setDefaultCursor xC_left_ptr
    spawnOnce "dex --autostart --environment xmonad"
    spawnOnce "xss-lock --transfer-sleep-lock -- i3lock --nofork &"
    spawnOnce "nm-applet &"
    spawnOnce "pkill picom"

    -- Monitor setup
    spawnOnce "xrandr --output HDMI-0 --primary --mode 1920x1080 --rate 144.00 --output DP-0 --mode 2560x1440 --right-of HDMI-0"

    -- Polybar
    spawnOnce "$HOME/.scripts/polybar.sh &"

    -- Wallpaper
    spawnOnce "sleep 1 && feh --bg-fill /home/puppy/Pictures/Wallpapers/dangeroooous_jungle_wp.png"

    -- Emacs Daemon
    spawnOnce "sleep 1 && nixmacs --fg-daemon"

    -- Mouse settings
    spawnOnce "xinput set-prop 'Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse' 'libinput Accel Profile Enabled' 0 1 0"
    spawnOnce "xinput set-prop 'Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse' 'libinput Accel Speed' 0.3"
    spawnOnce "xinput set-prop 'Mad Catz Global' 'libinput Accel Profile Enabled' 0 1 0"
    spawnOnce "xinput set-prop 'Mad Catz Global' 'libinput Accel Speed' 0.3"

    -- Other autostart programs
    spawnOnce "redshift -l 52.520008:13.404954 -t 4000:4000 &"
    spawnOnce "xrdb ~/.Xresources"
    spawnOnce "dunst &"

    -- Set WM name for Java apps
    setWMName "LG3D"

------------------------------------------------------------------------
-- Log hook (for Polybar integration)
------------------------------------------------------------------------
myLogHook = dynamicLogWithPP $ def
    { ppOutput = \x -> do
        -- Write layout info to a file that Polybar can read
        appendFile "/tmp/.xmonad-layout-log" (x ++ "\n")
    , ppCurrent = wrap "[" "]"  -- Current workspace
    , ppLayout = id  -- Just show the layout name as-is
    , ppSep = " | "
    , ppOrder = \(ws:l:t:_) -> [l]  -- Only output layout name
    }

------------------------------------------------------------------------
-- Key bindings
------------------------------------------------------------------------
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- Launch terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((myWinMask .|. shiftMask, xK_Return), spawn "term rc")

    -- Launch dmenu (Loji theme)
    , ((modm, xK_t), spawn "dmenu_run -nb '#282A2E' -nf '#c13f47' -sf '#272A2E' -sb '#c13f47' -fn 'DejaVu Sans Mono:size=18' -p 'Open: '")

    -- Close focused window
    , ((modm .|. shiftMask, xK_q), kill)

    -- Rotate through the available layout algorithms
    , ((modm, xK_space), sendMessage NextLayout)

    -- Move focus
    , ((modm, xK_Left ), windows W.focusUp    )
    , ((modm, xK_Right), windows W.focusDown  )
    , ((modm, xK_Up   ), windows W.focusUp    )
    , ((modm, xK_Down ), windows W.focusDown  )

    -- Move windows (Alt+Shift+Arrow Keys)
    , ((modm .|. shiftMask, xK_Left ), windows W.swapUp    )
    , ((modm .|. shiftMask, xK_Right), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_Up   ), sendMessage Expand  )
    , ((modm .|. shiftMask, xK_Down ), sendMessage Shrink  )

    -- Shrink/expand the master area
    , ((modm, xK_h), sendMessage Shrink)
    , ((modm, xK_v), sendMessage Expand)

    -- Resize with Ctrl+Alt+Arrow keys (more intuitive)
    , ((modm .|. controlMask, xK_Left), sendMessage Shrink)
    , ((modm .|. controlMask, xK_Right), sendMessage Expand)
    , ((modm .|. controlMask, xK_Up), sendMessage Shrink)
    , ((modm .|. controlMask, xK_Down), sendMessage Expand)

    -- Increment/decrement number of windows in master area
    , ((modm, xK_comma), sendMessage (IncMasterN 1))    -- Add one more window to master
    , ((modm, xK_period), sendMessage (IncMasterN (-1))) -- Remove one window from master

    -- Quick workspace switching (toggle between current and previous)
    , ((modm, xK_Tab), toggleWS)

    -- Push window back into tiling
    , ((modm .|. shiftMask, xK_space), withFocused $ windows . W.sink)

    -- Toggle floating/tiled (Alt+Shift+Space to float, same keybind to sink back)
    -- If already floating, it will tile. If tiled, it will float centered.
    , ((modm .|. shiftMask, xK_space), withFocused toggleFloat)

    -- Toggle fullscreen (removes bars and makes window fullscreen)
    , ((modm .|. shiftMask, xK_t), sendMessage ToggleStruts >> sendMessage (Toggle NBFULL))

    -- Layout switching (matching i3 config)
    , ((modm, xK_r), sendMessage $ JumpToLayout "Accordion")  -- Stacking
    , ((modm, xK_u), sendMessage $ JumpToLayout "Tabbed")  -- Tabbed
    , ((modm, xK_y), sendMessage NextLayout)  -- Toggle layouts

    -- Programs
    , ((modm .|. shiftMask, xK_f), spawn "nixmacs")
    , ((modm .|. controlMask, xK_f), spawn "kitty emacsclient -c")
    , ((myWinMask .|. shiftMask, xK_f), spawn "acme")
    , ((modm .|. shiftMask, xK_s), spawn "microsoft-edge")
    , ((modm, xK_s), spawn "firefox")
    , ((modm, xK_a), spawn "flameshot gui")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_e), confirmPrompt myXPConfig "Type 'yes' to exit:" $ io (exitWith ExitSuccess))
    , ((myWinMask .|. shiftMask, xK_x), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_p), spawn "notify-send 'XMonad' 'Recompiling...' -i /home/puppy/Pictures/xmonad_logo.png; xmonad --recompile; xmonad --restart; notify-send 'XMonad' 'Restarted Successfully!' -i /home/puppy/Pictures/xmonad_logo.png")

    -- Reload xmonad
    , ((modm .|. shiftMask, xK_c), spawn "notify-send 'XMonad' 'Recompiling...' -i /home/puppy/Pictures/xmonad_logo.png; xmonad --recompile; xmonad --restart; notify-send 'XMonad' 'Restarted Successfully!' -i /home/puppy/Pictures/xmonad_logo.png")
    ]
    ++

    -- WinMod (Super key) bindings
    [ ((myWinMask, xK_l), spawn "betterlockscreen --lock")
    , ((myWinMask, xK_e), spawn "nautilus")
    , ((myWinMask, xK_period), spawn "rofimoji")
    , ((myWinMask, xK_t), spawn "rofi -show drun")
    , ((myWinMask, xK_v), spawn "/home/puppy/.scripts/viewScreenshot.sh")

    -- Move Cursor
    , ((myWinMask, xK_Left), warpToScreen 0 0.5 0.5)  -- Main screen (center)
    , ((myWinMask, xK_Right), warpToScreen 1 0.5 0.5)  -- Second screen (center)

    -- Resize
    , ((myWinMask, xK_Up), sendMessage MirrorExpand)
    , ((myWinMask, xK_Down), sendMessage MirrorShrink)

    -- Screensaver controls
    , ((myWinMask, xK_1), spawn "xset s off -dpms s noblank && notify-send 'Screensaver' 'Turned OFF.' -i /home/puppy/Pictures/no.png")
    , ((myWinMask, xK_2), spawn "xset s on +dpms s blank && notify-send 'Screensaver' 'Turned ON.' -i /home/puppy/Pictures/yes.png")
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Helper functions
------------------------------------------------------------------------
-- Toggle float: if window is floating, sink it; if tiled, float it centered
toggleFloat w = windows (\s -> if M.member w (W.floating s)
                    then W.sink w s
                    else (W.float w (W.RationalRect 0.15 0.15 0.7 0.7) s))

------------------------------------------------------------------------
-- Mouse bindings
------------------------------------------------------------------------
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

------------------------------------------------------------------------
-- Main
------------------------------------------------------------------------
main = xmonad
     . ewmhFullscreen
     . ewmh
     . docks
     $ def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = True,
        clickJustFocuses   = False,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = handleEventHook def,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
