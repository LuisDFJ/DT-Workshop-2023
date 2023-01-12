function [V_hat] = parameterReconstruction( S, U, Z )
    Z_hat_inv = diag( 1./Z );
    V_hat = Z_hat_inv*U'*S;
end