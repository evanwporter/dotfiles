import System.Exit (exitSuccess)
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main = xmonad $ xmobarProp $ myConfig

myConfig =
    def
        { modMask = mod4Mask
        , terminal = "st"
        , startupHook = do
            -- spawnOnce "@feh@/bin/feh --no-fehbg --bg-scale @wallpaper@"
            -- spawnOnce "@dunst@/bin/dunst"
            spawnOnce "st"
        }
        `additionalKeysP` [("M-S-e", io exitSuccess)]
