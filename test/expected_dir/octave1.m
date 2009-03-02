octave	comment	## Copyright (C) 2006, Regents of the University of California  -*- mode: octave; -*-
octave	comment	##
octave	comment	## This program is free software distributed under the "modified" or
octave	comment	## 3-clause BSD license appended to this file.
octave	blank	
octave	code	function varargout = toledolu(LU)
octave	comment	  ## -*- texinfo -*-
octave	comment	  ## @deftypefn{Function File} {[@var{L}, @var{U}, @var{P}]} = toledolu(@var{A})
octave	comment	  ## @deftypefnx{Function File} {[@var{L}, @var{U}]} = toledolu(@var{A})
octave	comment	  ## @deftypefnx{Function File} {@var{LUP}} = toledolu(@var{A})
octave	comment	  ##
octave	comment	  ## Note: This returns a vector of indices for @var{P} and not a permutation
octave	comment	  ## matrix.
octave	comment	  ##
octave	comment	  ## Factors @var{P}*@var{A}=@var{L}*@var{U} by Sivan Toledo's recursive factorization algorithm
octave	comment	  ## with partial pivoting.  While not as fast as the built-in LU, this
octave	comment	  ## is significantly faster than the standard, unblocked algorithm
octave	comment	  ## while remaining relatively easy to modify.
octave	comment	  ##
octave	comment	  ## See the help for lu for details about the other calling forms.
octave	comment	  ##
octave	comment	  ## For the algorithm, see
octave	comment	  ## @itemize
octave	comment	  ## @item
octave	comment	  ## Toledo, Sivan. "Locality of reference in LU decomposition with
octave	comment	  ## partial pivoting," SIAM J. of Matrix Analysis and Applications,
octave	comment	  ## v18, n4, 1997. DOI: 10.1137/S0895479896297744
octave	comment	  ## @end itemize
octave	comment	  ##
octave	comment	  ## @seealso{lu}
octave	comment	  ##
octave	comment	  ## @end deftypefn
octave	blank	
octave	comment	  ## Author: Jason Riedy <ejr@cs.berkeley.edu>
octave	comment	  ## Keywords: linear-algebra, LU, factorization
octave	comment	  ## Version: 0.2
octave	blank	
octave	comment	  ## This version isn't *quite* the same as Toledo's algorithm.  I use a
octave	comment	  ## doubling approach rather than using recursion.  So non-power-of-2
octave	comment	  ## columns likely will be slightly different, but that shouldn't
octave	comment	  ## affect the 'optimality' by more than a small constant factor.
octave	blank	
octave	comment	  ## Also, I don't handle ncol > nrow optimally.  The code factors the
octave	comment	  ## first nrow columns and then updates the remaining ncol-nrow columns
octave	comment	  ## with L.
octave	blank	
octave	comment	  ## Might be worth eating the memory cost and tracking L separately.
octave	comment	  ## The eye(n)+tril(LU,-1) could be expensive.
octave	blank	
octave	code	  switch (nargout)
octave	code	    case 0
octave	code	      return;
octave	code	    case {1,2,3}
octave	code	    otherwise
octave	code	      usage ("[L,U,P] = lu(A), [P\\L, U] = lu(A), or (P\\L-I+U) = lu(A)");
octave	code	  endswitch
octave	blank	
octave	code	  [nrow, ncol] = size(LU);
octave	code	  nstep = min(nrow, ncol);
octave	blank	
octave	code	  Pswap = zeros(nstep, 1);
octave	blank	
octave	code	  for j=1:nstep,
octave	code	    [pval, pind] = max(abs(LU(j:nrow, j)));
octave	code	    pind = pind + j - 1;
octave	code	    Pswap(j) = pind;
octave	blank	
octave	code	    kahead = bitand(j, 1+bitcmp(j)); # last 1 bit in j
octave	code	    kstart = j+1-kahead;
octave	code	    kcols = min(kahead, nstep-j);
octave	blank	
octave	code	    inds = kstart : j;
octave	code	    Ucol = j+1 : j+kcols;
octave	code	    Lrow = j+1 : nrow;
octave	blank	
octave	comment	    ## permute just this column
octave	code	    if (pind != j)
octave	code	      tmp = LU(pind, j);
octave	code	      LU(pind, j) = LU(j,j);
octave	code	      LU(j,j) = tmp;
octave	code	    endif
octave	comment	    ## apply pending permutations to L
octave	code	    n_to_piv = 1;
octave	code	    ipivstart = j;
octave	code	    jpivstart = j - n_to_piv;
octave	code	    while (n_to_piv < kahead)
octave	code	      pivcols = jpivstart : jpivstart+n_to_piv-1;
octave	code	      for ipiv = ipivstart:j,
octave	code		pind = Pswap(ipiv);
octave	code		if (pind != ipiv)
octave	code		  tmp = LU(pind, pivcols);
octave	code		  LU(pind, pivcols) = LU(ipiv, pivcols);
octave	code		  LU(ipiv, pivcols) = tmp;
octave	code		endif
octave	code	      endfor
octave	code	      ipivstart -= n_to_piv;
octave	code	      n_to_piv *= 2;
octave	code	      jpivstart -= n_to_piv;
octave	code	    endwhile
octave	blank	
octave	code	    if (LU(j,j) != 0.0 && !isnan(LU(j,j))),
octave	code	      LU(j+1:nrow,j) /= LU(j,j);
octave	code	    endif
octave	blank	
octave	code	    if 0 == kcols, break; endif
octave	blank	
octave	comment	    ## permute U to match perm already applied to L
octave	code	    for k = inds,
octave	code	      tmp = LU(Pswap(k), Ucol);
octave	code	      LU(Pswap(k), Ucol) = LU(k, Ucol);
octave	code	      LU(k, Ucol) = tmp;
octave	code	    endfor
octave	blank	
octave	code	    LU(inds, Ucol) = (eye(kahead) + tril(LU(inds, inds),-1)) \ LU(inds, Ucol);
octave	code	    LU(Lrow, Ucol) -= LU(Lrow, inds) * LU(inds, Ucol);
octave	code	  endfor
octave	blank	
octave	comment	  ## handle pivot permutations in L out from the last step
octave	code	  npived = bitand(nstep, 1+bitcmp(nstep));
octave	code	  j = nstep-npived;
octave	code	  while (j > 0)
octave	code	    n_to_piv = bitand(j, 1+bitcmp(j));
octave	blank	
octave	code	    pivcols = j-n_to_piv+1 : j;
octave	code	    for ipiv = j+1:nstep,
octave	code	      pind = Pswap(ipiv);
octave	code	      if (pind != ipiv)
octave	code	        tmp = LU(pind, pivcols);
octave	code		LU(pind, pivcols) = LU(ipiv, pivcols);
octave	code		LU(ipiv, pivcols) = tmp;
octave	code	      endif
octave	code	    endfor
octave	blank	
octave	code	    j -= n_to_piv;
octave	code	  endwhile
octave	blank	
octave	code	  if (nrow < ncol),
octave	code	    Ucol = nrow+1 : ncol;
octave	code	    inds = 1:nrow;
octave	code	    for k = inds,
octave	code	      tmp = LU(Pswap(k), Ucol);
octave	code	      LU(Pswap(k), Ucol) = LU(k, Ucol);
octave	code	      LU(k, Ucol) = tmp;
octave	code	    endfor
octave	code	    LU(inds, Ucol) = (eye(nrow) + tril(LU(inds, inds),-1)) \ LU(inds, Ucol);
octave	code	  endif
octave	blank	
octave	code	  if (nargout == 1)
octave	code	    varargout{1} = LU;
octave	code	    return;
octave	code	  endif
octave	blank	
octave	code	  if nrow == ncol,
octave	code	    L = eye(nrow) + tril(LU, -1);
octave	code	    varargout{2} = triu(LU);
octave	code	  elseif nrow < ncol,
octave	code	    L = eye(nrow) + tril(LU, -1)(:,1:nrow);
octave	code	    varargout{2} = triu(LU);
octave	code	  else # nrow > ncol
octave	code	    L = tril(LU, -1);
octave	code	    for k=1:ncol,
octave	code	      L(k,k) = 1;
octave	code	    endfor
octave	code	    varargout{2} = triu(LU)(1:ncol,:);
octave	code	  endif
octave	blank	
octave	code	  if (nargout == 2)
octave	code	    for j = 1:nstep,
octave	code	      pind = Pswap(j);
octave	code	      tmp = L(pind,:);
octave	code	      L(pind,:) = L(j,:);
octave	code	      L(j,:) = tmp;
octave	code	    endfor
octave	code	  else # nargout == 3
octave	code	    P = 1:nrow;
octave	code	    for j = 1:nstep,
octave	code	      tmp = P(j);
octave	code	      P(j) = P(Pswap(j));
octave	code	      P(Pswap(j)) = tmp;
octave	code	    endfor
octave	code	    varargout{3} = P;
octave	code	  endif
octave	code	  varargout{1} = L;
octave	blank	
octave	code	endfunction
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 15;
octave	comment	%!  N = 15;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 16;
octave	comment	%!  N = 16;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 17;
octave	comment	%!  N = 17;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 8;
octave	comment	%!  N = 17;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 8;
octave	comment	%!  N = 15;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 7;
octave	comment	%!  N = 17;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 7;
octave	comment	%!  N = 15;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 17;
octave	comment	%!  N = 8;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 15;
octave	comment	%!  N = 8;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 17;
octave	comment	%!  N = 7;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 15;
octave	comment	%!  N = 7;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 31;
octave	comment	%!  N = 17;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	%!test
octave	comment	%!  M = 11;
octave	comment	%!  N = 29;
octave	comment	%!  A = rand(M,N);
octave	comment	%!  [L,U,P] = toledolu(A);
octave	comment	%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)
octave	blank	
octave	comment	## Copyright (c) 2006, Regents of the University of California
octave	comment	## All rights reserved.
octave	comment	## Redistribution and use in source and binary forms, with or without
octave	comment	## modification, are permitted provided that the following conditions are met:
octave	comment	##
octave	comment	##     * Redistributions of source code must retain the above copyright
octave	comment	##       notice, this list of conditions and the following disclaimer.
octave	comment	##     * Redistributions in binary form must reproduce the above copyright
octave	comment	##       notice, this list of conditions and the following disclaimer in the
octave	comment	##       documentation and/or other materials provided with the distribution.
octave	comment	##     * Neither the name of the University of California, Berkeley nor the
octave	comment	##       names of its contributors may be used to endorse or promote products
octave	comment	##       derived from this software without specific prior written permission.
octave	comment	##
octave	comment	## THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
octave	comment	## EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
octave	comment	## WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
octave	comment	## DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
octave	comment	## DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
octave	comment	## (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
octave	comment	## LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
octave	comment	## ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
octave	comment	## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
octave	comment	## SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
