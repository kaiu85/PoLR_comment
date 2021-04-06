function DEM = sensory_PE(x1_start, x2_start, force_strength1, force_strength2, drag, spring_constant, mass)
% This demo illustrates how action can fulfil prior expectations by
% explaining away sensory prediction errors prescribed by desired movement
% trajectories. In this example a two-joint arm is trained to touch a target
% so that spontaneous reaching occurs after training.
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging
 
% Karl Friston
% $Id: ADEM_reaching.m 4804 2012-07-26 13:14:18Z karl $

% hidden causes and states
%==========================================================================
% x    - hidden states
%   x(1) - homeostatic variable 1
%   x(2) - homeostatic variable 2
%   x(3) - momentum of homeostatic variable 1
%   x(4) - momentum of homeostatic variable 2
% v    - causal states
%   v(1) - environmental force 1 (x)
%   v(2) - environmental force 1 (y)
%
%--------------------------------------------------------------------------


% Recognition model (linear for expediency)
%==========================================================================
M         = struct;
M(1).E.s  = 1/2;                              % smoothness
M(1).E.n  = 4;                                % order of 
M(1).E.d  = 2;                                % generalised motion
 
% level 1: Displacement dynamics and mapping to sensory/proprioception
%--------------------------------------------------------------------------
M(1).f  = 'spm_fx_dem_sensory_simple';%@(x,v,a,P)spm_fx_dem_thermo_simple(x,v,P,[drag, spring_constant, mass]);                 % true dynamics
M(1).g  = 'spm_gx_dem_sensory_simple';                 % true sensory mapping
 
M(1).x  = [x1_start; x2_start; 0; 0;];
M(1).V  = exp(6);                             % error precision
M(1).W  = exp(6);                             % error precision
 
% level 2: with non-informative priors on perturbing force
%--------------------------------------------------------------------------
M(2).v  = [0; 0];                          % inputs
M(2).V  = exp(0);
 
% generative model
%==========================================================================
G       = M;
 
% first level
%--------------------------------------------------------------------------
G(1).f  = @(x,v,a,P)spm_fx_adem_sensory_simple(x,v,a,P,[drag, spring_constant, mass]);                 % generative model of dynamics
G(1).g  = 'spm_gx_adem_sensory_simple';                 % generative model of sensory mapping
G(1).V  = exp(10);                            % error precision
G(1).W  = exp(10);                            % error precision
G(1).U  = exp(8);                             % gain for action
 
% second level
%--------------------------------------------------------------------------
G(2).v  = [0; 0];                          % inputs
G(2).a  = [0; 0];                             % action
G(2).V  = exp(16);
 
 
% generate and invert
%==========================================================================
N       = 128;                                 % length of data sequence
C       = sparse(2,N);
C(1,N/2:end)  = C(1,N/2:end) + force_strength1; % Step (Heaviside) Function of Perturbing Force
C(2,N/2:end)  = C(2,N/2:end) + force_strength2; % Step (Heaviside) Function of Perturbing Force
 
M(2).v  = C(:,1); 
 
DEM.G   = G;
DEM.M   = M;
DEM.C   = C;
DEM.U   = sparse(2,N);
DEM     = spm_ADEM(DEM);
 
% overlay true values
%--------------------------------------------------------------------------
spm_DEM_qU(DEM.qU,DEM.pU)
 
 
% Graphics
%==========================================================================
spm_figure('GetWin','Figure 1');
clf
 
%subplot(2,1,1)
%spm_dem_reach_plot(DEM)
%title('trajectory','FontSize',16)
 
%subplot(2,1,2)
%spm_dem_reach_movie(DEM)
%title('click on finger for movie','FontSize',16)
 
return