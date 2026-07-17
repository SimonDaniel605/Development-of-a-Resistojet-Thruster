%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   nozzle.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           May 2026
%   Version:        2.1
%   Project:        Development of a Resistojet Thruster
%   Description:    
%   This file calculates the thrust and specific impulse of a thruster and
%   plots these properties against a range of chamber temperatures. The
%   function calculates the thruster performance based on its nozzle
%   geometries, chamber conditions, and environmental pressure, using
%   CoolProp to obtain the thermodynamic properties of the specified
%   propellant.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = nozzle(cfg)
% Display full properties at cfg.T0 in terminal
state0 = thrusterState(cfg.tank.T, cfg.tank.P, cfg.T0, cfg.p0, cfg.environment.pa, ...
    cfg.nozzle.ri, cfg.nozzle.rt, cfg.nozzle.re, cfg.species);
out = state0;
state1 = thrusterSensitivity(cfg.tank.T, cfg.tank.P, cfg.T0, cfg.p0, cfg.environment.pa, ...
    cfg.nozzle.ri, cfg.nozzle.rt, cfg.nozzle.re, cfg.species, cfg.nozzle.tol);
fprintf('\n============================================================\n');
fprintf('Thruster properties at T0 = %.3f K for %s\n', cfg.T0, cfg.species);
fprintf('============================================================\n');
fprintf('Chamber phase : %s\n', state0.phase_chamber);
fprintf('Throat phase  : %s\n', state0.phase_throat);
fprintf('Exit phase    : %s\n', state0.phase_exit);

if state0.valid
    fprintf('rho_storage = %.6f kg/m^3\n', state0.rho_storage);
    fprintf('R           = %.6f J/kg/K\n', state0.R);
    fprintf('cp          = %.6f J/kg/K\n', state0.cp);
    fprintf('gamma       = %.6f\n', state0.gamma);
    fprintf('pt          = %.6f Pa\n', state0.pt);
    fprintf('Tt          = %.6f K\n', state0.Tt);
    fprintf('pe          = %.6f Pa\n', state0.pe);
    fprintf('Te          = %.6f K\n', state0.Te);
    fprintf('Me          = %.6f\n', state0.Me);
    fprintf('ve          = %.6f m/s\n', state0.ve);
    fprintf('m_dot       = %.6e kg/s\n', state0.m_dot);
    fprintf('Re_inlet    = %.6e\n', state0.Re_inlet);
    fprintf('Re_throat   = %.6e\n', state0.Re_throat);
    fprintf('Re_exit     = %.6e\n', state0.Re_exit);
    fprintf('F           = %.6e N\n', state0.F);
    fprintf('Isp         = %.6f s\n', state0.Isp);
    fprintf('Iv          = %.6f N.s/m^3\n', state0.Iv);
    fprintf('Psp         = %.6f W/mN\n', state0.W_per_mN);
    fprintf('============================================================\n');
    fprintf('Thruster performance range due to machining tolerances\n');
    fprintf('============================================================\n');
    fprintf('F           = %.6e  to %.6e N\n', state1.F.min, state1.F.max);
    fprintf('Isp         = %.6f  to %.6f s\n', state1.Isp.min, state1.Isp.max);
    fprintf('Iv          = %.6f  to %.6f N.s/m^3\n', state1.Iv.min, state1.Iv.max);
    fprintf('Psp         = %.6f  to %.6f W/mN\n', state1.W_per_mN.min, state1.W_per_mN.max);
    fprintf('%s\n', state1.suggestion);
    fprintf('============================================================\n');

else
    fprintf('Not a valid nozzle configuration\n');
end
end
%% -------------------------- local functions -------------------------- %%

% ---------------------------- Gas Constant ----------------------------- %
function R = R_species(species)
% Calculates the gas constant using CoolProp
prop = resolvePropellant(species);
db = propellantDB();
if isfield(db, prop.dbField)
    data = db.(prop.dbField);
else
    data = [];
end
Ru = 8.31446261815324;
if prop.useCoolProp
    M = double(py.CoolProp.CoolProp.PropsSI('M', prop.cpName));
else
    if isempty(data)
        R = nan;
        return;
    end
    M = data.M;
end
R = Ru/M;
end

% ------------- Specific heat capacity at constant pressure ------------- %
function cp = cpSpecies(T, P, species)
% Calculates Cp using CoolProp or NASA polynomials
prop = resolvePropellant(species);
db = propellantDB();
if isfield(db, prop.dbField)
    data = db.(prop.dbField);
else
    data = [];
end
if prop.useCoolProp
    cp = double(py.CoolProp.CoolProp.PropsSI( ...
        'Cpmass', 'T', T, 'P', P, prop.cpName));
else
    if isempty(data)
        cp = nan;
        return;
    end
    if T < data.Tmin || T > data.Tmax
        cp = nan;
        return;
    end
    if T < data.Tmid
        a = data.low;
    else
        a = data.high;
    end
    Ru = 8.31446261815324;
    cp_over_Ru = a(1) + a(2)*T + a(3)*T^2 + a(4)*T^3 + a(5)*T^4;
    cp = (Ru/data.M)*cp_over_Ru;
end
end

% -------------------------- Species Enthalpy --------------------------- %
function h = hSpecies(T, P, species)
% Returns specific enthalpy
prop = resolvePropellant(species);
db = propellantDB();
if isfield(db, prop.dbField)
    data = db.(prop.dbField);
else
    data = [];
end
if prop.useCoolProp
    % Use CoolProp
    h = double(py.CoolProp.CoolProp.PropsSI('Hmass', 'T', T, 'P', P, prop.cpName)); % J/kg
else
    if isempty(data)
        h = nan;
        return;
    end
    % Use NASA-7 polynomials
    if T < data.Tmin || T > data.Tmax
        h = nan;
        return;
    end
    if T < data.Tmid
        a = data.low;
    else
        a = data.high;
    end
    Ru = 8.31446261815324; % J/mol/K

    h_over_RuT = a(1) ...
               + a(2)*T/2 ...
               + a(3)*T^2/3 ...
               + a(4)*T^3/4 ...
               + a(5)*T^4/5 ...
               + a(6)/T;
    
    h_molar = Ru * T * h_over_RuT; % J/mol
    h = h_molar / data.M;          % J/kg

    % Approximate iodine sublimation correction
    if strcmpi(prop.dbField, 'I2')
        T_sub = 386.85;         % K, approximate iodine sublimation point near 1 atm
        h_sub = 62000 / data.M; % J/kg, 62 kJ/mol converted using kg/mol
        if T >= T_sub
            h = h + h_sub;      % J/kg
        end
    end
end
end
% ---------------------------- Exit Pressure ---------------------------- %
function [pe, Me, gamma, R, cp, eps] = exitPressure(T0, p0, rt, re, species)
R  = R_species(species);         % Specific gas constant
cp = cpSpecies(T0, p0, species); % Specific heat capacity
gamma = cp / (cp - R);           % Heat capacity ratio
eps = (re/rt)^2;                 % Nozzle expansion area ratio 

% Area ratio-mach function
areaMach = @(M) (1./M) .* ...
    ((2/(gamma+1)).*(1 + (gamma-1)/2.*M.^2)).^((gamma+1)/(2*(gamma-1)));
% Solve for supersonic exit Mach
f = @(M) areaMach(M) - eps;
if eps <= 1 + 1e-8
    Me = 1.0;
else
    Mlo = 1 + 1e-8;
    Mhi = 5;
    while f(Mhi) < 0
        Mhi = 2*Mhi;
    end
    Me = fzero(f, [Mlo, Mhi]); % initial guess >1 (supersonic) 
end  

% Calculate pressure ratio
pe_p0 = (1 + (gamma-1)/2*Me^2)^(-gamma/(gamma-1));

% Calculate exit pressure
pe = p0 * pe_p0;
end

function [pe, Me] = exitPressureGivenGamma(p0, rt, re, gamma)
eps = (re/rt)^2;
areaMach = @(M) (1./M) .* ...
    ((2/(gamma+1)).*(1 + (gamma-1)/2.*M.^2)).^((gamma+1)/(2*(gamma-1)));
if eps <= 1 + 1e-8
    Me = 1.0;
else
    f = @(M) areaMach(M) - eps;
    Mlo = 1 + 1e-8;
    Mhi = 5;
    while f(Mhi) < 0
        Mhi = 2*Mhi;
    end
    Me = fzero(f, [Mlo, Mhi]);
end
pe = p0 * (1 + (gamma-1)/2*Me^2)^(-gamma/(gamma-1));
end

% -------------------------- Exhaust Velocity --------------------------- %
function ve = exhaustVelocity(T0, p0, rt, re, species)
R  = R_species(species);                % Specific gas constant
cp = cpSpecies(T0, p0, species);             % Specific heat capacity
gamma = cp / (cp - R);                  % Heat capacity ratio
pe = exitPressure(T0,p0,rt,re,species); % Calculate exit pressure
pr = pe / p0;                           % Pressure ratio

% Calculate exhaust velocity (m/s)
ve = sqrt( (2*gamma/(gamma-1)) * R * T0 * (1 - pr^((gamma-1)/gamma)) );
end


% -------------------------- Specific Impulse --------------------------- %
function Isp = specificImpulse(T0, p0, rt, re, species)
g = 9.80665; % Gravitational acceleration (m/s^2)
ve = exhaustVelocity(T0, p0, rt, re, species); % Exhaust velocity (m/s)
Isp = ve / g; % Calculate specific impulse
end


% --------------------------- Mass Flow Rate ---------------------------- %
function m_dot = massFlowRate(T0,p0,rt,re,species)
At = pi * rt^2;                  % Throat area (m^2)
R  = R_species(species);         % Specific gas constant
cp = cpSpecies(T0, p0, species); % Specific heat capacity
gamma = cp / (cp - R);           % Heat capacity ratio

pe = exitPressure(T0,p0,rt,re,species);
pcrit = (2/(gamma+1))^(gamma/(gamma-1));
if (pe/p0) > pcrit
    m_dot = nan;
    return
end

% Calculate mass flow rate
m_dot = At*p0*gamma*sqrt( ((2/(gamma+1))^((gamma+1)/(gamma-1))) / ...
    (gamma*R*T0) );
end


% ------------------------------- Thrust -------------------------------- %
function F = thrust(T0, p0, pa, rt, re, species)
m_dot = massFlowRate(T0, p0, rt, re, species);
ve = exhaustVelocity(T0, p0, rt, re, species);
Ae = pi * re^2;
[pe, ~] = exitPressure(T0, p0, rt, re, species);

if isnan(m_dot) || isnan(ve) || isnan(pe)
    F = nan;
    return
end

F = m_dot*ve + (pe-pa)*Ae;
end

% ---------------------------- Phase String ----------------------------- %
function ph = phaseString(T, p, species)

if strcmpi(species, "Iodine") || strcmpi(species, "I2")
    gas = iodinePhaseChecker(p, T);

    if gas
        ph = "iodine gas";
    else
        ph = "iodine not gas";
    end
else
    prop = resolvePropellant(species);
    ph = lower(char(py.CoolProp.CoolProp.PhaseSI('T', T, 'P', p, prop.cpName)));
end

end

% ----------------------------- Gas Check ------------------------------- %
function tf = isGasPhase(ph)

ph = lower(string(ph));

if contains(ph, "iodine gas")
    tf = true;
elseif contains(ph, "iodine not gas")
    tf = false;
else
    tf = contains(ph,'gas') || contains(ph,'supercritical');
end

end

% ----------------------------- Viscosity ------------------------------- %
function mu = viscositySpecies(T, P, species)
% Dynamic viscosity [Pa.s]

prop = resolvePropellant(species);
db = propellantDB();

if isfield(db, prop.dbField)
    data = db.(prop.dbField);
else
    data = [];
end

if prop.useCoolProp
    mu = double(py.CoolProp.CoolProp.PropsSI( ...
        'VISCOSITY', 'T', T, 'P', P, prop.cpName));
else
    if ~isempty(data) && isfield(data, 'mu')
        mu = data.mu;
    else
        mu = nan;
    end
end
end

% -------------------------- Thruster State ----------------------------- %
function state = thrusterState(T_tank, P_tank, T0, p0, pa, ri, rt, re, species)

g = 9.80665;
At = pi * rt^2;
Ae = pi * re^2;

state = struct();

% Default values
state.valid = false;
state.species = species;
state.rho_storage = nan;
state.T0 = T0;
state.p0 = p0;
state.pa = pa;
state.R = nan;
state.cp = nan;
state.gamma = nan;
state.pt = nan;
state.Tt = nan;
state.pe = nan;
state.Te = nan;
state.Me = nan;
state.ve = nan;
state.m_dot = nan;
state.F = nan;
state.Isp = nan;
state.Iv = nan;
state.W_per_mN = nan;
state.phase_chamber = "";
state.phase_throat = "";
state.phase_exit = "";
state.Re_inlet  = nan;
state.Re_throat = nan;
state.Re_exit   = nan;
% Invalid nozzle geometry check
if rt <= 0 || re <= 0 || re < rt
    state.phase_chamber = "invalid geometry";
    state.phase_throat  = "invalid geometry";
    state.phase_exit    = "invalid geometry";
    return
end

% First check chamber phase before asking for cp
ph0 = phaseString(T0, p0, species);
state.phase_chamber = ph0;

if ~isGasPhase(ph0)
    return
end

% Only now continue with property calculations
R  = R_species(species);
cp = cpSpecies(T0, p0, species);

gamma = cp / (cp - R);

pt = p0 * (2/(gamma+1))^(gamma/(gamma-1));
Tt = 2*T0 / (gamma+1);

% Exit pressure and exit Mach
[pe, Me] = exitPressureGivenGamma(p0, rt, re, gamma);
Te = T0 * (pe/p0)^((gamma-1)/gamma);

pht = phaseString(Tt, pt, species);
phe = phaseString(Te, pe, species);

state.phase_throat = pht;
state.phase_exit   = phe;

if ~(isGasPhase(pht) && isGasPhase(phe))
    state.cp = cp;
    state.R = R;
    state.gamma = gamma;
    state.pt = pt;
    state.Tt = Tt;
    state.pe = pe;
    state.Te = Te;
    state.Me = Me;
    return
end

m_dot = At*p0*gamma*sqrt(((2/(gamma+1))^((gamma+1)/(gamma-1))) / ...
    (gamma*R*T0));

ve = sqrt((2*gamma/(gamma-1)) * R * T0 * (1 - (pe/p0)^((gamma-1)/gamma)));
F = m_dot*ve + (pe-pa)*Ae;
Isp = F / (m_dot * g); % Specific impulse

% Reynolds numbers
mu0 = viscositySpecies(T0, p0, species);
mut = viscositySpecies(Tt, pt, species);
mue = viscositySpecies(Te, pe, species);
Ai = pi * ri^2;
Re_inlet  = m_dot * (2*ri) / (Ai * mu0);
Re_throat = m_dot * (2*rt) / (At * mut);
Re_exit   = m_dot * (2*re) / (Ae * mue);

prop = resolvePropellant(species);
db   = propellantDB();
if isfield(db, prop.dbField)
    speciesData = db.(prop.dbField);
else
    speciesData = [];
    if ~prop.useCoolProp
        error('Species is missing from propellantDB()');
    end
end

% Storage density
rho_storage = nan;
try
    if prop.useCoolProp
        rho_storage = double(py.CoolProp.CoolProp.PropsSI( ...
            'Dmass','T',T_tank,'P',P_tank,prop.cpName));
    elseif ~isempty(speciesData) && isfield(speciesData, 'rho_storage')
        rho_storage = speciesData.rho_storage;
    end
catch ME
    warning('Could not calculate tank density for %s: %s', species, ME.message);
end
Iv = rho_storage * Isp * g; % Volumetric impulse

h_in = hSpecies(T_tank, P_tank, species);
h_0  = hSpecies(T0, p0, species);
delta_h = h_0 - h_in;
P_prop  = m_dot * delta_h;
W_per_mN = P_prop / (F * 1000); % Specific power in W/mN

state.valid = true;
state.rho_storage = rho_storage;
state.R = R;
state.cp = cp;
state.gamma = gamma;
state.pt = pt;
state.Tt = Tt;
state.pe = pe;
state.Te = Te;
state.Me = Me;
state.ve = ve;
state.m_dot = m_dot;
state.F = F;
state.Isp = Isp;
state.Iv = Iv;
state.W_per_mN = W_per_mN;
state.Re_inlet  = Re_inlet;
state.Re_throat = Re_throat;
state.Re_exit   = Re_exit;
end

% -------------------- Thruster Sensitivity Analysis -------------------- %
function state = thrusterSensitivity(T_tank, P_tank, T0, p0, pa, ri, rt, re, species, tol)

labels = ["rt-tol, re-tol", "rt-tol, re+tol", "rt+tol, re-tol", ...
    "rt+tol, re+tol"];
states(1) = thrusterState(T_tank, P_tank, T0, p0, pa, ri, rt-tol, re-tol, species);
states(2) = thrusterState(T_tank, P_tank, T0, p0, pa, ri, rt-tol, re+tol, species);
states(3) = thrusterState(T_tank, P_tank, T0, p0, pa, ri, rt+tol, re-tol, species);
states(4) = thrusterState(T_tank, P_tank, T0, p0, pa, ri, rt+tol, re+tol, species);

state.cases = states;
state.labels = labels;

valid = [states.valid];

if any(~valid)
    warning('Machining tolerance creates invalid cases in %d of 4 cases.', sum(~valid));

    for k = find(~valid)
        warning('Invalid case %d: %s | chamber=%s, throat=%s, exit=%s', ...
            k, labels(k), ...
            states(k).phase_chamber, ...
            states(k).phase_throat, ...
            states(k).phase_exit);
    end

    state.condensationRisk = true;
else
    state.condensationRisk = false;
end

F        = [state.cases.F];
Isp      = [state.cases.Isp];
Iv       = [state.cases.Iv];
W_per_mN = [state.cases.W_per_mN];

% Treat invalid thrust cases as zero possible thrust
F(~valid) = 0;

% Treat invalid performance ratios as undefined
Isp(~valid)      = NaN;
Iv(~valid)       = NaN;
W_per_mN(~valid) = NaN;

state.F.max        = max(F);
state.F.min        = min(F);
state.Isp.max      = max(Isp,[],'omitnan');
state.Isp.min      = min(Isp,[],'omitnan');
state.Iv.max       = max(Iv,[],'omitnan');
state.Iv.min       = min(Iv,[],'omitnan');
state.W_per_mN.max = max(W_per_mN,[],'omitnan');
state.W_per_mN.min = min(W_per_mN,[],'omitnan');

if state.condensationRisk
    state.suggestion = "Some tolerance cases are invalid or non-gaseous. Reduce tolerance, reduce expansion ratio, increase T0, or adjust rt/re.";
else
    state.suggestion = "All tolerance corner cases remain valid and gas-phase.";
end
end