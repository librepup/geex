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
import Data.Char (isSpace)
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Control.Monad
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
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Simplest
import XMonad.Layout.Minimize
import XMonad.Layout.TwoPane
import XMonad.Layout.Grid
import XMonad.Layout.CircleEx
import qualified XMonad.Layout.BoringWindows as BW
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
import XMonad.Util.NamedActions
import XMonad.Util.Cursor (setDefaultCursor)
-- Actions
import XMonad.Actions.FloatKeys
import XMonad.Actions.WithAll
import XMonad.Actions.CycleWS
import XMonad.Actions.Warp
import XMonad.Actions.MouseResize
import XMonad.Actions.WithAll (sinkAll)
import XMonad.Actions.Minimize
import qualified XMonad.Actions.Search as S
import XMonad.Actions.Submap (submap, submapDefault)
import XMonad.Actions.ShowText
import XMonad.Actions.PhysicalScreens
-- X11
import Graphics.X11.Xlib (xC_left_ptr)
import Graphics.X11.Xlib (warpPointer)
import Graphics.X11.Xlib.Extras (none, getWindowAttributes, wa_width, wa_height)
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt

------------------------------------------------------------------------
-- Definitions
------------------------------------------------------------------------
-- Move and Follow to Screen
moveAndFollow :: ScreenId -> X ()
moveAndFollow sc = do
  screenWorkspace sc >>= flip whenJust (\w ->
    windows (W.view w . W.shift w))
  warpToScreen sc 0.5 0.5
-- Trim Helper
trimWS :: String -> String
trimWS = reverse . dropWhile isSpace . reverse . dropWhile isSpace
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
-- FlashText Theme(s)
jungleFlashTheme = def
    { st_font             = "xft:TempleOS:size=8"
    , st_bg               = "#1d1f21"
    , st_fg               = "#ffbf2d"
    }
marnieFlashTheme = def
    { st_font             = "xft:DejaVu Sans Mono:size=10"
    , st_bg               = "#1d1f21"
    , st_fg               = "#ff2a54"
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
-- Settings
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]
myModMask       = mod1Mask  -- Alt Key (mod1)
myWinMask       = mod4Mask  -- Windows/Super Key (mod4)
myTerminal      = "kitty"   -- Terminal Emulator
myBorderWidth   = 2         -- Border Width

------------------------------------------------------------------------
-- Themes
------------------------------------------------------------------------
-- General
(myFocusedBorderColor, myNormalBorderColor) = (focused c, normal c)
  where c = jungleColorscheme
-- FlashText
myFlashTheme = jungleFlashTheme
-- Tabs
myTabTheme = jungleTabTheme
-- Prompts
myXPConfig :: XPConfig
myXPConfig = jungleXPConfig

------------------------------------------------------------------------
-- Layouts
------------------------------------------------------------------------
myLayoutHook = smartBorders
             $ avoidStruts
             $ mkToggle (NBFULL ?? EOT)
             -- Tabbed
             $ minimize (tabbed shrinkText myTabTheme)
             -- Tall + Tabbed Sub-Layout
             ||| (windowNavigation
                 $ addTabs shrinkText myTabTheme
                 $ subLayout [] Simplest
                 $ BW.boringWindows
                 $ minimize
                 $ spacingWithEdge 4
                 $ ResizableTall 1 (3/100) (1/2) []
                 )
             -- Spiral
             ||| spacingWithEdge 4 (minimize $ spiral (6/7))
             -- Accordion
             ||| spacingWithEdge 4 (minimize $ Accordion)
             -- Circle
             ||| spacingWithEdge 4 (minimize $ circle)
             -- Fullscreen
             ||| noBorders Full
  where
    spacingWithEdge i = spacingRaw True (Border i i i i) True (Border i i i i) True

------------------------------------------------------------------------
-- Window Rules
------------------------------------------------------------------------
myManageHook = composeAll
    [ className =? "discord"              --> doShift "2"          -- Move "discord" and "vesktop" to Workspace 2.
    , className =? "vesktop"              --> doShift "2"          -- ...
    , title =? "FLOAT_MP"                 --> doCenterFloat        -- Float and Center Windows where Title equals "FLOAT_MP".
    , title =? "Volume Control"           --> doFloat              -- Float Volume Control Windows.
    , title =? "Lautstärkeregler"         --> doFloat              -- ...
    , isDialog                            --> doCenterFloat        -- Float and Center Dialog Windows.
    , title =? "emote"                    --> (doFocus <+> doWarp) -- Focus and Warp Mouse to "emote" Window.
    , className =? "emote"                --> (doFocus <+> doWarp) -- ...
    , title =? "vicinae"                  --> (doFocus <+> doWarp) -- Focus and Warp Mouse to "vicinae" Window.
    , className =? "vicinae"              --> (doFocus <+> doWarp) -- ...
    , title =? "FLOAT_ME_NOW"             --> doRectFloat (W.RationalRect 0.15 0.1 0.7 0.8)
    , title =? "FLOATING_HELP_SCREEN"     --> doRectFloat (W.RationalRect 0.275 0.1 0.485 0.75)
    , title =? "Library"                  --> doCenterFloat
    ]

------------------------------------------------------------------------
-- Autostart
------------------------------------------------------------------------
myAutostart :: X ()
myAutostart = do
    -- Monitor
    spawnOnce $
      "xrandr" ++
          " --output HDMI-0" ++
          " --primary" ++
          " --mode 1920x1080" ++
          " --rate 144.00" ++
        " --output DP-0" ++
          " --mode 2560x1440" ++
          " --right-of HDMI-0"
    -- Mouse
    let myMice = ["Mad Catz Global", "Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse"]
    forM_ myMice $ \mouse -> do
      spawnOnce $
        "if xinput list --name-only | grep -q '" ++ mouse ++ "'; then " ++
        "xinput set-prop " ++
          "'" ++ mouse ++ "' 'libinput Accel Profile Enabled' 0 1 0; " ++
        "xinput set-prop " ++
          "'" ++ mouse ++ "' 'libinput Accel Speed' 0.3; " ++
        "fi"
    -- XMonad Environment
    spawnOnce $
      "if command -v dex > /dev/null; then" ++
        " dex --autostart --environment xmonad;" ++
      " fi"
    -- BetterLockscreen XSS Lock
    spawnOnce $
      "if command -v xss-lock > /dev/null; then" ++
        " xss-lock --transfer-sleep-lock -- betterlockscreen --lock blur --span --time-format %H:%M:%S --show-layout &" ++
      " fi"
    -- NetworkManager Applet
    spawnOnce $
      "if command -v nm-applet > /dev/null; then" ++
        " nm-applet &" ++
      " fi"
    -- Kill Picom
    spawnOnce $
      "if pgrep picom > /dev/null; then" ++
        " pkill -9 picom;" ++
       " fi; " ++
       "if command -v picom > /dev/null; then " ++
         "picom & " ++
       "fi"
    -- Polybar
    spawnOnce $
      "if pgrep polybar > /dev/null; then pkill polybar; fi;" ++
      "if command -v geex-bar > /dev/null; then" ++
        " geex-bar &" ++
      " else" ++
        " if type xrandr > /dev/null; then" ++
          " for m in $(xrandr --query | grep ' connected' | cut -d' ' -f1); do" ++
            " MONITOR=$m polybar --reload main &" ++
          " done;" ++
        " else" ++
          " polybar --reload main &" ++
        " fi;" ++
      " fi;"
    -- Emote
    spawnOnce $
      "if pgrep emote > /dev/null; then" ++
        " pkill emote;" ++
      " fi;" ++
      " sleep 1 && if command -v emote > /dev/null; then" ++
        " emote &"++
      " fi"
    -- Wallpaper
    spawnOnce $
      "sleep 1 && if command -v feh > /dev/null; then" ++
        " feh --bg-fill $HOME/Pictures/Wallpapers/dangeroooous_jungle_wp.png;" ++
      " fi"
    -- NixMacs or Emacs Daemon
    spawnOnce $
      "if emacsclient -e \"(emacs-pid)\" > /dev/null; then" ++
        " emacsclient -e \"(kill-emacs)\";" ++
      " fi;" ++
      " sleep 1 && if command -v nixmacs > /dev/null; then" ++
        " nixmacs --fg-daemon &" ++
      " elif command -v emacs > /dev/null; then" ++
        " emacs --fg-daemon &" ++
      " else" ++
        " if command -v notify-send > /dev/null; then" ++
          " notify-send 'Emacs' 'Neither NixMacs nor Emacs Found';" ++
        " else" ++
          " echo 'Error: Neither NixMacs nor Emacs Found.';" ++
        " fi;" ++
      " fi"
    -- Disable Screensaver
    spawnOnce $
      "if command -v xset > /dev/null; then" ++
        " xset s off -dpms s noblank;" ++
      " else" ++
        " if command -v notify-send > /dev/null; then" ++
          " notify-send 'Screensaver' 'Error Disabling Screensaver';" ++
        " else" ++
          " echo 'Error: Could Not Disable Screensaver and Could Not Find Notification Command';" ++
        " fi;" ++
      " fi"
    -- Bluelight Filter
    spawnOnce $
      "if pgrep redshift > /dev/null; then" ++
        " pkill -9 redshift;" ++
      " fi;" ++
      " if command -v redshift > /dev/null; then" ++
        " redshift -x;" ++
        " redshift -l 52.520008:13.404954 -t 5200:5200 &" ++
      " else" ++
        " if command -v notify-send > /dev/null; then" ++
          " notify-send 'Error' 'Redshift Not Found';" ++
        " else" ++
          " echo 'Error: Redshift Not Found';" ++
        " fi;" ++
      " fi"
    -- Source Xresources
    spawnOnce $
      "if command -v xrdb > /dev/null; then" ++
        " xrdb ~/.Xresources;" ++
      " fi"
    -- Dunst Notification Daemon
    spawnOnce $
      "if pgrep dunst > /dev/null; then" ++
        " pkill dunst;" ++
      " fi;" ++
      " if command -v dunst > /dev/null; then" ++
        " dunst &" ++
      " fi"

------------------------------------------------------------------------
-- Startup Hook
------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
    -- Initialize ShowText
    flashText def 1 " "
    -- Set Default Cursor
    setDefaultCursor xC_left_ptr
    -- Autostart
    myAutostart
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
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask, xK_Return), spawn "kitty -o font_family=TempleOS -o font_size=12")
    , ((myWinMask .|. shiftMask, xK_Return), spawn "term rc")
    -- Dmenu
    , ((modm, xK_t), spawn $ -- Dmenu
        "dmenu_run" ++
        dmenuArgs jungleDmenuTheme ++
        " -p '%:'")
    -- Kill Window
    , ((modm .|. shiftMask, xK_q), kill)
    -- Help Screen
    , ((myWinMask, xK_h), spawn $
        "kitty " ++
          "-o initial_window_width=1040 " ++
          "-o initial_window_height=860 " ++
          "--title FLOATING_HELP_SCREEN " ++
          "-o font_family=TempleOS " ++
          "-o font_size=8 " ++
        "bash -c '" ++
          "center_block() { " ++
            "local width=$(tput cols); " ++
            "mapfile -t lines; " ++
            "local max=0; " ++
            "for l in \"${lines[@]}\"; do " ++
              "(( ${#l} > max )) && max=${#l}; " ++
            "done; " ++
            "local pad=$(( (width - max) / 2 )); " ++
            "(( pad < 0 )) && pad=0; " ++
            "for l in \"${lines[@]}\"; do " ++
              "printf \"%*s%s\n\" \"$pad\" \"\" \"$l\"; " ++
            "done " ++
            "}; " ++
          "cat <<\"EOF\" | center_block \n" ++
            "\nXMonad Help Screen\n==================\n\n" ++
            "Alt+Shift+Return -> Open Kitty Terminal\n" ++
            "Alt+Return -> Open Unchanged Kitty Terminal\n" ++
            "Win+Shift+Return -> Open 9term Terminal\n" ++
            "\nAlt+t -> Run DMenu\n" ++
            "\nAlt+Shift+q -> Kill Current Window\n" ++
            "\nAlt+Space -> Switch to Next Layout\n" ++
            "Alt+Left/Right/Up/Down -> Change Focused Window\n" ++
            "Alt+Shift+Left/Right -> Swap Window Positions\n" ++
            "Alt+Shift+Up/Down -> Shrink or Expand Stack\n" ++
            "\nAlt+Ctrl+Left/RIght -> Shrink or Expand Stack\n" ++
            "Alt+Ctrl+Up/Down -> Resize Stack Vertically\n" ++
            "Alt+Comma/Period -> Add or Remove Window to/from Master\n" ++
            "Alt+Tab -> Switch between Current and Previous Workspace\n" ++
            "\nAlt+Shift+Space -> Toggle Floating\n" ++
            "Alt+Shift+t -> Toggle Fullscreen\n" ++
            "\nAlt+Shift+f -> Open NixMacs\n" ++
            "Alt+Ctrl+f -> Open EmacsClient\n" ++
            "Win+Shift+f -> Open Acme Editor\n" ++
            "Alt+Shift+s -> Open Microsoft Edge\n" ++
            "Alt+s -> Open Firefox\n" ++
            "Alt+a -> Take Screenshot\n" ++
            "Alt+d -> Open IceDove\n" ++
            "\nAlt+Shift+e -> Exit XMonad with Confirm Prompt\n" ++
            "Win+Shift+x -> Force Quit XMonad\n\n" ++
            "Alt+Shift+p -> Restart XMonad\n" ++
            "Alt+Shift+c -> Reload XMonad\n\n" ++
            "Win+l -> Lock Screen\n" ++
            "Win+e -> Open File Explorer\n" ++
            "Win+t -> Open Vicinae\n" ++
            "Win+Shift+t -> Open Vicinae DMenu Run\n" ++
            "Win+Period -> Open Emoji Picker\n\n" ++
            "Win+Left/Right -> Switch Monitor Focus\n\n" ++
            "Win+1 -> Disable Screensaver\n" ++
            "Win+2 -> Enable Screensaver\n\n" ++
            "Alt+0..9 -> Switch to Workspace\n" ++
            "Alt+Shift+0..9 -> Move Window to Workspace\n\n" ++
            "Win+Ctrl+Up/Down/Left/Right -> Create Tabbed Stack with Window\n" ++
            "Win+Ctrl+u -> Unstack Window\n" ++
            "Win+Ctrl+Shift+u -> Unstall All Windows\n\n" ++
            "Win+i -> Minimize Window\n" ++
            "Win+Shift+i -> Un-Minimize Window\n\n" ++
            "Win+Space -> Open Interactive Web Search\n\n" ++
            "Win+w -> Copy Selected Text\n" ++
            "Win+y -> Paste from Clipboard\n" ++
          "EOF\n" ++
        "read -n 1 -s'")
    -- Cycle Layouts
    , ((modm, xK_space), sendMessage NextLayout)
    -- Focus Windows
    , ((modm, xK_Left ), windows W.focusUp)
    , ((modm, xK_Right), windows W.focusDown)
    , ((modm, xK_Up   ), windows W.focusUp)
    , ((modm, xK_Down ), windows W.focusDown)
    -- Move Windows
    , ((modm .|. shiftMask, xK_Left ), windows W.swapUp)
    , ((modm .|. shiftMask, xK_Right), windows W.swapDown)
    , ((modm .|. shiftMask, xK_Up   ), sendMessage Expand)
    , ((modm .|. shiftMask, xK_Down ), sendMessage Shrink)
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
    , ((modm .|. shiftMask, xK_p), spawn $
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'XMonad' 'Recompiling...' -i $HOME/Pictures/xmonad_logo.png; " ++
        "fi; " ++
        "xmonad --recompile; " ++
        "xmonad --restart; " ++
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'XMonad' 'Restarted Successfully!' -i $HOME/Pictures/xmonad_logo.png; " ++
        "fi;")
    -- Reload XMonad
    , ((modm .|. shiftMask, xK_c), spawn $
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'XMonad' 'Recompiling...' -i $HOME/Pictures/xmonad_logo.png; " ++
        "fi; " ++
        "xmonad --recompile; " ++
        "xmonad --restart; " ++
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'XMonad' 'Restarted Successfully!' -i $HOME/Pictures/xmonad_logo.png; " ++
        "fi;")
    -- Sub-Layout Tabbing
    , ((myWinMask .|. controlMask, xK_Left), sendMessage $ pullGroup L)
    , ((myWinMask .|. controlMask, xK_Right), sendMessage $ pullGroup R)
    , ((myWinMask .|. controlMask, xK_Up), sendMessage $ pullGroup U)
    , ((myWinMask .|. controlMask, xK_Down), sendMessage $ pullGroup D)
    , ((myWinMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    , ((myWinMask .|. controlMask .|. shiftMask, xK_u), withFocused (sendMessage . UnMergeAll))
    , ((myWinMask .|. controlMask, xK_Tab), onGroup W.focusDown')
    -- Minimize
    , ((myWinMask, xK_i), withFocused minimizeWindow)
    , ((myWinMask .|. shiftMask, xK_i), withLastMinimized maximizeWindowAndFocus)
    -- Search
    , ((myWinMask, xK_space), do
        choice <- runProcessWithInput "dmenu"
            [ "-nb", normalBackground jungleDmenuTheme
            , "-nf", normalForeground jungleDmenuTheme
            , "-sb", selectedBackground jungleDmenuTheme
            , "-sf", selectedForeground jungleDmenuTheme
            , "-fn", selectedFont jungleDmenuTheme
            , "-p", "Search:"
            ]
            "YT\nNix\nDuck\nGoogle\nImages\nMaps\nTwitter\n"
        case trimWS choice of
            "Google"     -> S.promptSearch myXPConfig S.google
            "Twitter"    -> S.promptSearch myXPConfig (S.searchEngine "twitter" "https://x.com/search?q=")
            "Duck"       -> S.promptSearch myXPConfig S.duckduckgo
            "YT"         -> S.promptSearch myXPConfig S.youtube
            "Images"     -> S.promptSearch myXPConfig S.images
            "Maps"       -> S.promptSearch myXPConfig S.maps
            "Nix"        -> S.promptSearch myXPConfig (S.searchEngine "nixpkgs" "https://search.nixos.org/packages?query=")
            _            -> return ()
        )
    ]
    ++
    -- WinMod (Super key) Bindings
    [ ((myWinMask, xK_l), spawn $
        "if command -v betterlockscreen > /dev/null; then " ++
          "betterlockscreen --lock; " ++
        "elif command -v i3lock > /dev/null; then " ++
          "i3lock -i $HOME/Pictures/Wallpapers/dangeroooous_jungle_wp.png --ignore-empty-password; " ++
        "else " ++
          "if command -v notify-send > /dev/null; then " ++
            "notify-send 'Error' 'No Lockscreen Found' -i $HOME/Pictures/error.png; " ++
          "fi; " ++
        "fi")
    , ((myWinMask, xK_e), spawn $
        "if command -v nautilus > /dev/null; then " ++
          "nautilus; " ++
        "elif command -v thunar > /dev/null; then " ++
          "thunar; " ++
        "else " ++
          "if command -v notify-send > /dev/null; then " ++
            "notify-send 'Error' 'No Explorer Application Found' -i $HOME/Pictures/error.png; " ++
          "fi; " ++
        "fi")
    , ((myWinMask, xK_t), spawn "vicinae open")
    , ((myWinMask .|. shiftMask, xK_t), spawn "compgen -c | sort -u | vicinae dmenu --placeholder '%:' | sh")
    , ((myWinMask, xK_period), spawn "emote")
    , ((myWinMask, xK_v), spawn $
      "if command -v pactl > /dev/null && command -v dmenu > /dev/null; then " ++
        "chosen=$(seq 0 5 150 | awk '{print $1 \"%\"}' | dmenu -nb '#0A0A05' -nf '#D4921A' -sf '#4CBF5A' -sb '#C23FAD' -fn 'TempleOS:size=14' -p '%:'); " ++
        "[ -n \"$chosen\" ] && pactl set-sink-volume @DEFAULT_SINK@ \"$chosen\"; " ++
      "elif command -v pavucontrol > /dev/null; then " ++
        "pavucontrol; " ++
      "else " ++
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'Error' 'No Volume Application Found' -i $HOME/Pictures/error.png; " ++
        "fi; " ++
      "fi")
    , ((myWinMask, xK_w), spawn $
        "if command -v xclip > /dev/null; then " ++
          "xclip -o selection primary | xclip -selection clipboard; " ++
        "fi")
    , ((myWinMask, xK_y), spawn $
        "if command -v xdotool > /dev/null && command -v xclip > /dev/null; then " ++
          "xdotool keyup Super_L Super_R; " ++
          "sleep 0.1; " ++
          "xclip -o -selection clipboard; " ++
          "xdotool key --clearmodifiers shift+Insert; " ++
        "fi")
    -- Move Cursor
    , ((myWinMask, xK_Left), warpToScreen 0 0.5 0.5)
    , ((myWinMask, xK_Right), warpToScreen 1 0.5 0.5)
    , ((myWinMask .|. shiftMask, xK_Right), screenBy 1 >>= moveAndFollow)
    , ((myWinMask .|. shiftMask, xK_Left), screenBy (-1) >>= moveAndFollow)
    -- Resize
    , ((myWinMask, xK_Up), sendMessage MirrorExpand)
    , ((myWinMask, xK_Down), sendMessage MirrorShrink)
    -- Screensaver controls
    , ((myWinMask, xK_1), spawn "xset s off -dpms s noblank && notify-send 'Screensaver' 'Turned OFF.' -i $HOME/Pictures/no.png")
    , ((myWinMask, xK_2), spawn "xset s on +dpms s blank && notify-send 'Screensaver' 'Turned ON.' -i $HOME/Pictures/yes.png")
    ]
    ++
    -- Switch Workspaces
    -- Mod-[1..9] - Switch to Workspace N | Mod-Shift-[1..9] - Move Window to Workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse Binds
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
        layoutHook         = myLayoutHook,
        manageHook         = myManageHook <+> manageHook def,
        handleEventHook    = handleEventHook def,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }
