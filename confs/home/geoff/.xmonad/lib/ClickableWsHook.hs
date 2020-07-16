-----------------------------------------------------------------------------
-- |
-- Module : ClickableHook
-- Copyright : Geoff deRosenroll ( github.com/geoffder )
--
-- NOTE: requires `xdotool` on system and use of UnsafeStdinReader in xmobar.
--
-- Wrap doClickableWsHook and undoClickableWsHook around dynamicLogWithPP in the
-- LogHook, so workspace names are wrapped with clickable action tags only for
-- the moment that they are piped into XMobar.
--
-- In order for maintain sorting of workspaces on the status bar, set
-- { ppSort = getSortByClickableIndex } in xmobarPP.
--
-- e.g.
-- myLogHook xmproc = ... <+> doClickableHook <+> dynamicLogWithPP xmobarPP
--   { ...
--   , ppSort = getSortByClickableIndex
--   } <+> undoClickableHook
-----------------------------------------------------------------------------
module ClickableWsHook ( doClickableWsHook
                       , undoClickableWsHook
                       , getClickableSortByWsTag
                       , getSortByClickableIndex
                       ) where

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.WorkspaceCompare

import Data.List
import Data.Function (on)
import qualified Data.Map as M

-- In case workspace tags include any '<', escape them
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
    doubleLts '<' = "<<"
    doubleLts x   = [x]

clickableWrap :: (Integer, String) -> String
clickableWrap (num, ws) =
  "<action=xdotool key super+" ++ show num ++ ">"
  ++ xmobarEscape ws ++ "</action>"

-- Get workspace tags from user config (e.g. myWorkspaces)
configWorkspaces :: X [WorkspaceId]
configWorkspaces = asks (workspaces . config) 

-- Wrap workspace tags with on-click switch action
clickableWorkspaces :: X [WorkspaceId]
clickableWorkspaces =
  configWorkspaces >>= \ws ->
    return $ map clickableWrap $ zip [1 :: Integer .. 9] ws

-- | From XMonad.Util.WorkspaceCompare (not exported)
-- Compare Maybe's differently, so Nothing (i.e. workspaces without indexes)
-- come last in the order
indexCompare :: Maybe Int -> Maybe Int -> Ordering
indexCompare Nothing Nothing = EQ
indexCompare Nothing (Just _) = GT
indexCompare (Just _) Nothing = LT
indexCompare a b = compare a b

getClickableIndex :: X (WorkspaceId -> Maybe Int)
getClickableIndex =
  clickableWorkspaces >>= \ws -> return $ flip elemIndex ws

getClickableCompare :: X WorkspaceCompare
getClickableCompare =
  getClickableIndex >>= \idx ->
    return $ mconcat [indexCompare `on` idx, compare]

-- Sort workspaces by index of clickableWorkpaces (for ppSort)
getSortByClickableIndex :: X WorkspaceSort
getSortByClickableIndex = mkWsSort getClickableCompare

getWsTagFromClickable :: X (WorkspaceId -> Maybe String)
getWsTagFromClickable = do
  spaces <- configWorkspaces
  clicks <- clickableWorkspaces
  return $ flip M.lookup $ M.fromList $ zip clicks spaces

getClickableCompareByWsTag :: X WorkspaceCompare
getClickableCompareByWsTag =
  getWsTagFromClickable >>= \tag -> return (compare `on` tag)

-- Sort workspaces by original names from config (for ppSort)
getClickableSortByWsTag :: X WorkspaceSort
getClickableSortByWsTag = mkWsSort getClickableCompareByWsTag

doClickableWsHook :: X ()
doClickableWsHook = do
  spaces <- configWorkspaces
  clicks <- clickableWorkspaces
  _ <- mapM (\(w, c) -> modifyWindowSet $ \s -> W.renameTag w c s)
       $ zip spaces clicks
  return ()

undoClickableWsHook :: X ()
undoClickableWsHook = do
  spaces <- configWorkspaces
  clicks <- clickableWorkspaces
  _ <- mapM (\(w, c) -> modifyWindowSet $ \s -> W.renameTag c w s)
       $ zip spaces clicks
  return ()
