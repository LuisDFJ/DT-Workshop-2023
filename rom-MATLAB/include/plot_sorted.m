function plot_sorted( u, V, linestyle )
    T = sortrows( [u',V'] );
    plot( T(:,1), T(:,2), linestyle, "MarkerSize", 10, "LineWidth",1.2 )
end