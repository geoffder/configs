{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import System.IO (hPutStrLn)
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Actions
-- import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
-- import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
-- import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
-- import XMonad.Actions.Promote
-- import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
-- import qualified XMonad.Actions.TreeSelect as TS
-- import XMonad.Actions.WindowGo (runOrRaise)
-- import XMonad.Actions.WithAll (sinkAll, killAll)
-- import qualified XMonad.Actions.Search as S

-- Data
-- import Data.Char (isSpace)
-- import Data.Monoid
-- import Data.Maybe (isJust)
-- import Data.Tree
-- import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
-- import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
-- import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
-- import XMonad.Hooks.ServerMode
-- import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

-- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
-- Do I want/need these? (more dt layout mod imports)
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
-- import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
-- import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- Utilities
import XMonad.Util.SpawnOnce
import XMonad.Util.Run (spawnPipe)

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: [Char]
myTerminal = "kitty"

terminalExec :: [Char] -> [Char]
terminalExec command = myTerminal ++ " -e " ++ command

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth :: Dimension
myBorderWidth = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces :: [[Char]]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor :: [Char]
myNormalBorderColor  = "#422773"
myFocusedBorderColor :: [Char]
myFocusedBorderColor = "#6623df"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch rofi (drun)
    , ((modm,               xK_space ), spawn "rofi -show drun")
    
    -- launch firefox
    , ((modm .|. shiftMask, xK_Return), spawn "firefox")

    -- launch emacs
    , ((modm,               xK_e     ), spawn "emacs")

    -- launch nvim
    , ((modm,               xK_v     ), spawn $ terminalExec "nvim")

    -- launch ranger
    , ((modm,               xK_o     ), spawn $ terminalExec "ranger")

    -- launch htop
    , ((modm .|. shiftMask, xK_o     ), spawn $ terminalExec "htop")

    -- launch pcmanfm
    , ((modm,               xK_p     ), spawn "pcmanfm")

    -- launch flameshot
    , ((modm .|. shiftMask, xK_s     ), spawn "flameshot gui")

    -- launch riot
    , ((modm,              xK_i      ), spawn "riot-desktop")

    -- launch discord
    , ((modm .|. mod1Mask, xK_d      ), spawn "discord")

    -- close focused window
    , ((modm .|. shiftMask, xK_q     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_Tab   ), sendMessage NextLayout)
    

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Down  ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_Up     ), windows W.focusUp  )

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_m     ), windows W.swapMaster   )

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_Down  ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_Up    ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Shrink share of slave area
    , ((modm .|. shiftMask, xK_h     ), sendMessage MirrorShrink)

    -- Expand share of slave area
    , ((modm .|. shiftMask, xK_l     ), sendMessage MirrorExpand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm,               xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm,               xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_e     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_F1, xK_F2, xK_F3] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ()) 
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- Makes setting the spacingRaw simpler to write. The spacingRaw
-- module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []

monocle  = renamed [Replace "monocle"]
           $ limitWindows 20 Full

grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)

spirals  = renamed [Replace "spirals"]
           $ mySpacing' 8
           $ spiral (6/7)

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Roboto:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout = tall
                      ||| noBorders monocle
                      ||| grid
                      ||| spirals

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "trayer"         --> doIgnore
    , resource  =? "trayer"         --> doIgnore
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook :: Event -> X All
myEventHook = docksEventHook


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook :: X ()
myLogHook = return ()

theLogHook xmproc = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
            { ppOutput = \x -> hPutStrLn xmproc x
            , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
            , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
            , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
            , ppHiddenNoWindows = xmobarColor "#b3afc2" ""        -- Hidden workspaces (no windows)
            , ppTitle = xmobarColor "#ffffff" "" . shorten 60     -- Title of active window in xmobar
            , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
            , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
            , ppExtras  = [windowCount]                           -- # of windows current workspace
            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
            }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook :: X ()
myStartupHook = do
  spawnOnce "nitrogen --restore &"
  spawnOnce "sleep 1 && picom -b &"
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
  spawnOnce "xfce4-power-manager &"
  spawnOnce "clipit &"
  spawnOnce "flameshot &"
  spawnOnce "nm-applet &"
  spawnOnce "volumeicon &"
  spawnOnce "blueman-applet &"
  spawnOnce "redshift-gtk -t 6500:4000 &"
  spawnOnce "xautolock -time 10 -locker blurlock &"
  spawnOnce $ "trayer --edge top --align right --widthtype request "
              ++ "--padding 6 --SetDockType true --SetPartialStrut true "
              ++ "--expand true --transparent true --alpha 127 "
              ++ "--tint 0x99222222 --height 24 &"
  -- spawnOnce "xsetroot -cursor_name Bibata_Classic"
  -- spawnOnce "/usr/bin/emacs --daemon &"
  -- setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
  xmob <- spawnPipe "xmobar /home/geoff/.config/xmobar/xmobarrc"
  xmonad $ defaults xmob

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
-- defaults :: XConfig (Choose Tall (Choose (Mirror Tall) Full))
defaults xmproc = def
  { terminal           = myTerminal
  , focusFollowsMouse  = myFocusFollowsMouse
  , clickJustFocuses   = myClickJustFocuses
  , borderWidth        = myBorderWidth
  , modMask            = myModMask
  , workspaces         = myWorkspaces
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor

  -- key bindings
  , keys               = myKeys
  , mouseBindings      = myMouseBindings

  -- hooks, layouts
  , layoutHook         = myLayoutHook
  , manageHook         = myManageHook
  , handleEventHook    = myEventHook
  , logHook            = theLogHook xmproc
  , startupHook        = myStartupHook
  }

