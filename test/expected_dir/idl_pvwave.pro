idl_pvwave	comment	;+
idl_pvwave	comment	; NAME: 
idl_pvwave	comment	;      SHOWFONT
idl_pvwave	comment	;
idl_pvwave	comment	; PURPOSE: 
idl_pvwave	comment	;          Uses current graphics device to draw a map of characters
idl_pvwave	comment	;          available in the font specified in argument
idl_pvwave	comment	;
idl_pvwave	comment	; CATEGORY: 
idl_pvwave	comment	;          General 
idl_pvwave	comment	;
idl_pvwave	comment	; CALLING SEQUENCE:
idl_pvwave	comment	;          showfont, num, 'title' ; table of font num entitled 'title'
idl_pvwave	comment	;
idl_pvwave	comment	; KEYWORD PARAMETERS: 
idl_pvwave	comment	;          /encapsulated                ; ignored (just for compatibility)
idl_pvwave	comment	;          /tt_font                     ; ignored (just for compatibility)
idl_pvwave	comment	;          base = 16                    ; number of columns in the table 
idl_pvwave	comment	;          beg = 32                     ; first character
idl_pvwave	comment	;          fin = num eq 3 ? 255 : 127   ; last character
idl_pvwave	comment	;
idl_pvwave	comment	; OUTPUTS:
idl_pvwave	comment	;          None.
idl_pvwave	comment	;
idl_pvwave	comment	; OPTIONAL OUTPUTS:
idl_pvwave	comment	;          None.
idl_pvwave	comment	;
idl_pvwave	comment	; COMMON BLOCKS:
idl_pvwave	comment	;          None.
idl_pvwave	comment	;
idl_pvwave	comment	; SIDE EFFECTS:
idl_pvwave	comment	;          Draws a font table on the current graphic device.
idl_pvwave	comment	;
idl_pvwave	comment	; RESTRICTIONS:
idl_pvwave	comment	;          None.
idl_pvwave	comment	;
idl_pvwave	comment	; PROCEDURE:
idl_pvwave	comment	;
idl_pvwave	comment	; EXAMPLE:
idl_pvwave	comment	;          showfont, 9, 'GDL math symbols'   ; show mappings for font 9
idl_pvwave	comment	;
idl_pvwave	comment	; MODIFICATION HISTORY:
idl_pvwave	comment	; 	Written by: Sylwester Arabas (2008/12/28)
idl_pvwave	comment	;-
idl_pvwave	comment	; LICENCE:
idl_pvwave	comment	; Copyright (C) 2008,
idl_pvwave	comment	; This program is free software; you can redistribute it and/or modify  
idl_pvwave	comment	; it under the terms of the GNU General Public License as published by  
idl_pvwave	comment	; the Free Software Foundation; either version 2 of the License, or     
idl_pvwave	comment	; (at your option) any later version.                                   
idl_pvwave	comment	;-
idl_pvwave	blank	
idl_pvwave	code	pro showfont, num, name, encapsulated=eps, tt_font=tt, base=base, beg=beg, fin=fin
idl_pvwave	blank	
idl_pvwave	comment	  ; handling default keyword values
idl_pvwave	code	  if not keyword_set(base) then base = 16
idl_pvwave	code	  if not keyword_set(beg) then beg = 32
idl_pvwave	code	  if not keyword_set(fin) then fin = num eq 3 ? 255 : 127
idl_pvwave	code	  if not keyword_set(name) then name = ''
idl_pvwave	blank	
idl_pvwave	comment	  ; constructing horizontal and vertical grid lines
idl_pvwave	code	  n_hor = (fin + 1 - beg) / base + 1
idl_pvwave	code	  h_x = (double(rebin(base * byte(128 * indgen(2 * (n_hor))) / 128, 4 * n_hor, /sample)))[1:4 * n_hor - 1] - .5
idl_pvwave	code	  h_y = (double(rebin(beg + indgen(n_hor) * base, 4 * n_hor, /sample)))[0:4 * n_hor - 2] - base/2.
idl_pvwave	code	  v_x = base - indgen(4 * base - 1) / 4 - .5
idl_pvwave	code	  v_y = (double(rebin(byte(128 * indgen(2 * (base))) / 128, 4 * base, /sample)))[1:4 * base - 1] $
idl_pvwave	code	    * base * ((fin + 1 - beg) / base) + beg - base / 2.
idl_pvwave	blank	
idl_pvwave	comment	  ; ploting grid and title
idl_pvwave	code	  plot,  [h_x, v_x], [h_y, v_y], $
idl_pvwave	code	     title='Font ' + strtrim(string(num), 2) + ', ' + name, $
idl_pvwave	code	     xrange=[-1, base], $
idl_pvwave	code	     yrange=[base * ((fin + 1) / base), beg - base], $
idl_pvwave	code	     yticks=n_hor, $
idl_pvwave	code	     xticks=base+1, $
idl_pvwave	code	     xtitle='char mod ' + strtrim(string(base), 2), $
idl_pvwave	code	     ytitle=strtrim(string(base), 2) + ' * (char / ' + strtrim(string(base), 2) + ')'
idl_pvwave	blank	
idl_pvwave	comment	  ; ploting characters
idl_pvwave	code	  for c = beg, fin do $
idl_pvwave	code	    xyouts, (c mod base), base * (c / base), '!' + strtrim(string(num), 2) + string(byte(c))
idl_pvwave	blank	
idl_pvwave	code	end
