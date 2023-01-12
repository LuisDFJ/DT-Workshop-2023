function [h] = graphic_engine(p,t,c,fig)
    hf = get(fig,'Parent');
    set(hf,'Color','white');
    set(fig,'ClippingStyle','rectangle');
    
    faces = get_boundary_elements( t' );
    faces = split_tet10_facet_to_tet4( faces );

    cb = colorbar(fig);
    colormap(fig,'jet');
    cb.FontSize = 12;
    cb.FontName = "Cambria Math";
    clim(fig, [min(c) max(c)]);
    
    h = patch( ...
         fig, ...
         'Faces',    faces, ...
         'Vertices', p', ...
         'FaceVertexCData', c, ...
         'AmbientStrength', .75,  ...
         'EdgeColor', 'none', ...
         'FaceColor', 'interp', ...
         'Clipping',  'off' ...
        );
    rotate( h, [1,0,0], 90 );
end

function t4 = split_tet10_facet_to_tet4(t)
    tet10_to_tet4 = [1 4 6; 4 5 6; 4 2 5; 6 5 3];
    t4 = [t(:,tet10_to_tet4(1,:)); t(:,tet10_to_tet4(2,:)); t(:,tet10_to_tet4(3,:)); t(:,tet10_to_tet4(4,:))];
end

% function [h] = graphic_engine(p,t,c,fig)
%     %ha = newplot;
%     
%     hf = get(fig,'Parent');
%     set(hf,'Color','white');
%     set(fig,'ClippingStyle','rectangle');
%     %hold on;
%     
%     ltri = get_boundary_elements( t' );
%     size( ltri )
%     %[ltri] = tetBoundaryFacets(p,t);
%     ltri = splitQuadraticTri(ltri);
%     cb = colorbar(fig);
%     colormap(fig,'jet');
%     cb.FontSize = 12;
%     cb.FontName = "Cambria Math";
%     clim(fig, [min(c) max(c)]);
%     %ht = hgtransform(ha); colormap(ha,'jet');
%     %if min(c) ~= max(c)
%     %    
%     %end
%   
%     h=patch(fig, 'Faces',ltri, 'Vertices', p', 'FaceVertexCData', c, ...
%         'AmbientStrength', .75,  ...
%         'EdgeColor', 'none', 'FaceColor', 'interp', 'Clipping','off');
%     rotate( h, [1,0,0], 90 );
% 
%     
% end
% 
% function t4=splitQuadraticTri(t)
%     t4Nodes = [1 4 6; 4 5 6; 4 2 5; 6 5 3];
%     t4 = [t(:,t4Nodes(1,:)); t(:,t4Nodes(2,:)); t(:,t4Nodes(3,:)); t(:,t4Nodes(4,:))];
% end

