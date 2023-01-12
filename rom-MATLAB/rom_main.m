addpath("include\")
addpath(genpath("results\"))

%%
[Nodes, Elements, CVonMises, CDisplacementX, CDisplacementY, CDisplacementZ, CInputs, TrainSet, ValSet] = import_data( './results/v1.2-results', './results/v1.2-results/train', 0.2 );

%%
[ltri] = tetBoundaryFacets(Nodes,Elements);

%%
DisplacementX = CDisplacementX(:,TrainSet);
DisplacementY = CDisplacementY(:,TrainSet);
DisplacementZ = CDisplacementZ(:,TrainSet);
VonMises = CVonMises(:,TrainSet);
u = CInputs(:,TrainSet);

%%
fig = figure;
ax = newplot(fig);
ax.DataAspectRatio = [1,1,1];
ax.View = [30,30];
sol = 8;
deformation = [ CDisplacementX(:,sol), CDisplacementY(:,sol), CDisplacementZ(:,sol) ];


%h = pdeplot3D(Nodes + deformation',Elements,'ColorMapData',CVonMises(:,sol));
%rotate( h(2), [1,0,0], 90 );
%view( 0,0 );

graphic_engine( Nodes + deformation' , Elements, CVonMises(:,sol), ax );

axis off;

%%
[Ux,Zx,Vx] = svd( DisplacementX, "econ", "vector" );
[Uy,Zy,Vy] = svd( DisplacementY, "econ", "vector" );
[Uz,Zz,Vz] = svd( DisplacementZ, "econ", "vector" );
[Uv,Zv,Vv] = svd( VonMises, "econ", "vector" );

%%
Ux = [ Ux(:,1), sum( Ux(:,2:end-4), 2 ) ];
Uy = [ Uy(:,1), sum( Uy(:,2:end-4), 2 ) ];
Uz = [ Uz(:,1), sum( Uz(:,2:end-4), 2 ) ];
Uv = [ Uv(:,1), sum( Uv(:,2:end-4), 2 ) ];

%%
plotEigenPortraits( Nodes, Elements, Ux, Zx, [1,2], [-30, 30] );
%sgtitle( '\deltaX Displacement' )

plotEigenPortraits( Nodes, Elements, Uy, Zy, [1,2], [-30, 30] );
%sgtitle( '\deltaY Displacement' )

plotEigenPortraits( Nodes, Elements, Uz, Zz, [1,2], [-30, 30] );
%sgtitle( '\deltaZ Displacement' )

plotEigenPortraits( Nodes, Elements, Uv, Zv, [1,2], [-30, 30] );
%sgtitle( 'Von Mises Stress' )

%%
errorEstimationPlot( Zx, "$\delta X$" )
errorEstimationPlot( Zy, "$\delta Y$" )
errorEstimationPlot( Zz, "$\delta Z$" )
errorEstimationPlot( Zv, "$VonMises$" )

%%
r = 5;
mu = 1;

[Vx_hat] = parameterReconstruction( DisplacementX, Ux, Zx, r );
[Vy_hat] = parameterReconstruction( DisplacementY, Uy, Zy, r );
[Vz_hat] = parameterReconstruction( DisplacementZ, Uz, Zz, r );
[Vv_hat] = parameterReconstruction( VonMises, Uv, Zv, r );

figure;
hold on;
grid on;

t = -6:0.1:6;
plot_sorted( [u,0], [Vx_hat(mu,:),0], ':o' )
plot_sorted( [u,0], [Vy_hat(mu,:),0], ':x' )
%plot_sorted( [u,0], [Vz_hat(mu,:),0], '+-' )
plot_sorted( [u,0], [Vv_hat(mu,:),0], ':s' )
%plot_sorted( u, 0.1 * u, '--' )
%plot( t, a(1) + a(2) * t, ':', "LineWidth", 1 )
%plot( t, -abs( a(1) + a(2) * t ), '-.', "LineWidth", 1 )


%legend( ["$\psi_{\delta x}(\mu)$", "$\psi_{\delta y}(\mu)$", "$\psi_{v}(\mu)$"], "Interpreter", "latex", "FontSize", 14 )
%title ( "\textbf{Parameter reconstruction} ($\zeta_1$)", "Interpreter", "latex", "FontSize", 16 )
%xlabel( "$\mu_i$", "Interpreter", "latex", "FontSize", 14 )
%ylabel( "$\phi(\mu_i)$", "Interpreter", "latex", "FontSize", 14 )
xlim( [ min(CInputs), max(CInputs) ] )

%%
X = [ ones( size(u,2), 1 ), u' ];
a = X'*X \ X'* Vx_hat(mu,:)';

%%
basis = [ Zx(1) * Ux(:,1), Zy(1) * Uy(:,1), Zz(1) * Uz(:,1), -Zv(1) * Uv(:,1) ];
writematrix( basis, "./results/basis/basis.txt", "Delimiter", "tab" )
writematrix( a', "./results/basis/coefficients.txt", "Delimiter", "tab" )

%%
[model] = evalModel( a, Zx, Zy, Zz, Zv, Ux, Uy, Uz, Uv );
[ deformation, Dv ] = model( 5 );

h = pdeplot3D(Nodes + deformation',Elements,'ColorMapData',Dv);
rotate( h(2), [1,0,0], 90 );
axis off;


%%
fig = uifigure;
ax = uiaxes(fig, 'DataAspectRatio',[1,1,1], 'Visible','off', 'View', [30,30] );

h = graphic_engine( Nodes, Elements, Dv, ax );
sld = uislider(fig, 'Position',[40 350 150 3], 'ValueChangedFcn', @(sld,event) updateModel( sld.Value, h, Nodes', model ) );
sld.Limits = [-5,5];




%%
mu_set = CInputs( ValSet );
n = length( mu_set );
e_VonMises = zeros( n, 5 );
e_DisX = zeros( n, 5 );
e_DisY = zeros( n, 5 );
e_DisZ = zeros( n, 5 );

for j = 1 : n
     i = ValSet( j );
     [ deformation, Dv ] = model( mu_set( j ) );
     
     
     
     
     
     Dv_val = CVonMises(:,i);
     deformation_val = [ CDisplacementX(:,i), CDisplacementY(:,i), CDisplacementZ(:,i) ];
     e = 100 * abs( Dv - Dv_val ) ./ Dv_val;
     e_VonMises( j, : ) = [ mu_set( j ), mean( e ), max( e ), min( e ), std( e ) ];

     e = 100 * abs( deformation - deformation_val );
     e_DisX( j, : ) = [ mu_set( j ), mean( e(:,1) ), max( e(:,1) ), min( e(:,1) ), std( e(:,1) ) ];
     e_DisY( j, : ) = [ mu_set( j ), mean( e(:,2) ), max( e(:,2) ), min( e(:,2) ), std( e(:,2) ) ];
     e_DisZ( j, : ) = [ mu_set( j ), mean( e(:,3) ), max( e(:,3) ), min( e(:,3) ), std( e(:,3) ) ];
end


e_max_VonMises = mean( e_VonMises(:,3) );
e_max_DisX = mean( e_DisX(:,3) );
e_max_DisY = mean( e_DisY(:,3) );
e_max_DisZ = mean( e_DisZ(:,3) );

e_var_VonMises = mean( e_VonMises(:,5) );
e_var_DisX = mean( e_DisX(:,5) );
e_var_DisY = mean( e_DisY(:,5) );
e_var_DisZ = mean( e_DisZ(:,5) );

e_mean_VonMises = mean( e_VonMises(:,2) );
e_mean_DisX = mean( e_DisX(:,2) );
e_mean_DisY = mean( e_DisY(:,2) );
e_mean_DisZ = mean( e_DisZ(:,2) );

ma = [ e_max_VonMises; e_max_DisX; e_max_DisY ]
me = [ e_mean_VonMises; e_mean_DisX; e_mean_DisY]
va = [ e_var_VonMises; e_var_DisX; e_var_DisY]

%e_VonMises = sortrows( e_VonMises );
%%

figure;
hold on;
% bar( e_VonMises( :, 1 ), e_VonMises( :, 3 ) )
% bar( e_VonMises( :, 1 ), e_VonMises( :, 2 ) )


plot( e_VonMises( :, 2 ) )
plot( e_VonMises( :, 3 ) )
plot( e_VonMises( :, 4 ) )
%plot( e_VonMises( :, 5 ) )
set( gca, 'YScale', 'log' );
