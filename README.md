# plugin_htklabel

A plugin for Praat to read information from a HTK / HTS label file and
Master Label Files.

## Installation:

This plugin requires some of the existing plugins distributed through CPrAN.
If you have the CPrAN client installed on your machine, you can install this
plugin by typing

    cpran install htklabel

> NOTE: this will not work until registration on CPrAN is complete, which
> should be soon.

After that, you should be able to read `.lab` and `.mlf` files using the
commands in the `Open` menu, and save TextGrid objects as labels using the
commands in the `Save` menu.

If **you do no not have the client** you can follow [these instructions][1] 
to set it up and install the plugin as above.

If **you cannot install the client**, you can still use this plugin, as long
as you manually install all of its dependencies (and their dependencies).
The full list of dependencies (pointing to their git repositories) is

* [tap](https://gitlab.com/cpran/plugin_tap)
* [utils](https://gitlab.com/cpran/plugin_utils)
* [varargs](https://gitlab.com/cpran/plugin_varargs)
* [printf](https://gitlab.com/cpran/plugin_printf)
* [selection](https://gitlab.com/cpran/plugin_selection)
* [strutils](https://gitlab.com/cpran/plugin_strutils)

[1]: http://cpran.net/clients/cpran/#installation
