{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
--
-- xmonad example config file.
--

import XMonad
import Data.Monoid
import System.IO (hPutStrLn)
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Actions
-- import XMonad.Actions.CopyWindow (kill1, killAllOtherCopies)
-- import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
-- import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
-- import qualified XMonad.Actions.TreeSelect as TS
-- import XMonad.Actions.WindowGo (runOrRaise)
-- import XMonad.Actions.WithAll (sinkAll, killAll)
-- import qualified XMonad.Actions.Search as S

-- Data
-- import Data.Char (isSpace)
-- import Data.List
-- import Data.Monoid
-- import Data.Maybe (isJust)
-- import Data.Tree
-- import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

-- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
-- Do I want/need these? (more dt layout mod imports)
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.WindowArranger (windowArrange)
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- Prompts
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
-- import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
-- import XMonad.Prompt.Man
-- import XMonad.Prompt.Pass
-- import XMonad.Prompt.Shell (shellPrompt)
-- import XMonad.Prompt.Ssh
-- import XMonad.Prompt.XMonad
-- import Control.Arrow (first)

-- Utilities
import XMonad.Util.EZConfig (mkKeymap)
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
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth :: Dimension
myBorderWidth = 3

myFont :: [Char]
myFont = "xft:Roboto:bold:size=40"

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
-- Using mkKeymap from XMonad.Util.EZConfig to allow Emacs like configuration. 
--
myKeys = \c -> mkKeymap c $
  [ ("M-<Return>",   spawn myTerminal)
  , ("M-<Space>",    spawn "rofi -show drun")
  , ("M-S-<Return>", spawn "firefox")
  , (("M-e"),        spawn "emacsclient -c -a emacs")
  , (("M-v"),        spawn $ terminalExec "nvim")
  , (("M-o"),        spawn $ terminalExec "ranger")
  , (("M-S-o"),      spawn $ terminalExec "htop")
  , (("M-p"),        spawn "pcmanfm")
  , (("M-S-s"),      spawn "flameshot gui")
  , (("M-i"),        spawn "riot-desktop")
  , (("M-M1-d"),     spawn "discord")

  , ("M-S-q",        kill)                            -- close focused window
  , ("M-<Tab>",      sendMessage NextLayout)          -- rotate window layout
  , ("M-<Down>",     windows W.focusDown)             -- focus next window
  , ("M-<Up>",       windows W.focusUp)               -- focus previous window
  , ("M-j",          windows W.focusDown)             -- focus next window
  , ("M-k",          windows W.focusUp)               -- focus previous window
  , ("M-m",          windows W.focusMaster)           -- focus on master
  , ("M-S-m",        windows W.swapMaster)            -- swap focused with master
  , ("M-S-<Down>",   windows W.swapDown)              -- swap focused with next window
  , ("M-S-<Up>",     windows W.swapUp)                -- swap focused with previous window
  , ("M-S-j",        windows W.swapDown)              -- swap focused with next window
  , ("M-S-k",        windows W.swapUp)                -- swap focused with previous window
  , ("M1-S-<Tab>",   rotSlavesDown)                   -- rotate slaves (keep focus)
  , ("M1-C-<Tab>",   rotAllDown)                      -- rotate all windows (keep focus)

  , ("M-h",          sendMessage Shrink)              -- shrink the master area
  , ("M-l",          sendMessage Expand)              -- expand the master area
  , ("M-S-h",        sendMessage MirrorShrink)        -- shrink share of slave area
  , ("M-S-l",        sendMessage MirrorExpand)        -- expand share of slave area
  , ("M-t",          withFocused $ windows . W.sink)  -- push window back into tiling
  , ("M-,",          sendMessage (IncMasterN 1))      -- incr # of windows in master area
  , ("M-.",          sendMessage (IncMasterN (-1)))   -- decr # of windows in master area
  , ("M-f",          sendMessage (MT.Toggle NBFULL)
                     >> sendMessage ToggleStruts)     -- toggle fullscreen

  , ("M-S-r",        spawn "xmonad --recompile; xmonad --restart")
  , ("M-S-e",        confirmPrompt myXPConfig "exit" $ io (exitWith ExitSuccess))
  ]
  ++
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [("M-" ++ m ++ (show k), windows $ f i)
      | (i, k) <- zip myWorkspaces [1 :: Integer .. 9]
      , (f, m) <- [(W.greedyView, ""), (W.shift, "S-")]]
  ++
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [("M-" ++ m ++ k, screenWorkspace sc >>= flip whenJust (windows . f))
      | (k, sc) <- zip ["<F1>", "<F2>", "<F3>"] [0..]
      , (f, m) <- [(W.view, ""), (W.shift, "S-")]]
  
  ----------------------------------------------------------------------
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
-- XPROMPT SETTINGS
myXPConfig :: XPConfig
myXPConfig = def
               { font                = myFont
               , bgColor             = "#292d3e"
               , fgColor             = "#d0d0d0"
               , bgHLight            = "#c792ea"
               , fgHLight            = "#000000"
               , borderColor         = "#535974"
               , promptBorderWidth   = 0
               -- , promptKeymap        = dtXPKeymap
               -- , position            = Top
               , position            = CenteredAt { xpCenterY = 0.4, xpWidth = 0.4 }
               , height              = 100
               , historySize         = 256
               , historyFilter       = id
               , defaultText         = []
               , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
               , showCompletionOnTab = False
               -- , searchPredicate     = isPrefixOf
               , searchPredicate     = fuzzyMatch
               , alwaysHighlight     = True
               , maxComplRows        = Nothing      -- set to Just 5 for 5 rows
               }

------------------------------------------------------------------------
-- Layouts:

-- Makes setting the spacingRaw simpler to write. The spacingRaw
-- module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 ( 3 / 100 ) ( 1 / 2 ) []

magnify  = renamed [Replace "magnify"]
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 ( 3 / 100 ) ( 1 / 2 ) []

monocle  = renamed [Replace "monocle"]
           $ limitWindows 20 Full

grid     = renamed [Replace "grid"]
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid ( 16 / 10 )

spirals  = renamed [Replace "spirals"]
           $ spiral ( 6 / 7 )

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:firacode:bold:size=30"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#292d3e"
    , swn_color             = "#d0d0d0"
    }

-- The layout hook
myLayoutHook = showWName' myShowWNameTheme $ avoidStruts $ mouseResize $ windowArrange $
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout = tall
                      -- ||| magnify
                      ||| noBorders monocle
                      -- ||| grid
                      -- ||| spirals

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

-- Maybe use to be able to target instance names (first in WM_CLASS)
-- contains a str | length str < length a = False
--                | length str == length a = str == a
--                | a == "" || str == "" = False
--                | take (length a) str == a = True
--                | otherwise = contains a (tail str)
               
myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
    [ className =? "MPlayer"               --> doFloat
    , className =? "Gimp"                  --> doFloat
    , className =? "Nitrogen"              --> doFloat
    , className =? "Lightdm-settings"      --> doFloat
    , className =? "Pavucontrol"           --> doFloat
    , className =? "NEURON"                --> doFloat
    , className =? "matplotlib"            --> doFloat
    , className =? " " <||> appName =? " " --> doFloat  -- matplotlib hack
    , className =? "Viewnior"              --> doFloat
    , className =? "Gnome-calculator"      --> doFloat
    , title     =? "StimGen 5.0"           --> doFloat
    , className =? "trayer"                --> doIgnore
    , resource  =? "trayer"                --> doIgnore
    , resource  =? "desktop_window"        --> doIgnore
    , resource  =? "kdesktop"              --> doIgnore ]
  where
    wm_name = stringProperty "WM_NAME"

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
              ++ "--padding 0 --SetDockType true --SetPartialStrut true "
              ++ "--expand true --transparent true --alpha 127 "
              ++ "--tint 0x292d3e00 --height 24 &"
  spawnOnce "/usr/bin/emacs --daemon &"
  setWMName "LG3D"  -- may be useful for making some Java GUIs work.

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
  xmob <- spawnPipe "xmobar /home/geoff/.config/xmobar/xmobarrc"
  xmonad $ ewmh $ defaults xmob

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
  , manageHook         = myManageHook <+> manageDocks
  , handleEventHook    = myEventHook
  , logHook            = theLogHook xmproc
  , startupHook        = myStartupHook
  }

