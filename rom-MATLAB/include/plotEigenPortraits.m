function [] = plotEigenPortraits( Nodes, Elements, U, Z, size, v )
    figure;
    for n = 1: size(1) * size(2)
        ax = subplot( size(1), size(2), n );



        ax.DataAspectRatio = [1,1,1];
        ax.View = [v(1),v(2)];
        graphic_engine( Nodes, Elements, U(:,n), ax );
        axis off;
        title( "$\sigma_{" + n + "} = " + Z(n) + "$", "Interpreter", "latex" )
    end
end