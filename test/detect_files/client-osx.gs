/*
 *  WebSoy - Client for OSX
 *  Copyright (C) 2011,2012 Copyleft Games Group
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as published
 *  by the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program; if not, see http://www.gnu.org/licenses
 *
 */

#if XP_MACOSX

[indent=4]
uses
    GLib
    GL

class Client : Object
    scene : soy.scenes.Scene
    window : soy.widgets.Window

    construct (window : NP.Window)
        self.scene = new soy.scenes.Scene()
        self.window = new soy.widgets.Window(null)

        // TODO

#endif

