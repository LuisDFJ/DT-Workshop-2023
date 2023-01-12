function f = get_boundary_elements( elements )
    f = get_tet10_facet( elements );
    e = sort( f, 2 );
    [~,ia,ic] = unique( e, "rows" );
    %size(ia)
    %size(ic)
    c = accumarray( ic, 1 );
    
    
    ix = sort( ia( c == 1 ) );
    %f = ix;
    f = f(ix, :);
end

function [f] = get_tet10_facet( facet )
    idx = [
      0, 2, 1, 6, 5, 4;
      2, 3, 1, 9, 8, 5;
      0, 3, 2, 7, 9, 6;
      0, 1, 3, 4, 8, 7
    ];
    n = size( idx,1 );
    f = zeros( [ length(facet) * n, size( idx,2 ) ] );
    for i = 1 : length( facet )
        f( 1+n*(i-1):i*n, : ) = [
            facet( i, idx(1,:) + 1 );
            facet( i, idx(2,:) + 1 );
            facet( i, idx(3,:) + 1 );
            facet( i, idx(4,:) + 1 ) ];
    end
end