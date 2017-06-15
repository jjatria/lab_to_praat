# plugin_htklabel

A plugin for Praat to read information from a HTK / HTS label file and
Master Label Files.

## Installation:

This plugin requires some of the existing plugins distributed through CPrAN.
If you have the CPrAN client installed on your machine, you can install this
plugin by typing

    cpran install htklabel

> NOTE: this will not work until registration on CPrAN is complete, which
> should be soon. If this does not work you may clone this repo to your Praat
> preferences directory.

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

## Plugin Use

### Reading files

This plugin provides features to import HTK/HTS label files into Praat. Mainly,
this is done through two commands, both available under the `Open` menu in the
Objects window.

The command `Read HTK Label File...` takes the path to a single label file and
will read that into one or more TextGrid objects. The mapping between these two
is done so that levels are mapped to tiers and alternatives are mapped to
separate TextGrid objects. After the command, all newly created objects will be
selected.

Currently, only labels that provide both a start and an end position are
supported.

Master Label Files can be read with the `Read HTK Master Label File...`, which
works differently. Since MLF files specify a mapping between filename patterns
and files, reading one into Praat will result in a Table object with the
information necessary for that mapping. Queries are then performed _on_ this
object with the `Query path from MLF Table...` command available in the
contextual menu.

Patterns in MLF files typically use fileglobs, but since in Praat it is more
typical to use regular expressions for this purpose, this command supports both.

The query command takes a filename pattern to match, and a value specifying
how the pattern should be interpreted: either `"Regex"` or `"Glob"`.

If supported, the matched file will then be read into Praat, and any newly
created objects will be selected. Please note that this mapping can point to
_any_ file, not only those used by HTK / HTS.

## Writing files

TextGrid objects can be written to HTK / HTS labels using the
`Save as HTK Label file...`. At this point, converting MLF Table objects to MLF
files is not supported.

Note that information that only information that can be stored in the selected
TextGrid objects will be saved into the label file. This will _not_ include any
coments that may have been there originally.
