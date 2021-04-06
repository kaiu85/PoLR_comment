function [f]= spm_fx_dem_sensory_simple(x,v,P)%,indiv_params)
%
% x    - hidden states
%   x(1) - homeostatic variable 1
%   x(2) - homeostatic variable 2
%   x(3) - momentum of homeostatic variable 1
%   x(4) - momentum of homeostatic variable 2
% v    - causal states
%   v(1) - perturbing force 1
%   v(2) - perturbing force 2
% P    - parameters
% a    - action
% P    - parameters

indiv_params = [4,4,4];

drag = indiv_params(1);
spring_constant = indiv_params(2);
mass = indiv_params(3);


% evaluate positions
%--------------------------------------------------------------------------

T  = [0; 0]; % target location -> homeotatic equilibrium
POS = [x(1); x(2)]; % current location
F  = (T - POS)*spring_constant;  % force

% flow
%==========================================================================
f  = [x(3);
      x(4);
     (F(1) - drag*x(3))/mass;
     (F(2) - drag*x(4))/mass];
