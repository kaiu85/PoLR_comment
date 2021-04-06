function [f]= spm_fx_adem_sensory_simple(x,v,a,P,indiv_params)
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

drag = indiv_params(1);
spring_constant = indiv_params(2);
mass = indiv_params(3);

% flow
%==========================================================================
f    = [x(3);
        x(4);
      (-drag*x(3) + a(1))/mass; % - (x(1) - v(1))/spring_constant)/mass;
      (-drag*x(4) + a(2))/mass]; % - (x(2) - v(2))/spring_constant)/mass];
