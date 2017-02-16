# Setup script for serialise
#
# This script is part of the serialise CPrAN plugin for Praat.
# The latest version is available through CPrAN or at
# <http://cpran.net/plugins/serialise>
#
# The serialise plugin is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# The serialise plugin is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with serialise. If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2014, 2015 Jose Joaquin Atria

## Static commands:

nocheck Add menu command:   "Objects",  "Open", "Read HTK Label file...", "", 0, "scripts/read_lab.praat"
nocheck Add menu command:   "Objects",  "Open", "Read HTK Master Label File...", "", 0, "scripts/read_mlf.praat"

nocheck Add action command: "TextGrid", 0, "", 0, "", 0, "Save as HTK Label file...", "", 0, "scripts/write_lab.praat"

nocheck Add action command: "Table", 1, "", 0, "", 0, "MLF Table -", "", 0, ""
nocheck Add action command: "Table", 1, "", 0, "", 0, "Query path from MLF Table...", "MLF Table -", 1, "scripts/query_mlf.praat"
