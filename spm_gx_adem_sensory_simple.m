function [g] = spm_gx_adem_sensory_simple(x,v,a,P)

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

g = [x(1:2)];