import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicBars as Bars
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import qualified XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86
import qualified Data.Map        as M
--import Control.Monad.Trans
--import System.FilePath
--import System.Directory
--import XMonad.Util.WorkspaceScreenshot

supoTerminal = "urxvt"
supoDmenuFg = "'#d8d8d8'"
supoDmenuBg = "'#111111'"
supoDmenuFont = "'-*-lucida-bold-*-*-*-34-*-*-*-*-*-*-*'"

supoDmenuCmd =
  unwords [ "dmenu_run"
    , "-nb"
    , supoDmenuBg
    , "-nf"
    , supoDmenuFg
    , "-sf"
    , "'#000000'"
    , "-fn"
    , supoDmenuFont
  ]

supoNormalBorderColor  = "#7c7c7c"
supoFocusedBorderColor = "#eeb0b6"

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"
-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"
barCreator :: Bars.DynamicStatusBar
barCreator (S sid) = spawnPipe $ "xmobar --screen " ++ show sid

barDestroyer :: Bars.DynamicStatusBarCleanup
barDestroyer = return ()

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig =
  defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
  }

-- Width of the window border in pixels.

supoBorderWidth = 0


------------------------------------------------------------------------
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
 
--supoModMask = mod4Mask
--supoKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
--  -- Start a terminal.  Terminal to start is specified by supoTerminal variable.
--  [ ((modMask .|. shiftMask, xK_Return),
--     spawn $ XMonad.terminal conf)
----
----  , ((modMask .|. controlMask, xK_t),
----     spawn "configure-thunderbolt-display")
----
----  , ((modMask .|. controlMask, xK_d),
----     spawn "configure-laptop-display")
----
----  -- Lock the screen using slimlock.
--  , ((modMask .|. controlMask, xK_l),
--     spawn "slimlock")
----
----  -- Use this to launch programs without a key binding.
----  , ((modMask, xK_space),
----     spawn supoDmenuCmd)
----
---
----  -- Mission Control
----  , ((0, xK_F4),
----    spawn "slimlock")
----
--  --------------------------------------------------------------------
--  -- "Standard" xmonad key bindings
--  --
--
--  -- Cycle through the available layout algorithms.
----  , ((modMask, xK_p),
----    sendMessage NextLayout)
--
--  --  Reset the layouts on the current workspace to default.
--  , ((modMask .|. shiftMask, xK_space),
--    setLayout $ XMonad.layoutHook conf)
--
--  -- Resize viewed windows to the correct size.
--  , ((modMask, xK_n),
--    refresh)
--
--  -- Move focus to the next window.
--  , ((modMask, xK_Tab),
--    windows W.focusDown)
--
--  -- Move focus to the next window.
--  , ((modMask, xK_j),
--    windows W.focusDown)
--
--  -- Move focus to the previous window.
--  , ((modMask, xK_k),
--    windows W.focusUp  )
--
--  -- Move focus to the master window.
--  , ((modMask, xK_m),
--    windows W.focusMaster  )
--
--  -- Swap the focused window and the master window.
--  , ((modMask, xK_Return),
--    windows W.swapMaster)
--
--  -- Swap the focused window with the next window.
--  , ((modMask .|. shiftMask, xK_j),
--    windows W.swapDown  )
--
--  -- Swap the focused window with the previous window.
--  , ((modMask .|. shiftMask, xK_k),
--    windows W.swapUp    )
--
--  -- Shrink the master area.
--  , ((modMask, xK_h),
--    sendMessage Shrink)
--
--  -- Expand the master area.
--  , ((modMask, xK_l),
--    sendMessage Expand)
--
--  -- Increment the number of windows in the master area.
--  , ((modMask, xK_comma),
--    sendMessage (IncMasterN 1))
--
--  -- Decrement the number of windows in the master area.
--  , ((modMask, xK_period),
--    sendMessage (IncMasterN (-1)))
--
--  -- Quit xmonad.
--  , ((modMask .|. shiftMask, xK_q),
--    io exitSuccess)
--
--  -- Take screenshot
--  , ((modMask .|. shiftMask, xK_u),
--    spawn "screenshot-workspace | xargs imgur-upload | xargs firefox -new-tab")
--
--  -- Restart xmonad.
--  , ((modMask, xK_q),
--    restart "xmonad" True)
--  ]
--  ++
--
--  -- mod-[1..9], Switch to workspace N
--  -- mod-shift-[1..9], Move client to workspace N
--  [((m .|. modMask, k), windows $ f i)
--      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
--      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
--  ++
--
--  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
--  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
--  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
--      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
--      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
--

------------------------------------------------------------------------
-- Mouse bindings
--
-- Why would anyone set this to True? Ugh.
supoFocusFollowsMouse :: Bool
supoFocusFollowsMouse = False

supoMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1),
     (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2),
       (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3),
       (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
supoStartupHook = do
  spawnOnce "stalonetray"


------------------------------------------------------------------------
-- Screenshot hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--supoScreenshotHook fp = do
--  hd <- getHomeDirectory
--  renameFile fp (hd </> "Pictures" </> fp)

--macKeys conf@(XConfig {XMonad.modMask = mod4Mask}) = M.fromList $
  
------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
defaults = defaultConfig
  {
    -- simple stuff
    terminal           = supoTerminal,
    focusFollowsMouse  = supoFocusFollowsMouse,
    borderWidth        = supoBorderWidth,
    modMask            = mod4Mask,
--    workspaces         = supoWorkspaces,
    normalBorderColor  = supoNormalBorderColor,
    focusedBorderColor = supoFocusedBorderColor,

    -- key bindings
    --keys               = supoKeys,
    mouseBindings      = supoMouseBindings,

    -- hooks, layouts
 --   layoutHook         = smartBorders $ supoLayout,
--    manageHook         = supoManageHook,
    startupHook        = supoStartupHook
  } `additionalKeys` 
  -- Fn key labeled with mute/unmute symbol
  [  ((0, xK_F8),
     spawn "amixer -q set Master toggle")

  -- Fn key labeled with volume decrease
  , ((0, xK_F9),
     spawn "amixer -q set Master 5%-")

  -- Fn key labeled with volume increase
  , ((0, xK_F10),
     spawn "amixer -q set Master 5%+")
--
--  -- Put contents from primary selection into X selection
--  , ((modMask .|. shiftMask, xK_b), spawn "xsel -op | xsel -ib")
--
  -- Decrement brightness
  , ((0, xK_F5),
    spawn "xbacklight -dec 10")

  -- Increment brightness
  , ((0, xK_F6),
    spawn "xbacklight -inc 10")

  -- lock screen
  , ((mod1Mask .|. controlMask, xK_l),
    spawn "slock")
  ]

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad =<< dzen defaults {
      manageHook = manageDocks -- <+> supoManageHook
    , startupHook = do setWMName "LG3D"
                       Bars.dynStatusBarStartup barCreator barDestroyer
  }
