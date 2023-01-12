function [] = errorEstimationPlot( Z, head )
    n = length(Z);
    error = zeros( n,1 );
    total = Z' * Z;
    for i = 1 : n
        error( i ) = Z(i:end)' * Z(i:end) / total;
    end
    
    error = sqrt(error);

    figure;
    plot( 0:n-1, error, '-r', "LineWidth", 1.5 );
    set( gca, 'YScale', 'log' );
    title( "$\varepsilon_N$ Estimation $N\in[0," + (n-1) + "]$ " + head, "Interpreter", "latex" )
    xlabel( "Reduced-Basis rank (N)", "Interpreter", "latex" )
    ylabel( "$\varepsilon(N)$", "Interpreter", "latex" )
    grid on;
end