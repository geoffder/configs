-----------------------------------------------------------------------------
-- |
-- Module : ClickableHook
--
-- NOTE: requires `xdotool`
-----------------------------------------------------------------------------
module ClickableHook ( getSortByClickableIndex
                     , doClickableHook
                     , undoClickableHook
                     ) where

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.WorkspaceCompare

import Data.List
import Data.Function (on)

-- In case workspace tags include any '<', escape them
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

-- Get workspace tags from user config (e.g. myWorkspaces)
configWorkspaces :: X [String]
configWorkspaces = asks (workspaces . config) 

-- Wrap workspace tags with on-click switch action
clickableWorkspaces :: X [String]
clickableWorkspaces = do
  spaces <- configWorkspaces
  return
    [ "<action=xdotool key super+" ++ show i ++ ">"
      ++ (xmobarEscape ws)
      ++ "</action>"
    | (i, ws) <- zip [1 :: Integer .. 9] spaces ]

-- | From XMonad.Util.WorkspaceCompare (not exported)
-- Compare Maybe's differently, so Nothing (i.e. workspaces without indexes)
-- come last in the order
indexCompare :: Maybe Int -> Maybe Int -> Ordering
indexCompare Nothing Nothing = EQ
indexCompare Nothing (Just _) = GT
indexCompare (Just _) Nothing = LT
indexCompare a b = compare a b

getClickableIndex :: X (WorkspaceId -> Maybe Int)
getClickableIndex = do
  clicks <- clickableWorkspaces
  return $ flip elemIndex clicks

getClickableCompare :: X WorkspaceCompare
getClickableCompare = do
  clickableSort <- getClickableIndex
  return $ mconcat [indexCompare `on` clickableSort, compare]

-- Sort workspaces by index of clickableWorkpaces (for ppSort)
getSortByClickableIndex :: X WorkspaceSort
getSortByClickableIndex = mkWsSort getClickableCompare

doClickableHook :: X ()
doClickableHook = do
  spaces <- configWorkspaces
  clicks <- clickableWorkspaces
  _ <- sequence
       $ map (\(w, c) -> modifyWindowSet $ \s -> W.renameTag w c s)
             (zip spaces clicks)
  return ()

undoClickableHook :: X ()
undoClickableHook = do
  spaces <- configWorkspaces
  clicks <- clickableWorkspaces
  _ <- sequence
       $ map (\(w, c) -> modifyWindowSet $ \s -> W.renameTag c w s)
             (zip spaces clicks)
  return ()
