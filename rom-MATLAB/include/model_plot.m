function model_plot( Nodes, Elements, Val )
    fig = figure;
    ax = newplot(fig);
    ax.DataAspectRatio = [1,1,1];
    ax.View = [30,30];
    graphic_engine( Nodes, Elements, Val, ax );
    axis off;
end