function [a, X] = curve_fit( x, y, n )
    % Note: x, y must be column vectors of the same size. n is an integer.
    X = ones( size( x, 1 ), n + 1 );
    for i = 1 : n
        X(:, i+1) = x.^i;
    end
    
    a = linsolve( X'*X, X'*y );
end