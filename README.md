# ![Logo](./Icon.png?raw=true) Multi Flip Patcher

**Multi Flip Patcher** is a Tool to apply or create multiple IPS or BPS Patches at the same time.

It utilizes the Floating IPS Patcher or Flips made by Alcaro which can be found on the following Pages:

 * [SMWCentral](https://www.smwcentral.net/?p=section&a=details&id=11474)
 * [Github](https://github.com/Alcaro/Flips)

The Tool was tested with Windows 10 and Windows 11.

## Documentation

**Please Read the Instructions with care to avoid breaking something as this Tool will execute any Command and makes the Contents of the Clipboard Part of this.**
**Please be aware that there are many Ways to use this incorrectly.**

**Also the Tool may be flagged as a false positive by your System.**

**If you are still unsure please check and compile the Source Code yourself or try it in a VM first!**

If you want to hide the Application Window just click on the Tray-Icon on the Taskbar.

### Main Page

![Main Page Screenshot](./Images/Multi%20Flip%20Patcher%2001.png?raw=true)

Before you do anything you should select a Patch Format with the Radio Buttons.
You can choose between **BPS** and **IPS**. As of now you can only mass apply all IPS or BPS Patchers at once.

With the **Open Patch Folder** Button you should now select your Patch Folder where the Patches are located. It will only choose the Patches specified by your previous Selection.

The Number on the right displays the current number of Patches. By pressing the red Cross you can exclude single patches from the List. Pressing the other Symbol resets the List.

To choose your ROM File to apply your Patches you can Press the Button **Choose File to Patch** and select your ROM File.

You can also place your own dumped ROMs inside the MFP/Defaults folder and choose them afterwards with the **Default Files** Combo Box.

**Important:** Set your default Files before you start Multi Flip Patcher.

If you start a Task the choosen Patches will be applied separately in the Patch Folder.
No original Files will be deleted and by default the Checksum of the new ROM will be calculated. If the Flips Process failes the Status Message will change accordingly and the Checksum Calculation will be skipped.

If you want to create new Patches from modified ROMs you can also Change the **Mode** from Apply to Create. If you do so the following Changes will take place:

 * The Patch Format selection determines the **output Format of the new Patches**.
 * **Open Patch Folder** becomes **Open ROM Folder** and ignores File Extensions.
 * **Open File to Patch** becomes **Choose a clean ROM**.
 * Instead of Calculation the Checksum of the new Patch Files, the Chacksums of the original modified ROMs will be calculated.

Progress is indicated by the Progressbar on the Right with the vertical Layout.

There are also many **Options:**

 * **Skip Checksum Calculation:** Skips the CRC32 Calculation of the new ROMs to save Time.
 * **Ignore Patch Checksum:** Ignores the Checksum of the ROM specified by BPS Patches.
 * **Auto Save/Load Settings:** Saves all Settings by creating an INI File to be loaded on the next start.
 * **Hide Tray Icon:** Does just that.
 * **Allways on Top:** Does just that.

Finally the Button **Export as CSV** will export the whole String Grid as CSV File.

### About Page

![About Page Screenshot](./Images/Multi%20Flip%20Patcher%2002.png?raw=true)

By clicking the large Icon on the Left you will be introduced to the About Page where useful Information about the **License** or recent **Changelog** can be found.
There are also links to my Repositories on [Github](https://github.com/EthernalStar) or [Codeberg](https://codeberg.org/EthernalStar) where you could always find the latest Version.
If you have questions please don't hesitate to contact me over [E-Mail](mailto:NZSoft@Protonmail.com) or create an Issue on the Project Page.

## Use Cases

Here are some situations where I use this Tool:

* Patching a great amount of ROM Files at the same time.
* Creating Patches of your ROM Hacks for better Storage.
* Verify everything with CRC32 Checksums.

## Building

There shouldn't be any Problem building the Application because it doesn't rely on any external installed Packages.
To build the Project you need to have the [Lazarus IDE](https://www.lazarus-ide.org/) Version 2.2.6 installed.
After you have downloaded the Source Code or cloned this Repo just open the Project in your Lazarus Installation.
To do this just open the .lpr file and you should be able to edit and compile the Project.

## Issues

* Currently there are no known Issues. If you find something please open an Issue on the Repository.

## Planned Features

* Auto decide actions for all IPS and BPS Patches at the same time.
* Auto detection of used ROM versions.

## Changelog

* Version 1.0.0:
  * Initial Release.

## License

* GNU General Public License v3.0. See [LICENSE](./LICENSE) for further Information.