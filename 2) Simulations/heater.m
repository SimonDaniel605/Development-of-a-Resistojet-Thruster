%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   nozzle.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           July 2026
%   Version:        1.0
%   Project:        Development of a Resistojet Thruster
%   Description:    
%   This file calculates the outlet temperature of the propellant as it
%   exits the heater pipe.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = heater(cfg)
state0 = thrusterState(cfg.tank.T, cfg.tank.P, cfg.T0, cfg.p0, cfg.environment.pa, ...
    cfg.nozzle.ri, cfg.nozzle.rt, cfg.nozzle.re, cfg.species);

out = heater_analyser(cfg, state0.m_dot);
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

% ------------------------------ Viscosity ------------------------------ %
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

% ------------------------------- Density ------------------------------- %
function rho = densitySpecies(T, P, species)
% Density [kg/m^3]

prop = resolvePropellant(species);
db = propellantDB();

if isfield(db, prop.dbField)
    data = db.(prop.dbField);
else
    data = [];
end

if prop.useCoolProp
    rho = double(py.CoolProp.CoolProp.PropsSI( ...
        'Dmass', 'T', T, 'P', P, prop.cpName));
else
    if ~isempty(data) && isfield(data, 'rho')
        rho = data.rho;
    else
        % Ideal gas fallback
        R = R_species(species);
        rho = P/(R*T);
    end
end
end

% ------------------------ Thermal Conductivity ------------------------- %
function k = conductivitySpecies(T, P, species)
% Thermal conductivity [W/m/K]

prop = resolvePropellant(species);

if prop.useCoolProp
    k = double(py.CoolProp.CoolProp.PropsSI( ...
        'CONDUCTIVITY', 'T', T, 'P', P, prop.cpName));
else
    k = nan;
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


% --------------------------- Heater Function --------------------------- %
function out = heater_analyser(cfg, mdot)

N = cfg.heater.N;
dx = cfg.heater.length/N;

Tin = cfg.Tp;
Twall = cfg.heater.Twall;
D     = 2*cfg.heater.ri;
P     = cfg.p0;

T = Tin;

A = pi*D^2/4;
dP_total = 0;
profile.x  = zeros(N+1,1);
profile.x_mid = zeros(N,1);
profile.rho   = zeros(N,1);
profile.dP    = zeros(N,1);
profile.P     = zeros(N+1,1);
profile.P(1)  = P;
profile.T  = zeros(N+1,1);
profile.cp = zeros(N,1);
profile.mu = zeros(N,1);
profile.k  = zeros(N,1);
profile.Re = zeros(N,1);
profile.Pr = zeros(N,1);
profile.Nu = zeros(N,1);
profile.h  = zeros(N,1);
profile.v       = zeros(N,1);
profile.Mach    = zeros(N,1);
profile.f       = zeros(N,1);
profile.q_prime = zeros(N,1);
profile.T(1) = T;

for i = 1:N

    cp_i  = cpSpecies(T, P, cfg.species);
    rho_i = densitySpecies(T, P, cfg.species);
    mu_i  = viscositySpecies(T, P, cfg.species);
    k_i   = conductivitySpecies(T, P, cfg.species);
    v_i   = mdot/(rho_i*A);
    Re_i = rho_i*v_i*D/mu_i;
    Pr_i  = mu_i*cp_i/k_i;

    if Re_i < 2300
        % Darcy friction factor, laminar (Hagen–Poiseuille friction factor
        % relation)
        f_i = 64/Re_i;                     
    else
        % Darcy friction factor, turbulent (Filonenko correlation)
        f_i = (0.79*log(Re_i)-1.64)^(-2); 
    end

    if Re_i < 3000
        % Conservative lower-bound approximation.
        % For laminar flow, Nu = 3.66 corresponds to fully developed flow with
        % constant wall temperature. In the transitional region this deliberately
        % underpredicts heat transfer to avoid overestimating heater performance.
        Nu_i = 3.66;
    elseif (Re_i>=3000) && (Re_i<5e6) && (Pr_i>=0.5) && (Pr_i<=2000) 
        % Use the Gnielinski correlation for upper transitional and turbulent
        % internal flow. This provides more accurate predictions than the
        % Dittus-Boelter correlation over a wider Reynolds number range.
        Nu_i = ((f_i/8)*(Re_i-1000)*Pr_i) / ...
       (1 + 12.7*sqrt(f_i/8)*(Pr_i^(2/3)-1)); % Gnielinski correlation
    else
        warning(['Flow properties are outside the expected range for a '...
        'typical resistojet heater.\n']);
        Nu_i = 3.66;
    end

    h_i = Nu_i*k_i/D;

    % Flow velocity
    v_i = mdot/(rho_i*A);

    % Mach number
    R_i = R_species(cfg.species);
    gamma_i = cp_i/(cp_i - R_i);
    a_i = sqrt(gamma_i*R_i*T);
    Mach_i = v_i/a_i;

    % Local heat transfer rate per unit length [W/m]
    q_prime_i = h_i*pi*D*(Twall - T);

    % Pressure drop
    dP_i = f_i*(dx/D)*(rho_i*v_i^2/2);
    dP_total = dP_total + dP_i;

    P = P - dP_i;

    profile.x_mid(i) = (i-0.5)*dx;
    profile.rho(i)   = rho_i;
    profile.dP(i)    = dP_i;
    profile.P(i+1)   = P;
    profile.v(i)       = v_i;
    profile.Mach(i)    = Mach_i;
    profile.f(i)       = f_i;
    profile.q_prime(i) = q_prime_i;
    % exact segment solution, better than Euler
    NTU_i = h_i*pi*D*dx/(mdot*cp_i);
    T = Twall - (Twall - T)*exp(-NTU_i);

    profile.x(i+1) = i*dx;
    profile.T(i+1) = T;

    profile.cp(i) = cp_i;
    profile.mu(i) = mu_i;
    profile.k(i)  = k_i;
    profile.Re(i) = Re_i;
    profile.Pr(i) = Pr_i;
    profile.Nu(i) = Nu_i;
    profile.h(i)  = h_i;
end

out = struct();
out.Tin = Tin;
out.Tout = T;
out.Twall = Twall;
out.m_dot = mdot;
out.profile = profile;

fprintf('\n============================================================\n');
fprintf('Heater Performance Summary for %s\n', cfg.species);
fprintf('============================================================\n');
fprintf('Tin         = %.3f K\n', Tin);
fprintf('Tout        = %.3f K\n', T);
fprintf('Twall       = %.3f K\n', Twall);
fprintf('m_dot       = %.6e kg/s\n', mdot);
fprintf('Re inlet    = %.6e\n', profile.Re(1));
fprintf('Re outlet   = %.6e\n', profile.Re(end));
fprintf('h inlet     = %.3f W/m^2/K\n', profile.h(1));
fprintf('h outlet    = %.3f W/m^2/K\n', profile.h(end));
fprintf('delta_P     = %.3f Pa\n', dP_total);
fprintf('============================================================\n');


% ----------------------------- Plot Results ----------------------------- %

x_node = profile.x/cfg.heater.length;        % for T and P, length N+1
x_mid  = profile.x_mid/cfg.heater.length;    % for segment properties, length N

% figure;
% plot(x_mid, profile.k, 'LineWidth', 1.5);
% grid on;
% xlabel('x/L');
% ylabel('Thermal conductivity, k [W/m/K]');
% title('Thermal Conductivity Along Heater Pipe');
% 
% figure;
% plot(x_mid, profile.rho, 'LineWidth', 1.5);
% grid on;
% xlabel('x/L');
% ylabel('Density, \rho [kg/m^3]');
% title('Density Along Heater Pipe');
% 
% figure;
% plot(x_mid, profile.mu, 'LineWidth', 1.5);
% grid on;
% xlabel('x/L');
% ylabel('Dynamic viscosity, \mu [Pa.s]');
% title('Dynamic Viscosity Along Heater Pipe');

figure;
plot(x_mid, profile.Re, 'LineWidth', 1.5);
grid on;
xlabel('x/L');
ylabel('Reynolds number, Re [-]');
title('Reynolds Number Along Heater Pipe');

figure;
plot(x_mid, profile.h, 'LineWidth', 1.5);
grid on;
xlabel('x/L');
ylabel('Convection coefficient, h [W/m^2/K]');
title('Convective Heat Transfer Coefficient Along Heater Pipe');

figure;
plot(x_mid, profile.Mach, 'LineWidth', 1.5);
grid on;
xlabel('x/L');
ylabel('Mach number, M [-]');
title('Mach Number Along Heater Pipe');

% figure;
% plot(x_mid, profile.f, 'LineWidth', 1.5);
% grid on;
% xlabel('x/L');
% ylabel('Darcy friction factor, f [-]');
% title('Darcy Friction Factor Along Heater Pipe');

figure;
plot(x_node, cfg.p0 - profile.P, 'LineWidth', 1.5);
grid on;
xlabel('x/L');
ylabel('Cumulative pressure drop, \DeltaP [Pa]');
title('Cumulative Pressure Drop Along Heater Pipe');

figure;
plot(x_mid, profile.q_prime, 'LineWidth', 1.5);
grid on;
xlabel('x/L');
ylabel('Local heat transfer rate, q'' [W/m]');
title('Local Heat Transfer Rate Per Unit Length');

figure;
plot(x_node, profile.T, 'LineWidth', 1.5);
grid on;
xlabel('x/L');
ylabel('Temperature, T [K]');
title('Fluid Temperature Along Heater Pipe');
end