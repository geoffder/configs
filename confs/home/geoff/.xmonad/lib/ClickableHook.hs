-----------------------------------------------------------------------------
-- |
-- Module : ClickableHook
--
-----------------------------------------------------------------------------
module ClickableHook ( clickableNames
                     , getSortByClickableIndex
                     , doClickableHook
                     , undoClickableHook
                     ) where

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.WorkspaceCompare

import Data.List
import Data.Function (on)

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

confWorkspaces :: X ([String])
confWorkspaces = asks (workspaces . config) 

-- confWorkspaces' :: [String]
-- confWorkspaces' = concat $ asks (workspaces . config) 

-- clickableNames :: [String]
-- clickableNames = 
--   [ "<action=xdotool key super+" ++ show i ++ ">" ++ (xmobarEscape ws) ++ "</action>"
--     | (i, ws) <- zip [1 :: Integer .. 9] confWorkspaces ]

clickableNames :: X ([String])
clickableNames = do
  spaces <- confWorkspaces
  return
    [ "<action=xdotool key super+" ++ show i ++ ">" ++ (xmobarEscape ws) ++ "</action>"
      | (i, ws) <- zip [1 :: Integer .. 9] spaces ]

-- | From XMonad.Util.WorkspaceCompare (not exported)
-- Compare Maybe's differently, so Nothing (i.e. workspaces without indexes)
-- come last in the order
indexCompare :: Maybe Int -> Maybe Int -> Ordering
indexCompare Nothing Nothing = EQ
indexCompare Nothing (Just _) = GT
indexCompare (Just _) Nothing = LT
indexCompare a b = compare a b

-- getClickableIndex :: X (WorkspaceId -> Maybe Int)
-- getClickableIndex = return $ flip elemIndex clickableNames
getClickableIndex :: X (WorkspaceId -> Maybe Int)
getClickableIndex = do
  names <- clickableNames
  return $ flip elemIndex names

getClickableCompare :: X WorkspaceCompare
getClickableCompare = do
  clickableSort <- getClickableIndex
  return $ mconcat [indexCompare `on` clickableSort, compare]

getSortByClickableIndex :: X WorkspaceSort
getSortByClickableIndex = mkWsSort getClickableCompare

-- doClickableHook :: X ()
-- doClickableHook = do
--   _ <- sequence
--        $ map (\(w, c) -> modifyWindowSet $ \s -> W.renameTag w c s)
--              (zip confWorkspaces clickableNames)
--   return ()

-- undoClickableHook :: X ()
-- undoClickableHook = do
--   _ <- sequence
--        $ map (\(w, c) -> modifyWindowSet $ \s -> W.renameTag c w s)
--              (zip confWorkspaces clickableNames)
--   return ()

doClickableHook :: X ()
doClickableHook = do
  spaces <- confWorkspaces
  names <- clickableNames
  _ <- sequence
       $ map (\(w, c) -> modifyWindowSet $ \s -> W.renameTag w c s)
             (zip spaces names)
  return ()

undoClickableHook :: X ()
undoClickableHook = do
  spaces <- confWorkspaces
  names <- clickableNames
  _ <- sequence
       $ map (\(w, c) -> modifyWindowSet $ \s -> W.renameTag c w s)
             (zip spaces names)
  return ()
