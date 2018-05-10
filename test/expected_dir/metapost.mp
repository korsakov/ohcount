metapost	comment	% Sample MetaPost with embedded LaTeX, used as unit test for ohcount
metapost	comment	%
metapost	comment	% The MetaPost code is taken of LaTeXLabels.mp from
metapost	comment	% the excellent MetaPost tutorial by Urs Oswald
metapost	comment	% http://www.ursoswald.ch/metapost/tutorial.html
metapost	comment	%
metapost	code	verbatimtex
tex	comment	%&latex
tex	code	\documentclass{article}
tex	code	\newcommand{\uB}{\upshape{B\'ezier}}   % up: upright
tex	code	\newcommand{\iB}{\itshape{B\'ezier}}   % it: italic
tex	code	\newcommand{\lB}{\slshape{B\'ezier}}   % sl: slanted
tex	code	\newcommand{\cB}{\scshape{B\'ezier}}   % sc: small caps
tex	code	\newfont{\cyr}{wncyr10}
tex	code	\begin{document}
metapost	code	etex
metapost	blank	
metapost	code	u:=25;                    % 25 = 25bp = 25 PostScript points = 30/72 in
metapost	code	wi:=10;                   % width  in units u   
metapost	code	he:=7;                    % height in units u
metapost	code	hoehe:=he*u;              % height
metapost	code	breite:=wi*u;             % width
metapost	code	picture lab;
metapost	blank	
metapost	code	beginfig(1)
metapost	comment	  % --- Grid ---
metapost	code	  for i=0 upto he:
metapost	code	    draw (0, i*u)--(breite, i*u) withcolor .7white;
metapost	code	  endfor
metapost	code	  for j=0 upto wi:
metapost	code	    draw (j*u, 0)--(j*u, hoehe) withcolor .7white;
metapost	code	  endfor
metapost	comment	  % --- End Grid ---
metapost	blank	
metapost	code	  draw (0, 0)--(breite, 0)--(breite, hoehe)--(0, hoehe)--cycle;
metapost	blank	
metapost	code	  for i=0 upto 5:
metapost	code	    draw .5(u, u){dir 20i}..{dir 20i}(9.5u, 4u);
metapost	code	  endfor  
metapost	blank	
metapost	code	  lab:=\thelabel(
metapost	code	    btex 
tex	code	      \begin{tabular}{|r|l|l|l|l|}
tex	code		\hline
tex	code		\textbf{md} & upright      & italic       & slanted      & smallcaps   \\ 
tex	code		\hline
tex	code		rm          & \textrm{\uB} & \textrm{\iB} & \textrm{\lB} &\textrm{\cB} \\
tex	code		sf          & \textsf{\uB} & \textsf{\iB} &\textsf{\lB}  &\textsf{\cB} \\
tex	code		tt          & \texttt{\uB} & \texttt{\iB} &\texttt{\lB}  &\texttt{\cB} \\
tex	code		\hline
tex	code	      \end{tabular}
metapost	code	    etex, 
metapost	code	    (.5breite, hoehe-1.5u)
metapost	code	  );
metapost	blank	
metapost	code	  unfill bbox lab;
metapost	code	  draw lab; 
metapost	blank	
metapost	code	  label.ulft(btex \cyr C\char24 rih, 08.09.2002 etex, (breite, 0));   
metapost	code	endfig;
metapost	blank	
metapost	code	end
