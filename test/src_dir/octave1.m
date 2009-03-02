## Copyright (C) 2006, Regents of the University of California  -*- mode: octave; -*-
##
## This program is free software distributed under the "modified" or
## 3-clause BSD license appended to this file.

function varargout = toledolu(LU)
  ## -*- texinfo -*-
  ## @deftypefn{Function File} {[@var{L}, @var{U}, @var{P}]} = toledolu(@var{A})
  ## @deftypefnx{Function File} {[@var{L}, @var{U}]} = toledolu(@var{A})
  ## @deftypefnx{Function File} {@var{LUP}} = toledolu(@var{A})
  ##
  ## Note: This returns a vector of indices for @var{P} and not a permutation
  ## matrix.
  ##
  ## Factors @var{P}*@var{A}=@var{L}*@var{U} by Sivan Toledo's recursive factorization algorithm
  ## with partial pivoting.  While not as fast as the built-in LU, this
  ## is significantly faster than the standard, unblocked algorithm
  ## while remaining relatively easy to modify.
  ##
  ## See the help for lu for details about the other calling forms.
  ##
  ## For the algorithm, see
  ## @itemize
  ## @item
  ## Toledo, Sivan. "Locality of reference in LU decomposition with
  ## partial pivoting," SIAM J. of Matrix Analysis and Applications,
  ## v18, n4, 1997. DOI: 10.1137/S0895479896297744
  ## @end itemize
  ##
  ## @seealso{lu}
  ##
  ## @end deftypefn

  ## Author: Jason Riedy <ejr@cs.berkeley.edu>
  ## Keywords: linear-algebra, LU, factorization
  ## Version: 0.2

  ## This version isn't *quite* the same as Toledo's algorithm.  I use a
  ## doubling approach rather than using recursion.  So non-power-of-2
  ## columns likely will be slightly different, but that shouldn't
  ## affect the 'optimality' by more than a small constant factor.

  ## Also, I don't handle ncol > nrow optimally.  The code factors the
  ## first nrow columns and then updates the remaining ncol-nrow columns
  ## with L.

  ## Might be worth eating the memory cost and tracking L separately.
  ## The eye(n)+tril(LU,-1) could be expensive.

  switch (nargout)
    case 0
      return;
    case {1,2,3}
    otherwise
      usage ("[L,U,P] = lu(A), [P\\L, U] = lu(A), or (P\\L-I+U) = lu(A)");
  endswitch

  [nrow, ncol] = size(LU);
  nstep = min(nrow, ncol);

  Pswap = zeros(nstep, 1);

  for j=1:nstep,
    [pval, pind] = max(abs(LU(j:nrow, j)));
    pind = pind + j - 1;
    Pswap(j) = pind;

    kahead = bitand(j, 1+bitcmp(j)); # last 1 bit in j
    kstart = j+1-kahead;
    kcols = min(kahead, nstep-j);

    inds = kstart : j;
    Ucol = j+1 : j+kcols;
    Lrow = j+1 : nrow;

    ## permute just this column
    if (pind != j)
      tmp = LU(pind, j);
      LU(pind, j) = LU(j,j);
      LU(j,j) = tmp;
    endif
    ## apply pending permutations to L
    n_to_piv = 1;
    ipivstart = j;
    jpivstart = j - n_to_piv;
    while (n_to_piv < kahead)
      pivcols = jpivstart : jpivstart+n_to_piv-1;
      for ipiv = ipivstart:j,
	pind = Pswap(ipiv);
	if (pind != ipiv)
	  tmp = LU(pind, pivcols);
	  LU(pind, pivcols) = LU(ipiv, pivcols);
	  LU(ipiv, pivcols) = tmp;
	endif
      endfor
      ipivstart -= n_to_piv;
      n_to_piv *= 2;
      jpivstart -= n_to_piv;
    endwhile

    if (LU(j,j) != 0.0 && !isnan(LU(j,j))),
      LU(j+1:nrow,j) /= LU(j,j);
    endif

    if 0 == kcols, break; endif

    ## permute U to match perm already applied to L
    for k = inds,
      tmp = LU(Pswap(k), Ucol);
      LU(Pswap(k), Ucol) = LU(k, Ucol);
      LU(k, Ucol) = tmp;
    endfor

    LU(inds, Ucol) = (eye(kahead) + tril(LU(inds, inds),-1)) \ LU(inds, Ucol);
    LU(Lrow, Ucol) -= LU(Lrow, inds) * LU(inds, Ucol);
  endfor

  ## handle pivot permutations in L out from the last step
  npived = bitand(nstep, 1+bitcmp(nstep));
  j = nstep-npived;
  while (j > 0)
    n_to_piv = bitand(j, 1+bitcmp(j));

    pivcols = j-n_to_piv+1 : j;
    for ipiv = j+1:nstep,
      pind = Pswap(ipiv);
      if (pind != ipiv)
        tmp = LU(pind, pivcols);
	LU(pind, pivcols) = LU(ipiv, pivcols);
	LU(ipiv, pivcols) = tmp;
      endif
    endfor

    j -= n_to_piv;
  endwhile

  if (nrow < ncol),
    Ucol = nrow+1 : ncol;
    inds = 1:nrow;
    for k = inds,
      tmp = LU(Pswap(k), Ucol);
      LU(Pswap(k), Ucol) = LU(k, Ucol);
      LU(k, Ucol) = tmp;
    endfor
    LU(inds, Ucol) = (eye(nrow) + tril(LU(inds, inds),-1)) \ LU(inds, Ucol);
  endif

  if (nargout == 1)
    varargout{1} = LU;
    return;
  endif

  if nrow == ncol,
    L = eye(nrow) + tril(LU, -1);
    varargout{2} = triu(LU);
  elseif nrow < ncol,
    L = eye(nrow) + tril(LU, -1)(:,1:nrow);
    varargout{2} = triu(LU);
  else # nrow > ncol
    L = tril(LU, -1);
    for k=1:ncol,
      L(k,k) = 1;
    endfor
    varargout{2} = triu(LU)(1:ncol,:);
  endif

  if (nargout == 2)
    for j = 1:nstep,
      pind = Pswap(j);
      tmp = L(pind,:);
      L(pind,:) = L(j,:);
      L(j,:) = tmp;
    endfor
  else # nargout == 3
    P = 1:nrow;
    for j = 1:nstep,
      tmp = P(j);
      P(j) = P(Pswap(j));
      P(Pswap(j)) = tmp;
    endfor
    varargout{3} = P;
  endif
  varargout{1} = L;

endfunction

%!test
%!  M = 15;
%!  N = 15;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 16;
%!  N = 16;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 17;
%!  N = 17;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 8;
%!  N = 17;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 8;
%!  N = 15;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 7;
%!  N = 17;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 7;
%!  N = 15;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 17;
%!  N = 8;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 15;
%!  N = 8;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 17;
%!  N = 7;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 15;
%!  N = 7;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 31;
%!  N = 17;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

%!test
%!  M = 11;
%!  N = 29;
%!  A = rand(M,N);
%!  [L,U,P] = toledolu(A);
%!  assert(norm(L*U-A(P,:),inf), 0, M**2*N*eps)

## Copyright (c) 2006, Regents of the University of California
## All rights reserved.
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
##     * Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     * Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in the
##       documentation and/or other materials provided with the distribution.
##     * Neither the name of the University of California, Berkeley nor the
##       names of its contributors may be used to endorse or promote products
##       derived from this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
## EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
## WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
## DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
## DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
## (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
## LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
## ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
## SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
