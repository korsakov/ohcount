scilab	comment	// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
scilab	comment	// Copyright (C) INRIA - Serge STEER
scilab	comment	// 
scilab	comment	// This file must be used under the terms of the CeCILL.
scilab	comment	// This source file is licensed as described in the file COPYING, which
scilab	comment	// you should have received as part of this distribution.  The terms
scilab	comment	// are also available at
scilab	comment	// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
scilab	blank	
scilab	code	function I=sub2ind(dims,varargin)
scilab	comment	//sub2ind is used to determine the equivalent single index
scilab	comment	//corresponding to a given set of subscript values.
scilab	blank	
scilab	comment	//I = sub2ind(dims,i1,i2,..) returns the linear index equivalent to the
scilab	comment	//row,  column, ... subscripts in the arrays i1,i2,..  for an matrix of
scilab	comment	//size dims.
scilab	blank	
scilab	comment	//I = sub2ind(dims,Mi) returns the linear index
scilab	comment	//equivalent to the n subscripts in the columns of the matrix Mi for a matrix
scilab	comment	//of size dims.
scilab	blank	
scilab	code	  d=[1;cumprod(matrix(dims(1:$-1),-1,1))]
scilab	code	  for i=1:size(varargin)
scilab	code	    if varargin(i)==[] then I=[],return,end
scilab	code	  end
scilab	blank	
scilab	code	  if size(varargin)==1 then //subindices are the columns of the argument
scilab	code	    I=(varargin(1)-1)*d+1
scilab	code	  else //subindices are given as separated arguments
scilab	code	    I=1
scilab	code	    for i=1:size(varargin)
scilab	code	      I=I+(varargin(i)-1)*d(i)
scilab	code	    end
scilab	code	  end
scilab	code	endfunction
