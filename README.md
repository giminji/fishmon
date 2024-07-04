# fishmon
Ashita addon for fishing in FFXI

## Features
- Replaces the default fishing result message (ex: `Something caught the hook!`) with a colour coded message showing whether it is a Small Fish, Big Fish, Item, or Monster.
- Adds a GUI that tracks total fish caught, total profit, and profit per hour (from first fish catch.)
- Settings to configure custom prices on a per fish basis. Can be useful if you swap between NPCing or AHing a fish or if prices change often.
- Outputs a debug message relating to fish stats (Fish HP, how long you have to catch it, how many arrows you need to hit, etc.)

## Setup

In your Ashita addons folder, create a new folder called `fishmon` and put the latest `fishmon.lua` and 'settings.lua' file into it.



```
{
    "prices": {
        "5454": 600,
        "5455": 700
    },
    "show_debug": true,
    "show_gui": true
}
```
The addon only comes with data for `Ahtapot` and `Mercanbaligi`. You will need to add more fish in to the settings.lua file 

To do this, go to the Eden website and look at the AH page for a certain fish. The URL will update to show the `ID` of the fish. Visiting the AH page for `Black Soles`, we can see it has an ID of `4384`: `https://edenxi.com/tools/item/4384`

Black Soles are currently selling for `10,500g` per stack, so we will use `875` as the value. We would then update the settings file like this:

```
{
    "prices": {
        "5454": 600,
        "5455": 700,
        "4384": 875
    },
    "show_debug": true,
    "show_gui": true
}
```

If a fish does not have a price set in the settings it will not count towards the total profit, profit per hour, or total fish caught.

Note: the items in the list don't need to be fish. Any non-fish item acquired from fishing will work (like mythril swords and silver rings.)

## Other Settings

Right now the only other settings are `show_debug` and `show_gui`. The debug setting allows you to toggle whether you see info about arrows, health, and damage. The GUI setting allows you to either enable or disable the GUI. Both are enabled by default.

## Gallery

![uifishmon](https://user-images.githubusercontent.com/39352103/221742419-e395e132-2ab7-40b7-8ac6-6feb2f31abd8.png)

UI showing profit and total caught

![smallfishexample](https://user-images.githubusercontent.com/39352103/221742521-0aa81ebf-6189-48d2-81dd-7d1d7618acd4.png)

Chat message showing a small fish being hooked. Debug is enabled.

![itemexample](https://user-images.githubusercontent.com/39352103/221742585-9934b18c-03fa-47b1-809d-ab0841ff5e5e.png)

Chat message showing an item being hooked.
