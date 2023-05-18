<img src="https://github.com/italomandara/CXPatcher/raw/main/pacher%20icon.png" width="100" height="100" />

# CXPatcher
A patcher to upgrade Crossover dependencies and improve compatibility

This is an **unofficial patcher** for Crossover and codeweavers is not - by any means - involved in this or has anything to do with this app, and although has been tested, this software may render the app unusable or unstable, **USE AT YOUR OWN RISK**, this also will void any official support from Codeweavers, If you still need support from codeweavers, download the original unmodified app and please don't report problems to them after your app is patched.

if you have any issues after your app has been patched you can download a new copy of Crossover.

for more info: https://www.codeweavers.com/support/forums/general/?t=27;msg=257865

# What does it do?
This patcher will upgrade your crossover app with the latest dxvk and moltenvk patched for improved compatibility, and dramatically extends compatibility with Unreal enine 4 games.

# What does it NOT do?
- Games with anti-cheat or anti-tamper will not work
- Dx12 games will not work unless playable via the popular -dx11 option

# Instructions
You need to have an unmodified version of Crossover, you can download it at: https://www.codeweavers.com/account/downloads, please make sure the app has been registered or ran at least once, to make sure the latest dxvk is activated properly You may need to switch off dxvk and on again, if you don't you will need to re-download it. If the patcher renders the app unusable you can either use the restore function (see instructions below) or download it again from the website, it doesn't do any permanent modifications to your 'bottles'.

## Restoring a patched app to the original app
Maybe you changed your mind and prefer to use your original crossover app.
You can restore by going to the `file -> restore menu`

<img width="399" alt="Screenshot 2023-04-25 at 21 32 58" src="https://user-images.githubusercontent.com/12135454/234406600-f7a903fe-c34f-4d11-8154-476028870053.png">

## Patching other versions of crossover
From V0.2.12 I'm dropping support for Crossover 21, it lacks the base work for the hacked ntdll and dxvk.

## Upgrade from an old patch
If you patched from an old version and you just want to update the patched crossover app just turn on the option and drag 'n drop

![Screenshot 2023-05-10 at 10 55 42](https://github.com/italomandara/CXPatcher/assets/12135454/5bb3c410-0a02-42d0-9024-eb3dfde5ed96)


## Troubleshoting

**my env var doesn't work anymore or can't enable disable fast math**: use the env variable `CXPATCHER_SKIP_NTDLLHACKS=1` and then any env var should work as usual


## Color profiles for UE4 games:
You can change the way the colors are processed in ue4 games.

**examples:**

**disable color profiles** 

(old greyish colors but may improve performance or fix dark or oversaturated colors)

`NAS_TONEMAP_C=0`

**Example: Color profile for Stray**

`NAS_TONEMAP_C=clamp({inputColor} * float3x3( 0.2126 + 0.7874 * 1.5, 0.7152 - 0.7152 * 1.5, 0.0722 - 0.0722 * 1.5, 0.2126 - 0.2126 * 1.5, 0.7152 + 0.2848 * 1.5, 0.0722 - 0.0722 * 1.5, 0.2126 - 0.2126 * 1.5, 0.7152 - 0.7152 * 1.5, 0.0722 + 0.9278 * 1.5 ) * 2 - float3(0.28, 0.2, 0.16), 0.0, 1.0)`

`NAS_TONEMAP_C` uses standard MSL shading language, as long as it's done in one line, you can use {inputColor} as a variable and modify the colors, or give any effect you like using matrix transforms, WARNING: do not copy paste any code from unknown sources, and do this only if you know what you're doing, otherwise, have fun! 

**Note:** you may need to use `CXPATCHER_SKIP_DXVK_ENV=1` to override built in settings for games that already have a profile `NAS_TONEMAP_C`, also only works for UE4 games.

# Credits
Many thanks to the developers behind DXVK and MoltenVK patches: 
- @gcenx (https://github.com/Gcenx)
- @nastys (https://github.com/nastys)

thanks for the great help and for providing the latest binaries.
