function D = ddel2 (M, dx, dy)
  
  if ((nargin < 1) || (nargin > 3))
    usage ("del2(M,dx,dy)");
  elseif (nargin == 1)
    dx = dy = 1;
  elseif (nargin == 2)
    dy = 1;
  endif
  
  if (is_vector (M))
    M = M(:)';
  endif

  if (!is_matrix (M))
    error ("first argument must be a vector or matrix");
  else
    if is_scalar (dx)
      dx = dx * ones (1, columns(M) - 1);
    else
      if !(length(dx) == columns(M))
        error ("columns of M must match length of dx")
      else
        dx = diff (dx);
      endif
    endif

    if (is_scalar (dy))
      dy = dy * ones (rows (M) - 1, 1);
    else
      if !(length(dy) == rows(M))
        error ("rows of M must match length of dy")
      else
        dy = diff (dy);
      endif
    endif
  endif

  [mr,mc] = size (M);
  D = zeros (size (M));
  
  if (mr >= 3)  
    ## x direction
    ## left and right boundary
    D(:, 1) = (M(:, 1) .- 2 * M(:, 2) + M(:, 3)) / (dx(1) * dx(2));
    D(:, mc) = (M(:, mc - 2) .- 2 * M(:, mc - 1) + M(:, mc))\
      / (dx(mc - 2) * dx(mc - 1));
    
    ## interior points
    D(:, 2:mc - 1) = D(:, 2:mc - 1)\
      + (M(:, 3:mc) .- 2 * M(:, 2:mc - 1) + M(:, 1:mc - 2))\
      ./ kron (dx(1:mc -2 ) .* dx(2:mc - 1), ones (mr, 1));
  endif

  if (mc >= 3)
    ## y direction
    ## top and bottom boundary
    D(1, :) = D(1,:)\
      + (M(1, :) .- 2 * M(2, :) + M(3, :)) / (dy(1) * dy(2));
    D(mr, :) = D(mr, :)\
      + (M(mr - 2,:) .- 2 * M(mr - 1, :) + M(mr, :))\
      / (dy(mr - 2) * dx(mr - 1));
    
    ## interior points
    D(2:mr - 1, :) = D(2:mr - 1, :)\
      + (M(3:mr, :) .- 2 * M(2:mr - 1, :) + M(1:mr - 2, :))\
      ./ kron (dy(1:mr - 2) .* dy(2:mr - 1), ones (1, mc));
  endif

  D = D ./ 4;
endfunction
