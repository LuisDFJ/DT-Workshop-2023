function updateModel( val, h, Nodes, model )
    mu = val;
    disp( mu )
    
    [ deformation, Dv ] = model( mu );
    h.Vertices = Nodes + deformation;
    h.FaceVertexCData = Dv;
    rotate( h, [1,0,0], 90 );
    %refreshdata(h,'caller');
end