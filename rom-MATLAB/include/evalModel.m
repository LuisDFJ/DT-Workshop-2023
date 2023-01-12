function [eModel] = evalModel( a, basis )
    fx = @(mu) a(1) + a(2) * mu;
    fy = @(mu) a(1) + a(2) * mu;
    fz = @(mu) a(1) + a(2) * mu;
    fv = @(mu) - abs( a(1) + a(2) * mu );
    
    Dx = @( mu ) fx(mu) * basis( :,1 );
    Dy = @( mu ) fy(mu) * basis( :,2 );
    Dz = @( mu ) fz(mu) * basis( :,3 );
    Dv = @( mu ) fv(mu) * basis( :,4 );
    
    eModel = @( mu ) deal( [ Dx(mu), Dy(mu), Dz(mu) ], Dv(mu) );
end