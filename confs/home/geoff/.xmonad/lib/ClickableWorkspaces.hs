-------------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Util.ClickableWorkspaces
-- Copyright   :  (c) Geoff deRosenroll <geoffderosenroll@gmail.com>
-- License     :  BSD3-style (see LICENSE)
--
-- Maintainer  :  Geoff deRosenroll <geoffderosenroll@gmail.com>
-- Stability   :  unstable
-- Portability :  unportable
--
-----------------------------------------------------------------------------

module ClickableWorkspaces (
  -- $usage
  clickablePP
  ) where

import XMonad
import XMonad.Util.WorkspaceCompare (getWsIndex)
import XMonad.Hooks.DynamicLog (PP(..))

-- TODO: write usage block. 
-- $usage
-- Wrapping workspace tags with on-click xdotool actions (requires
-- xdotool in path). Also remember to replace StdinReader with
-- UnsafeStdinReader in your XMobar config to allow for these action tags.

-- In case workspace tags include any '<', escape them
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
    doubleLts '<' = "<<"
    doubleLts x   = [x]

clickableWrap :: Integer -> String -> String
clickableWrap num ws =
  "<action=xdotool key super+" ++ show num ++ ">" ++ xmobarEscape ws ++ "</action>"

getClickable :: X (WorkspaceId -> String)
getClickable = do
  wsIndex <- getWsIndex
  return $ \ws -> case wsIndex ws of
                    Just idx -> clickableWrap (indexToKey idx) ws
                    Nothing -> ws
  where indexToKey = (+ 1) . toInteger
  
clickablePP :: PP -> X PP
clickablePP pp = do
  clickable <- getClickable
  return $
    pp { ppCurrent         = ppCurrent pp . clickable
       , ppVisible         = ppVisible pp . clickable
       , ppHidden          = ppHidden pp . clickable
       , ppHiddenNoWindows = ppHiddenNoWindows pp . clickable
       , ppUrgent          = ppUrgent pp . clickable
       }
