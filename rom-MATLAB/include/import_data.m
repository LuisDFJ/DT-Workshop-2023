function [Nodes, Elements, VonMises, DisplacementX, DisplacementY, DisplacementZ, Inputs, TrainSet, ValSet] = import_data( path_mesh, path_results, partition )
    % Import Nodes and Elements
    Nodes = readmatrix( fullfile(path_mesh, 'Nodes.txt') );
    Elements = readmatrix( fullfile(path_mesh, 'Elements.txt') );
    Nodes = Nodes(:,2:end)';
    Elements = Elements(:,3:end)';
    % Import Results
    VonMises = readmatrix( fullfile( path_results, 'Equivalent Stress.txt' ) );
    DisplacementX = readmatrix( fullfile( path_results, 'Directional Deformation X.txt' ) );
    DisplacementY = readmatrix( fullfile( path_results, 'Directional Deformation Y.txt' ) );
    DisplacementZ = readmatrix( fullfile( path_results, 'Directional Deformation Z.txt' ) );
    Inputs = readmatrix( fullfile( path_results, 'Inputs.txt' ) );

    k = find( Inputs == -4 );

    n = size( VonMises, 2 );
    set = randperm( n );
    set = set( set~=k );


    k = floor( n * partition );
    TrainSet = set( 1:k );
    ValSet = set( k+1:end );
end