%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   nozzleDesigner.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           May 2026
%   Version:        2.0
%   Project:        Development of a Resistojet Thruster
%   Description:    
%   This file calculates the required nozzle geometries in order to achieve
%   a desired thrust for a thruster with a specified propellant, chamber
%   pressure and temperature, and ambient pressure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function design = nozzleDesigner(req)
speciesLabel = req.species;
prop = resolvePropellant(speciesLabel);
db   = propellantDB();
if isfield(db, prop.dbField)
    speciesData = db.(prop.dbField);
else
    speciesData = [];
    if ~prop.useCoolProp
        error('Species is missing from propellantDB()');
    end
end
Tin     = req.tank.T;
pin     = req.tank.P;
T0      = req.T0;
p0      = req.p0;
pa      = req.environment.pa;
re_max  = req.re_max;
F_des   = req.F_des;

% Check chamber phase check
if prop.useCoolProp
    try
        ph0 = lower(char(py.CoolProp.CoolProp.PhaseSI('T', T0, 'P', p0, prop.cpName)));
        chamberIsGas = contains(ph0, 'gas') || contains(ph0, 'supercritical');
    catch ME
        warning('Failed to check chamber phase for %s: %s', req.species, ME.message);
        chamberIsGas = false;
    end
elseif strcmpi(prop.dbField, 'I2')
    chamberIsGas = iodinePhaseChecker(p0, T0);
else
    % NASA polynomial species are treated as ideal gases.
    chamberIsGas = true;
end
if ~chamberIsGas
    error('Chamber state is not gas/supercritical for %s at T0 = %.3f K and p0 = %.3f Pa.', req.species, T0, p0);
end

tol = 1e-3;       % Pa
maxIter = 50;

pe_lo = max(pa, 1e-9);
pe_hi = 0.9*p0;

R  = R_species(prop, speciesData);         % Specific gas constant
cp = cpSpecies(T0, p0, prop, speciesData); % Specific heat capacity
gamma = cp / (cp - R);

lo = candidateThruster(pe_lo, T0, p0, pa, F_des, re_max, R, gamma, prop);
hi = candidateThruster(pe_hi, T0, p0, pa, F_des, re_max, R, gamma, prop);

if lo.feasible
    best = lo;
else
    if ~hi.feasible
        error('No feasible nozzle design found within pressure bracket.');
    end
    for k = 1:maxIter
        pe_mid = 0.5*(pe_lo + pe_hi);
        mid = candidateThruster(pe_mid, T0, p0, pa, F_des, re_max, R, gamma, prop);
        if mid.feasible
            pe_hi = pe_mid;
            best = mid;
        else
            pe_lo = pe_mid;
        end
        if abs(pe_hi - pe_lo) < tol
            break;
        end
    end
end
design.rho_tank = nan;
design.gamma    = gamma;
design.cp       = cp;
design.R        = R;
design.rt       = best.rt;
design.re       = best.re;
design.At       = best.At;
design.Ae       = best.Ae;
design.eps      = best.eps;
design.Me       = best.Me;
design.pe       = best.pe;
design.Te       = best.Te;
design.ve       = best.ve;
design.mdot     = best.At * best.G;
design.Isp      = F_des / (design.mdot * 9.80665);
design.Iv       = nan;
design.W_per_mN = nan;

% Storage density
try
    if prop.useCoolProp
        design.rho_tank = rhoCP(Tin, pin, prop.cpName);
    elseif ~isempty(speciesData) && isfield(speciesData, 'rho_storage')
        design.rho_tank = speciesData.rho_storage;
    end
catch ME
    warning('Could not calculate tank density for %s: %s', req.species, ME.message);
end

% Volumetric impulse
if ~isnan(design.rho_tank)
    design.Iv = design.rho_tank * design.Isp * 9.80665;
end

% Specific power in W/mN
h_in = hSpecies(Tin, pin, prop, speciesData);
h_0  = hSpecies(T0, p0, prop, speciesData);
delta_h = h_0 - h_in;
P_prop  = design.mdot * delta_h;
design.W_per_mN = P_prop / (F_des * 1000);
end

%% -------------------------- local functions -------------------------- %%

% ---------------------------- Gas Constant ----------------------------- %
function R = R_species(prop, data)
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
function cp = cpSpecies(T, P, prop, data)
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

% --------------------------- Species Density --------------------------- %
function rho = rhoCP(T, P, species)
% Returns density from CoolProp
rho = double(py.CoolProp.CoolProp.PropsSI('Dmass', 'T', T, 'P', P, species)); % kg/m^3
end

% -------------------------- Species Enthalpy --------------------------- %
function h = hSpecies(T, P, prop, data)
% Returns specific enthalpy
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

% --------------------- Candidate Nozzle Calculator --------------------- %
function state = candidateThruster(pe, T0, p0, pa, F_des, re_max, R, gamma, prop)

Me = sqrt( (2/(gamma-1)) * ( (p0/pe)^((gamma-1)/gamma) - 1 ) );
Te = T0 / (1 + (gamma-1)/2*Me^2);
ve = Me * sqrt(gamma*R*Te);
eps = (1/Me) * ((2/(gamma+1))*(1 + (gamma-1)/2*Me^2))^((gamma+1)/(2*(gamma-1)));

G = p0 * sqrt(gamma/(R*T0)) * (2/(gamma+1))^((gamma+1)/(2*(gamma-1))); % Choked mass-flow parameter: mdot = At * G
At = F_des / (G*ve + (pe - pa)*eps); % Throttle area
rt = sqrt(At/pi);
Ae = eps * At; % Nozzle radii
re = sqrt(Ae/pi);

% Check exit phase check
if prop.useCoolProp
    try
        ph = lower(char(py.CoolProp.CoolProp.PhaseSI('T', Te, 'P', pe, prop.cpName)));
        isGas = contains(ph, 'gas') || contains(ph, 'supercritical');
    catch
        isGas = false;
    end
elseif strcmpi(prop.dbField, 'I2')
    isGas = iodinePhaseChecker(pe, Te);
else
    % Other NASA polynomial species are treated as ideal gases.
    isGas = true; % Be careful making this assumption
end

state.pe = pe;
state.Me = Me;
state.Te = Te;
state.ve = ve;
state.eps = eps;
state.At = At;
state.Ae = Ae;
state.rt = rt;
state.re = re;
state.G = G;
state.isGas = isGas;
state.feasible = isGas ...
    && isreal(Me) && isreal(Te) && isreal(ve) ...
    && isreal(rt) && isreal(re) ...
    && At > 0 && Ae > 0 ...
    && re <= re_max;
end