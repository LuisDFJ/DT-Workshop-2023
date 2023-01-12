model = createpde();
geometryFromMesh( model, Nodes, Elements );
h = pdemesh( model );
%view(2)
rotate( h, [1,0,0], 90 )
axis off

%%

Z = [Zv, Zx, Zy];

n = size(Z, 1);
error = zeros( size(Z) );
total = sum( Z .* Z, 1 );

for i = 1 : n
    error( i, : ) = sum( Z(i:end, :) .^2, 1 ) ./ total;
end
error = sqrt(error);

figure;
hold on
plot( 0:n-1, error(:,1), ":o", "MarkerSize", 9, "LineWidth",1.2 );
plot( 0:n-1, error(:,2), ":s", "MarkerSize", 9, "LineWidth",1.2 );
plot( 0:n-1, error(:,3), ":x", "MarkerSize", 9, "LineWidth",1.2 );
set( gca, 'YScale', 'log' );
legend( [ "$\sigma_v$", "$\delta x$", "$\delta y$" ], "Interpreter", "latex", "FontSize", 14 )
title( "\textbf{$\varepsilon_N$ estimation $N\in[0," + (n-1) + "]$}", "Interpreter", "latex", "FontSize", 16 )
xlabel( "Reduced-Basis rank (N)", "Interpreter", "latex", "FontSize", 14 )
ylabel( "$\varepsilon(N)$", "Interpreter", "latex", "FontSize", 14 )
grid on;
