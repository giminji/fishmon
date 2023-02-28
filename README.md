# fishmon
Ashita addon for fishing in FFXI

## Features
- Replaces the default fishing result message (ex: `Something caught the hook!`) with a colour coded message showing whether it is a Small Fish, Big Fish, Item, or Monster.
- Adds a GUI that tracks total fish caught, total profit, and profit per hour (from first fish catch.)
- Settings to configure custom prices on a per fish basis. Can be useful if you swap between NPCing or AHing a fish or if prices change often.
- Outputs a debug message relating to fish stats (Fish HP, how long you have to catch it, how many arrows you need to hit, etc.)

## Setup

In your Ashita addons folder, create a new folder called `fishmon` and put the latest `fishmon.lua` file into it.

The first time you load the addon, a new folder called `settings` will be created in the `fishmon` folder. It will have a file called `settings.json` in it that looks something like this:

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
The addon only comes with data for `Ahtapot` and `Mercanbaligi`. You will need to add more fish in.

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