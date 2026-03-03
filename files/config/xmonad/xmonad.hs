--
-- Librepup's XMonad Configuration
--

------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------
-- Basics
import XMonad
import Data.Monoid
import Data.List (intercalate)
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
-- Control
import Control.Monad (when)
-- X11
import Graphics.X11.Xlib (warpPointer)
import Graphics.X11.Xlib.Extras (none, getWindowAttributes, wa_width, wa_height)

------------------------------------------------------------------------
-- Define Data Types, Themes, and Presets
------------------------------------------------------------------------
-- Toggle Float
toggleFloat w = windows (\s -> if M.member w (W.floating s)
                          then
                            W.sink w s
                          else
                            (W.float w (W.RationalRect 0.15 0.15 0.7 0.7) s))
-- Warp to Window
doWarp :: ManageHook
doWarp = ask >>= \w -> liftX $ do
  dpy <- asks display
  wa <- io $ getWindowAttributes dpy w
  let cx = fromIntegral (wa_width wa) `div` 2
      cy = fromIntegral (wa_height wa) `div` 2
  io $ warpPointer dpy none w 0 0 0 0 cx cy
  return mempty
-- Conditional Device Commands
spawnIfAnyDevice :: [String] -> String -> X ()
spawnIfAnyDevice devNames cmd = spawnOnce $
    "if xinput list --name-only | grep -qE '" ++ devRegex ++ "'; then " ++ cmd ++ "; fi"
  where
    devRegex = intercalate "|" devNames
-- Prompt/XP Theme(s)
marnieXPConfig = def
    { font              = "xft:DejaVu Sans Mono:size=10"
    , bgColor           = "#282A2E"
    , fgColor           = "#ffffff"
    , bgHLight          = "#ff2a54"
    , fgHLight          = "#000000"
    , borderColor       = "#ff2a54"
    , promptBorderWidth = 2
    , position          = Top
    , height            = 24
    , historySize       = 0
    , defaultText       = "yes"
    }
jungleXPConfig = def
    { font              = "xft:TempleOS:size=8"
    , bgColor           = "#1d1f21"
    , fgColor           = "#ffffff"
    , bgHLight          = "#ffbf2d"
    , fgHLight          = "#1d1f21"
    , borderColor       = "#ffbf2d"
    , promptBorderWidth = 2
    , position          = Top
    , height            = 24
    , historySize       = 0
    , defaultText       = "yes"
    }
-- Tab Theme(s)
marnieTabTheme = def
    { activeColor         = "#ff2a54"
    , inactiveColor       = "#282A2E"
    , activeBorderColor   = "#ff2a54"
    , inactiveBorderColor = "#282A2E"
    , urgentBorderColor   = "#ff0000"
    , activeTextColor     = "#000000"
    , inactiveTextColor   = "#888888"
    , urgentTextColor     = "#ffffff"
    , fontName            = "xft:DejaVu Sans Mono:size=10"
    , decoHeight          = 14
    }
jungleTabTheme = def
    { activeColor         = "#ffbf2d"
    , inactiveColor       = "#1d1f21"
    , urgentColor         = "#ff0000"
    , activeBorderColor   = "#ffbf2d"
    , inactiveBorderColor = "#1d1f21"
    , urgentBorderColor   = "#ff0000"
    , activeTextColor     = "#000000"
    , inactiveTextColor   = "#888888"
    , urgentTextColor     = "#ffffff"
    , fontName            = "xft:TempleOS:size=8"
    , decoHeight          = 14
    }
-- Colorscheme(s)
data ColorScheme = ColorScheme
    { focused :: String
    , normal :: String
    }
marnieColorscheme = ColorScheme
    { focused = "#ff2a54"
    , normal  = "#1d1f21"
    }
jungleColorscheme = ColorScheme
    { focused = "#ffbf2d"
    , normal  = "#1d1f21"
    }
-- Dmenu Theme(s)
data DmenuTheme = DmenuTheme
    { normalBackground :: String
    , normalForeground :: String
    , selectedBackground :: String
    , selectedForeground :: String
    , selectedFont :: String
    }
marnieDmenuTheme = DmenuTheme
    { normalBackground   = "#282A2E"
    , normalForeground   = "#c13f47"
    , selectedBackground = "#c13f47"
    , selectedForeground = "#272A2E"
    , selectedFont       = "DejaVu Sans Mono:size=18"
    }
jungleDmenuTheme = DmenuTheme
    { normalBackground   = "#0A0A05"
    , normalForeground   = "#D4921A"
    , selectedBackground = "#C23FAD"
    , selectedForeground = "#4CBF5A"
    , selectedFont       = "TempleOS:size=14"
    }
dmenuArgs :: DmenuTheme -> String
dmenuArgs t = " -nb '" ++ normalBackground t ++
            "' -nf '" ++ normalForeground t ++
            "' -sb '" ++ selectedBackground t ++
            "' -sf '" ++ selectedForeground t ++
            "' -fn '" ++ selectedFont t ++ "'"

------------------------------------------------------------------------
-- General
------------------------------------------------------------------------
-- Variables
myModMask       = mod1Mask  -- Alt Key (mod1)
myWinMask       = mod4Mask  -- Windows/Super Key (mod4)
myTerminal      = "kitty"   -- Terminal Emulator (Default: kitty)
myBorderWidth   = 2         -- Border Width

-- Window Manager Theme
(myFocusedBorderColor, myNormalBorderColor) = (focused c, normal c)
  where c = jungleColorscheme

------------------------------------------------------------------------
-- Workspaces
------------------------------------------------------------------------
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]

------------------------------------------------------------------------
-- Tab Config
------------------------------------------------------------------------
-- Theme
myTabTheme = jungleTabTheme

------------------------------------------------------------------------
-- Prompt Config
------------------------------------------------------------------------
-- Theme
myXPConfig :: XPConfig
myXPConfig = jungleXPConfig

------------------------------------------------------------------------
-- Layouts
------------------------------------------------------------------------
myLayout = smartBorders $ avoidStruts $ mkToggle (NBFULL ?? EOT) $ spacingWithEdge 4 $
           tabbed shrinkText myTabTheme |||
           ResizableTall 1 (3/100) (1/2) [] |||
           spiral (6/7) |||
           Accordion |||
           noBorders Full
  where
     spacingWithEdge i = spacingRaw True (Border i i i i) True (Border i i i i) True

------------------------------------------------------------------------
-- Window Rules
------------------------------------------------------------------------
myManageHook = composeAll
    [ className =? "discord"              --> doShift "2"          -- Move "discord" and "vesktop" to Workspace 2.
    , className =? "vesktop"              --> doShift "2"          -- ...
    , title =? "FLOAT_MP"                 --> doCenterFloat        -- Float and Center Windows where Title equals "FLOAT_MP".
    , title =? "Volume Control"           --> doFloat              -- Float Windows where Title equals "Volume Control".
    , isDialog                            --> doCenterFloat        -- Float and Center Dialog Windows.
    , title =? "emote"                    --> (doFocus <+> doWarp) -- Focus and Warp Mouse to "emote" Window.
    , className =? "emote"                --> (doFocus <+> doWarp) -- ...
    , title =? "vicinae"                  --> (doFocus <+> doWarp) -- Focus and Warp Mouse to "vicinae" Window.
    , className =? "vicinae"              --> (doFocus <+> doWarp) -- ...
    , title =? "FLOAT_ME_NOW"             --> doRectFloat (W.RationalRect 0.15 0.1 0.7 0.8)
    ]

------------------------------------------------------------------------
-- Startup Hook
------------------------------------------------------------------------
myStartupHook = do
    -- Set Default Cursor
    setDefaultCursor xC_left_ptr
    -- Set Environment to XMonad
    spawnOnce "if command -v dex > /dev/null; then dex --autostart --environment xmonad; fi"
    -- Transfer XSS Lock to Betterlockscreen
    spawnOnce "if command -v xss-lock > /dev/null; then xss-lock --transfer-sleep-lock -- betterlockscreen --lock blur --span --time-format %H:%M:%S --show-layout & fi"
    -- Start NetworkManager Applet
    spawnOnce "if command -v nm-applet > /dev/null; then nm-applet & fi"
    -- Kill Picom
    spawnOnce "pkill picom"

    -- Monitor Setup
    spawnOnce "xrandr --output HDMI-0 --primary --mode 1920x1080 --rate 144.00 --output DP-0 --mode 2560x1440 --right-of HDMI-0"

    -- Polybar
    spawnOnce "pkill polybar; if type xrandr > /dev/null; then for m in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do MONITOR=$m polybar --reload example & done; else polybar --reload example & fi"

    -- Mouse Settings
    let myMice = ["Mad Catz Global", "Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse"]
    spawnIfAnyDevice myMice "xinput set-prop 'Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse' 'libinput Accel Profile Enabled' 0 1 0"
    spawnIfAnyDevice myMice "xinput set-prop 'Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse' 'libinput Accel Speed' 0.3"
    spawnIfAnyDevice myMice "xinput set-prop 'Mad Catz Global' 'libinput Accel Profile Enabled' 0 1 0"
    spawnIfAnyDevice myMice "xinput set-prop 'Mad Catz Global' 'libinput Accel Speed' 0.3"

    -- Various Autostart Programs
    spawnOnce "sleep 1 && if command -v emote > /dev/null; then emote & fi"
    -- Set Wallpaper
    spawnOnce "sleep 1 && feh --bg-fill /home/puppy/Pictures/Wallpapers/dangeroooous_jungle_wp.png"
    -- Start NixMacs or Emacs Daemon
    spawnOnce "sleep 1 && if command -v nixmacs > /dev/null; then nixmacs --fg-daemon; else emacs --fg-daemon; fi"
    -- Start Bluelight Filter
    spawnOnce "redshift -l 52.520008:13.404954 -t 4000:4000 &"
    -- Source Xresources
    spawnOnce "xrdb ~/.Xresources"
    -- Start Dunst Notification Daemon
    spawnOnce "dunst &"
    -- Set WM Name for Java Applications
    setWMName "LG3D"

------------------------------------------------------------------------
-- Log Hook
------------------------------------------------------------------------
myLogHook = dynamicLogWithPP $ def
    { ppOutput = \x -> do
        -- Write Layout Information to File for Polybar to Read.
        appendFile "/tmp/.xmonad-layout-log" (x ++ "\n")
    , ppCurrent = wrap "[" "]"                           -- Current Workspace
    , ppLayout = id                                      -- Just show the Layout Name as-is.
    , ppSep = " | "
    , ppOrder = \(ws:l:t:_) -> [l]                       -- Only output Layout Name.
    }

------------------------------------------------------------------------
-- Key Binds
------------------------------------------------------------------------
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- Terminals
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((myWinMask .|. shiftMask, xK_Return), spawn "term rc")
    -- Dmenu
    , ((modm, xK_t), spawn $ "dmenu_run" ++ dmenuArgs jungleDmenuTheme ++ " -p '%:'")
    -- Kill Window
    , ((modm .|. shiftMask, xK_q), kill)
    -- Cycle Layouts
    , ((modm, xK_space), sendMessage NextLayout)
    -- Focus Windows
    , ((modm, xK_Left ), windows W.focusUp    )
    , ((modm, xK_Right), windows W.focusDown  )
    , ((modm, xK_Up   ), windows W.focusUp    )
    , ((modm, xK_Down ), windows W.focusDown  )
    -- Move Windows
    , ((modm .|. shiftMask, xK_Left ), windows W.swapUp    )
    , ((modm .|. shiftMask, xK_Right), windows W.swapDown  )
    , ((modm .|. shiftMask, xK_Up   ), sendMessage Expand  )
    , ((modm .|. shiftMask, xK_Down ), sendMessage Shrink  )
    -- Shrink or Expand Master Area
    , ((modm, xK_h), sendMessage Shrink)
    , ((modm, xK_v), sendMessage Expand)
    -- Resize Windows
    , ((modm .|. controlMask, xK_Left), sendMessage Shrink)
    , ((modm .|. controlMask, xK_Right), sendMessage Expand)
    , ((modm .|. controlMask, xK_Up), sendMessage MirrorExpand)
    , ((modm .|. controlMask, xK_Down), sendMessage MirrorShrink)
    -- Increment or Decrement Windows in Master Stack
    , ((modm, xK_comma), sendMessage (IncMasterN 1))
    , ((modm, xK_period), sendMessage (IncMasterN (-1)))
    -- Switch between Current and Previous Workspace
    , ((modm, xK_Tab), toggleWS)
    -- Toggle Floating
    , ((modm .|. shiftMask, xK_space), withFocused toggleFloat)
    -- Toggle Fullscreen
    , ((modm .|. shiftMask, xK_t), sendMessage ToggleStruts >> sendMessage (Toggle NBFULL))
    -- Switch Layouts
    , ((modm, xK_r), sendMessage $ JumpToLayout "Accordion")
    , ((modm, xK_u), sendMessage $ JumpToLayout "Tabbed")
    , ((modm, xK_y), sendMessage NextLayout)
    -- Applications
    , ((modm .|. shiftMask, xK_f), spawn "nixmacs")
    , ((modm .|. controlMask, xK_f), spawn "kitty emacsclient -c")
    , ((myWinMask .|. shiftMask, xK_f), spawn "acme")
    , ((modm .|. shiftMask, xK_s), spawn "microsoft-edge")
    , ((modm, xK_s), spawn "firefox")
    , ((modm, xK_a), spawn "flameshot gui")
    , ((modm, xK_d), spawn "icedove")
    -- Exit XMonad
    , ((modm .|. shiftMask, xK_e), confirmPrompt myXPConfig "Type 'yes' to exit:" $ io (exitWith ExitSuccess))
    , ((myWinMask .|. shiftMask, xK_x), io (exitWith ExitSuccess))
    -- Restart XMonad
    , ((modm .|. shiftMask, xK_p), spawn "notify-send 'XMonad' 'Recompiling...' -i /home/puppy/Pictures/xmonad_logo.png; xmonad --recompile; xmonad --restart; notify-send 'XMonad' 'Restarted Successfully!' -i /home/puppy/Pictures/xmonad_logo.png")
    -- Reload XMonad
    , ((modm .|. shiftMask, xK_c), spawn "notify-send 'XMonad' 'Recompiling...' -i /home/puppy/Pictures/xmonad_logo.png; xmonad --recompile; xmonad --restart; notify-send 'XMonad' 'Restarted Successfully!' -i /home/puppy/Pictures/xmonad_logo.png")
    ]
    ++
    -- WinMod (Super key) Bindings
    [ ((myWinMask, xK_l), spawn "betterlockscreen --lock")
    , ((myWinMask, xK_e), spawn "nautilus")
    , ((myWinMask, xK_t), spawn "vicinae open")
    , ((myWinMask .|. shiftMask, xK_t), spawn "compgen -c | sort -u | vicinae dmenu --placeholder '%:' | sh")
    , ((myWinMask, xK_period), spawn "emote")
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
    -- Switch Workspaces
    -- Mod-[1..9] - Switch to Workspace N | Mod-Shift-[1..9] - Move Window to Workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

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
        terminal           = myTerminal,
        focusFollowsMouse  = True,
        clickJustFocuses   = False,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageHook def,
        handleEventHook    = handleEventHook def,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
