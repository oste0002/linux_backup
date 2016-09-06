import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.Place               -- place floats at appropriate positions
import XMonad.Hooks.FadeWindows         -- transparency
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Util.Run(spawnPipe)       -- statusbar
import XMonad.Util.EZConfig             -- keybinds
import XMonad.Util.WorkspaceCompare     -- for xinerama physical screen placement

import XMonad.Layout.MagicFocus
import XMonad.Layout.IM                 -- for gimp layout
import XMonad.Layout.Reflect
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.Gaps               -- gaps
import XMonad.Layout.Renamed            -- modify layout names
import XMonad.Layout.Minimize           -- minimization
import XMonad.Layout.BoringWindows      -- used to prevent minimized windows from being focused
import XMonad.Layout.NoBorders          -- modify borders
import XMonad.Layout.Spacing            -- spaces between windows

import qualified XMonad.Layout.Magnifier as Mag --magnifier

import XMonad.Actions.CycleWS           -- toggle workspace
import XMonad.Actions.SpawnOn           -- spawn on specific workspace
-- import XMonad.Actions.PhysicalScreens

import qualified XMonad.StackSet as W

import System.IO
import System.Exit


main = do
    status     <- spawnPipe myDzenStatus
    network    <- spawnPipe myDzenNetwork
    conky      <- spawnPipe myDzenConky
    -- status2    <- spawnPipe myDzenStatus2
    -- network2   <- spawnPipe myDzenNetwork2
    -- conky2     <- spawnPipe myDzenConky2
    xmonad $ ewmh defaultConfig
        { manageHook         =  manageSpawn <+> manageDocks <+> myManageHook
                                <+> manageHook defaultConfig
        , workspaces         = myWorkspaces
        -- , logHook            = myLogHook status <+> myLogHook status2 <+> fadeWindowsLogHook myFadeHook
        , logHook            = myLogHook status <+> fadeWindowsLogHook myFadeHook
        , layoutHook         = avoidStruts (boringWindows(gaps [(L,0),(R,0)] (layoutHook')))
        , handleEventHook    = fadeWindowsEventHook <+> followEventHook <+> fullscreenEventHook
        , focusFollowsMouse  = True
        , focusedBorderColor = "#000000"
        , normalBorderColor  = "#000000"
        , modMask            = mod4Mask
        , borderWidth        = 0
        , startupHook        = myStartupHook
        , terminal           = myTerminal
        }
        `additionalKeysP`    myKeys
        `additionalKeys`     myKeys'

-- Hotkeys
spotify command = spawn ("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player." ++ command)

-- Dzen
myLogHook h   = dynamicLogWithPP $ myDzenPP { ppOutput = hPutStrLn h }
myDzenStatus  = "dzen2 -x '0' -w '725' -ta 'l'" ++ myDzenStyle
myDzenNetwork = "conky -c ~/.config/conky/networkconkyrc | dzen2 -x '725' -w '455' -ta 'c'" ++ myDzenStyle
myDzenConky   = "conky -c ~/.config/conky/conkyrc | dzen2 -x '1180' -w '644' -ta 'r'" ++ myDzenStyle
-- myDzenStatus2  = "dzen2 -x '1920' -w '1140' -ta 'l'" ++ myDzenStyle
-- myDzenNetwork2 = "conky -c ~/.config/conky/networkconkyrc | dzen2 -x '3060' -w '290' -ta 'c'" ++ myDzenStyle
-- myDzenConky2   = "conky -c ~/.config/conky/conkyrc | dzen2 -x '3350' -w '490' -ta 'c'" ++ myDzenStyle

myDzenStyle   = " -h '18' -y '0' -fn Inconsolata-12:antialias=true:hinting=false -bg '#000000' -fg '#777777' -o 85 -e 'onstart=lower'"
-- myDzenStyle   = " -h '18' -y '0' -fn xft:Incosolata:size=10:antialias=true:hinting=false -bg '#111111' -fg '#777777' -e 'onstart=lower'"
-- myDzenStyle   = " -h '18' -y '0' -fn -misc-inconsolata-*-*-*-*-*-*-*-*-*-*-iso8859-2 -bg '#111111' -fg '#777777' -o 80 -e 'onstart=lower'"


myDzenPP = dzenPP
    { --ppCurrent = dzenColor "#3E5EB5" "" . wrap " " " "
    ppHidden  = dzenColor "#aaaaaa" "" . wrap "" " "
    --, ppHiddenNoWindows = dzenColor "#666666" "" . wrap " " " "
    , ppUrgent  = dzenColor "#ff0000" "" . wrap " " " "
    , ppVisible = dzenColor "#EE9A00" "" . wrap "[" "] "
    -- , ppCurrent = dzenColor "#3E5EB5" ""  . wrap "[" "] "
    , ppCurrent = dzenColor "#647ec3" ""  . wrap "[" "] "
    , ppSort    = getSortByXineramaPhysicalRule
    , ppSep     = "  "
    , ppLayout  = \y -> " "
    , ppTitle   = dzenColor "#b3ccff" "" . wrap "^ca(1,/home/oskar/script/dzenPopup/tint2_popup.sh)" "                                                                                ^ca()"
    , ppOrder = (\(ws:_:t:_) -> [ws,t])
    }


-- Applications
myTerminal = "urxvt"


-- Startup
myStartupHook  = do
    setWMName "LG3D"
    spawn "compton --config /home/oskar/.config/compton/comptonrc"
    spawn "/home/oskar/script/wallpaper/wallpaperScript.sh"
    spawn "unclutter -noevents -grab -root -reset"
    -- spawn "skype"

-- Disable mouse follow on all but gimp workspace
followEventHook = followOnlyIf $ disableFollowOnWS allButLast2WS
    where allButLast2WS = init (init myWorkspaces)

-- Workspaces
myWorkspaces   = ["1","2","3","4","5","6","7","8","9","spot"]
layoutHook'    = onWorkspaces ["1"] normalLayout $
                 onWorkspaces ["2"] mailLayout $
                 onWorkspaces ["3","4","5","6","7","8"]  terminalLayout $
                 onWorkspaces ["9"] gimpLayout $
                 onWorkspaces ["spot"] spotifyLayout $
                 normalLayout

normalLayout   = renamed [CutWordsLeft 3] $
                 minimize $ smartSpacing 3 $ Mag.magnifiercz 1.35 $ smartSpacing 40 $ reflectHoriz $ tiled ||| reflectVert (Mirror tiled) ||| Full
  where          tiled = ResizableTall 1 (5/300) (65/100) []

mailLayout = renamed [CutWordsLeft 3] $
                 minimize $ smartSpacing 6 $ Mag.magnifiercz' 1 $ reflectHoriz $ tiled ||| Mirror tiled ||| Full
  where          tiled = ResizableTall 1 (5/300) (50/100) []

terminalLayout = renamed [CutWordsLeft 3] $
                 minimize $ smartSpacing 6 $ Mag.magnifiercz 1 $ reflectHoriz $ tiled ||| Mirror tiled ||| Full
  where          tiled = ResizableTall 1 (10/300) (50/100) []

gimpLayout     = renamed [CutWordsRight 5] $ minimize $ smartSpacing 2 $ withIM (0.11) (Role "gimp-toolbox") $ reflectHoriz $ withIM (0.15) (Role "gimp-dock") $ Full ||| tiled
  where          tiled = ResizableTall 2 (5/300) (50/100) [1,0.7]

spotifyLayout  = renamed [CutWordsLeft 3] $
                 minimize $ smartSpacing 6 $ Mag.magnifiercz 1.2 $ smartSpacing 40 $ reflectHoriz $ Full ||| tiled
  where          tiled = ResizableTall 1 (5/300) (70/100) [1,0.7]


-- Layout

-- Placement of floats
-- withGaps (top, right, bottom, left) forbidden areas from screen border in pixels
-- smart (x-pos, y-pos) prefered placement position in fraction of 1
myPlacement = withGaps (0, 0, 25, 0) $ smart (0.983,1)


-- Gimp boring windows
markBoring' :: Window -> X ()
markBoring' w = do
    -- st at XState { windowset = ws } <- get
    st @ XState { windowset = ws } <- get
    env <- ask
    (_,st') <- io $ runX env
                         st{ windowset = W.insertUp w ws }
                         markBoring
    put $ st{ windowset =
            ws{ W.current =
              (W.current ws){ W.workspace =
                (W.workspace $ W.current ws){ W.layout =
                               W.layout $ W.workspace
                             $ W.current $ windowset st'
              }}}}

doBoring :: ManageHook
doBoring = do
    w <- ask
    liftX $ markBoring' w
    idHook


myManageHook = composeAll
        [
          -- pcmanfm dialogs
          title =? "Save As" --> doCenterFloat
        , title =? "Preferences" --> doCenterFloat
        , title =? "Creating New Folder" --> doCenterFloat
        , title =? "Confirm" --> doCenterFloat
        , title =? "Confirm File Replacing" --> doCenterFloat
        , title =? "Rename File" --> doCenterFloat
        , title =? "Creating ..." --> doCenterFloat
        , title =? "File Properties" --> doCenterFloat
          -- file chooser dialogs
        , title =? "Open File" --> doCenterFloat
        , title =? "Save File" --> doCenterFloat
          -- gimp
        , role =? "gimp-toolbox" --> doBoring
        , role =? "gimp-dock" --> doBoring
        , role =? "gimp-toolbox-color-dialog" --> doCenterFloat
          -- applications
        , className =? "feh" --> doFloat
        , className =? "Nm-connection-editor" --> doFloat
        , className =? "Insync.py" --> (doRectFloat $ W.RationalRect 0.7815 0.018 0.2190 0.462)
        , className =? "Pcmanfm" --> insertPosition End Older
        , title =? "qiv" --> doCenterFloat
        , className =? "Comsollauncher" --> doCenterFloat
        , className =? "Thunderbird" --> insertPosition End Newer
        , className =? "Gimp" --> unfloat
        , className =? "Arandr" --> (doRectFloat $ W.RationalRect 0.37 0.35 0.26 0.3)
        , className =? "Pavucontrol" --> insertPosition End Newer
          -- matlab
        , title =? "Figure 1" --> insertPosition End Older
        , title =? "Figure 2" --> insertPosition End Older
        , title =? "Figure 3" --> insertPosition End Older
        , title =? "Figure 4" --> insertPosition End Older
        , title =? "Figure 5" --> insertPosition End Older
        ]
  where unfloat = ask >>= doF . W.sink
        role = stringProperty "WM_WINDOW_ROLE"


-- Transparancy
myFadeHook = composeAll
        [ opaque
        , isUnfocused --> transparency 0.2
        , className =? "Chromium" <&&> isUnfocused --> transparency 0.2
        , className =? "URxvt" <&&> isUnfocused --> transparency 0.16
        , className =? "Skype" <&&> isUnfocused --> transparency 0.2
        , className =? "MuPDF" <&&> isUnfocused --> transparency 0.1
        , className =? "Okular" <&&> isUnfocused --> transparency 0.1
        , className =? "Zathura" <&&> isUnfocused --> transparency 0.1
        , className =? "TexMaker" <&&> isUnfocused --> transparency 0.1
        , className =? "Thunderbird" <&&> isUnfocused --> transparency 0.1
        , className =? "MPlayer" <&&> isUnfocused --> transparency 0
        , className =? "Gimp-2.8" <&&> isUnfocused --> transparency 0
        , className =? "Gimp" <&&> isUnfocused --> transparency 0
        , className =? "Pdfpc" <&&> isUnfocused --> transparency 0
          -- matlab
        , title =? "MATLAB R2014a" <&&> isUnfocused --> transparency 0.15
        , title =? "Figure 1" <&&> isUnfocused --> transparency 0.2
        , title =? "Figure 2" <&&> isUnfocused --> transparency 0.2
        , title =? "Figure 3" <&&> isUnfocused --> transparency 0.2
        , title =? "Figure 4" <&&> isUnfocused --> transparency 0.2
        , title =? "Figure 5" <&&> isUnfocused --> transparency 0.2
        ]

myKeys = [
  ("M-S-z",        spawn "/home/oskar/script/monitor/slimlock.sh")
 ,("M-C-z",        spawn "slimlock & sleep 1 ; xset dpms force off")
 ,("M-C-x",        spawn "slimlock & sleep 0.2 ; systemctl suspend")
 ,("M-C-p",        spawn "/home/oskar/script/shutdown/shutdown.sh")
 ,("M5-S-p",       spawn "/home/oskar/script/shutdown/shutdown.sh")
 ,("M-m",          withFocused minimizeWindow)
 ,("M-v",          sendMessage Mag.Toggle)
 ,("M-b",          sendMessage Mag.MagnifyLess)
 ,("M-n",          sendMessage Mag.MagnifyMore)
 ,("M-S-m",        sendMessage RestoreNextMinimizedWin)
 ,("M-g",          nextScreen)
 ,("M-S-g",        shiftNextScreen)
 ,("M-f",          swapNextScreen)
 ,("M-d",          moveTo Next EmptyWS)
 ,("M-S-d",        shiftTo Next EmptyWS)
 ,("M-<Tab>",      moveTo Next NonEmptyWS)
 ,("M-q",          spawn "pkill conky ; pkill tint2 ; pkill unclutter ; pkill compton ; xmonad --recompile ; xmonad --restart")
 ,("M-S-q",        spawn "pkill conky ; pkill tint2 ;pkill unclutter ; pkill compton ; /home/oskar/script/terminate/terminate.sh ; sleep 5" >> io (exitWith ExitSuccess))
 ,("M-u",          sendMessage MirrorExpand >> sendMessage MirrorExpand >> sendMessage MirrorExpand >> sendMessage MirrorExpand >> sendMessage MirrorExpand)
 ,("M-y",          sendMessage MirrorShrink >> sendMessage MirrorShrink >> sendMessage MirrorShrink >> sendMessage MirrorShrink >> sendMessage MirrorShrink)
 --,("M-l",          sendMessage Shrink)
 --,("M-h",          sendMessage Expand)
 ,("M-l",          sendMessage Shrink >> sendMessage Shrink >> sendMessage Shrink)
 ,("M-h",          sendMessage Expand >> sendMessage Expand >> sendMessage Expand)
 ,("M-S-o",        sendMessage $ IncGap 80 L)
 ,("M-i",          sendMessage $ IncGap 80 R)
 ,("M-S-i",        sendMessage $ DecGap 80 L)
 ,("M-o",          sendMessage $ DecGap 80 R)
 ,("M1-i",         sendMessage $ DecGap 665 L)
 ,("M1-o",         sendMessage $ IncGap 665 L)
 ,("M-k",          focusUp)
 ,("M-j",          focusDown)
 ,("M-S-c",        kill >> focusUp)
 ,("M1-<F4>",      kill >> focusUp)
 ,("M-S-k",        windows W.swapUp)
 ,("M-S-j",        windows W.swapDown)
 ,("M-e",          spawnAndDo (insertPosition End Newer) "pcmanfm")
 ,("M-p",          spawn "dmenu_run -fn Inconsolata-12 -hist /home/oskar/.config/dmenu/dmenu_histfile")
 ,("M5-p",         spawn "dmenu_run -fn Inconsolata-12 -hist /home/oskar/.config/dmenu/dmenu_histfile")
 ,("M5-<Return>",  spawnAndDo (insertPosition End Newer) "urxvt")
 ,("M-S-<Return>", spawnAndDo (insertPosition End Newer) "urxvt")
 ,("M-<Return>",   spawnAndDo (placeHook myPlacement <+> doFloat) "urxvt -bg rgba:0000/1100/2200/bb00 -fg rgba:ee00/ee00/dd00/ee00 -g 56x21")
 ,("M1-<Return>",  spawnAndDo (placeHook myPlacement <+> doFloat) "urxvt -bg rgba:2200/1100/0000/bb00 -fg rgba:cc00/ee00/ee00/ee00 -g 56x42")
 ,("M-S-h",        spawn "pkill unclutter ; sleep 0.2; unclutter -grab")
 ,("C-<Print>",    spawn "pkill unclutter ; sleep 0.2; scrot -se 'mv $f ~/.scrot/' ; unclutter -grab")
 ,("<Print>",      spawn "sleep 0.2; scrot -e 'mv $f ~/.scrot/'")
 ,("<XF86AudioRaiseVolume>",  spawn "/home/oskar/script/volume/volume-inc.sh")
 ,("<XF86AudioLowerVolume>",  spawn "/home/oskar/script/volume/volume-dec.sh")
 ,("<XF86AudioMute>",         spawn "/home/oskar/script/volume/volume-toggle.sh")
 ,("<XF86AudioPlay>",         spotify "PlayPause")
 ,("<XF86AudioPrev>",         spotify "Previous")
 ,("<XF86AudioNext>",         spotify "Next")
 ,("M-<F11>",                 spawn "/home/oskar/script/insync/insync_toggle.sh")
 ,("<XF86MonBrightnessUp>",   spawn "/home/oskar/script/xbacklight/xbacklight-inc.sh")
 ,("M-<F5>",                  spawn "redshift -O 4800 -b 0.40")
 ,("M-<F6>",                  spawn "redshift -x")
 ,("<XF86MonBrightnessDown>", spawn "/home/oskar/script/xbacklight/xbacklight-dec.sh")
 ,("M-<F7>",                  spawn "xset -dpms; xset s off ; notify-send 'screen-blanking off'")
 ,("M-S-<F7>",                spawn "xset +dpms; xset s on ; notify-send 'screen-blanking on'")
 ,("<XF86Display>",           spawn "xset dpms force off")
 ,("<F12>",                   spawn "/home/oskar/script/wallpaper/wallpaperScript.sh")
 -- ,("e",                    spawn "xdotool mousemove 960 540")
 ,("M-S-<F12>",               spawn "/home/oskar/script/wallpaper/blackWallpaperScript.sh")
 ,("M1-<Escape>",             spawn "/home/oskar/script/xkbLayout/xkbSwitch.sh")
 -- ,("M-<Escape>",              spawn "feh -g +1300+50 /home/oskar/script/xkbLayout/layout.png")
 ] ++
 [ (otherModMasks ++ "M-" ++ [key], action tag)
    | (tag, key)  <- zip myWorkspaces "1234567890"
    , (otherModMasks, action) <- [ ("", windows . W.greedyView), ("S-", windows . W.shift)] -- was W.greedyView
 ]

myKeys' =  [
  ((mod4Mask, 0xa7),                            toggleOrView "spot" <+> spawn "/home/oskar/script/spotify/startSpotify.sh")
 ,((mod4Mask,                 xK_period),       sendMessage (IncMasterN 1))
 ,((mod4Mask,                 xK_comma),        sendMessage (IncMasterN (-1)))
 ,((mod4Mask .|. shiftMask,   xK_apostrophe),   spawnAndDo (insertPosition Master Newer) "chromium --enable-overlay-scrollbar")
 ,((mod4Mask .|. controlMask, xK_apostrophe),   spawnAndDo (insertPosition Master Newer) "chromium --enable-overlay-scrollbar -incognito")
 ,((mod4Mask .|. shiftMask,   xK_adiaeresis),   spawnAndDo (insertPosition Master Newer) "thunderbird")
 ,((mod4Mask .|. controlMask, xK_aring),        spawn "/home/oskar/script/shutdown/reboot.sh")
 ,((mod5Mask .|. shiftMask,   xK_aring),        spawn "/home/oskar/script/shutdown/reboot.sh")
 ,((mod4Mask,                 xK_Pause),        spawn "sudo /opt/script/psmouse/psmouse.sh")
 ,((mod4Mask,                 xK_Menu),         (sendMessage $ (SetStruts [minBound .. maxBound] [])) >> spawn "/home/oskar/script/dzenPopup/all_popup.sh")
 ,((0,                        xK_Menu),         sendMessage ToggleStruts)
 ,((mod5Mask,                 xK_minus),        spotify "PlayPause")
 ,((mod5Mask,                 xK_comma),        spotify "Previous")
 ,((mod5Mask,                 xK_period),       spotify "Next")
 ,((mod5Mask,                 xK_Menu),         spawn "/home/oskar/script/spotify/instantNotificationSpotify.py")
 ]
