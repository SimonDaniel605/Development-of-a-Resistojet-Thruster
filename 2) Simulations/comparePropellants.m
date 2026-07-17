%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   comparePropellants.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           May 2026
%   Version:        2.2
%   Project:        Development of a Resistojet Thruster
%   Description:    
%   This function compares multiple propellants for a resistojet over a
%   temperature range by redesigning a feasible nozzle independently for 
%   each propellant-temperature combination. It evaluates and plots 
%   specific impulse, volumetric impulse, specific power, and volumetric 
%   impulse per specific power against chamber temperature for a specified 
%   chamber pressure, target thrust, species list, and storage state.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function results = comparePropellants(opts, speciesList)

propList = speciesList;
Tvec     = opts.Tvec;
db       = propellantDB();
dbFields = string(fieldnames(db));

% Preallocate results 
nProp = numel(propList);
nT    = numel(Tvec);

results = struct();
% Metadata
results.propList    = propList;             % List of propellant names
results.dbField     = strings(nProp, 1);    % Database field name
results.cpName      = strings(nProp, 1);    % CoolProp fluid name
results.useCoolProp = false(nProp, 1);      % Flag for CoolProp usage
% Independent Variables
results.Tvec        = Tvec;                 % Temperature sweep vector (K)
% Storage Properties
results.rho_tank       = nan(nProp, 1);     % Storage density at tank conditions (kg/m^3)
results.Psat_300K_kPa  = nan(nProp, 1);     % Saturation pressure at 300 K (kPa)
results.rho_300K       = nan(nProp, 1);     % Density at 300 K saturation (kg/m^3)
% Performance Metrics
results.Isp         = nan(nProp, nT);       % Specific impulse (s)
results.Iv          = nan(nProp, nT);       % Volumetric impulse (N·s/m^3)
results.Iv_300K     = nan(nProp, 1);        % Volumetric impulse at 300 K
results.Iv_700K     = nan(nProp, 1);        % Volumetric impulse at 700 K
results.mdot        = nan(nProp, nT);       % Mass flow rate (kg/s)
% Nozzle Geometry
results.rt          = nan(nProp, nT);       % Throat radius (m]
results.re          = nan(nProp, nT);       % Exit radius (m)
results.At          = nan(nProp, nT);       % Throat area (m^2)
results.Ae          = nan(nProp, nT);       % Exit area (m^2)
results.eps         = nan(nProp, nT);       % Expansion ratio
% Flow Properties
results.pe          = nan(nProp, nT);       % Exit pressure (Pa)
results.Te          = nan(nProp, nT);       % Exit temperature (K)
results.ve          = nan(nProp, nT);       % Exit velocity (m/s)
results.Me          = nan(nProp, nT);       % Exit Mach number
results.gamma       = nan(nProp, nT);       % Specific heat ratio
% Power Usage
results.delta_h     = nan(nProp, nT);       % Enthalpy rise (J/kg)
results.P_prop      = nan(nProp, nT);       % Heating power (W)
results.W_per_mN    = nan(nProp, nT);       % Power per thrust (W/mN)
% Combined Metric
results.powerVolScore = nan(nProp, nT);     % Iv / (W/mN)
% Feasibility flag
results.success     = false(nProp, nT);     % Feasibility flag
% Plot Styling
results.color      = nan(nProp, 3);        
results.colorName  = strings(nProp, 1);
results.lineStyle  = strings(nProp, 1);

% Main loop
for i = 1:nProp
    speciesLabel = propList{i};
    prop = resolvePropellant(speciesLabel);
    results.dbField(i)     = string(prop.dbField);
    results.cpName(i)      = string(prop.cpName);
    results.useCoolProp(i) = logical(prop.useCoolProp);
    results.color(i,:)    = prop.color;
    results.colorName(i)  = string(prop.colorName);
    results.lineStyle(i)  = string(prop.lineStyle);
    % Only require a database entry when it is needed
    hasDBEntry = any(dbFields == string(prop.dbField));
    if hasDBEntry
        speciesData = db.(prop.dbField);
    else
        speciesData = [];
        if ~prop.useCoolProp
            error('comparePropellants:MissingDBField', ...
                ['Species "%s" resolves to database field "%s", but that field ' ...
                 'does not exist in propellantDB().'], ...
                speciesLabel, prop.dbField);
        end
    end    
    try
        if prop.useCoolProp
            results.rho_tank(i) = rhoCP(opts.tank.T, opts.tank.P, prop.cpName);
        elseif ~isempty(speciesData) && isfield(speciesData, 'rho_storage')
            results.rho_tank(i) = speciesData.rho_storage;
        else
            warning('No storage density available for %s. Volumetric impulse will be left as NaN.', ...
                speciesLabel);
            results.rho_tank(i) = nan;
        end
    catch ME
        warning('Failed to get tank density for %s: %s', speciesLabel, ME.message);
        results.rho_tank(i) = nan;
    end
    
    % Storage saturation pressure and storage density at 300 K
    try
        if prop.useCoolProp
            Tcrit = double(py.CoolProp.CoolProp.PropsSI('Tcrit', prop.cpName));
            Ttrip = double(py.CoolProp.CoolProp.PropsSI('Ttriple', prop.cpName));
            if 300 > Ttrip && 300 < Tcrit
                Psat = double(py.CoolProp.CoolProp.PropsSI('P','T',300,'Q',0,prop.cpName));
                rhoL = double(py.CoolProp.CoolProp.PropsSI('Dmass','T',300,'Q',0,prop.cpName));
                results.Psat_300K_kPa(i) = Psat / 1e3;
                results.rho_300K(i)      = rhoL;
            else
                results.Psat_300K_kPa(i) = nan;
                results.rho_300K(i)      = nan;
            end
        elseif strcmpi(prop.dbField, 'I2')
            results.Psat_300K_kPa(i) = nan;
            results.rho_300K(i)      = 4930;   % solid iodine density [kg/m^3]
        else
            results.Psat_300K_kPa(i) = nan;
            results.rho_300K(i)      = nan;
        end
    catch ME
        warning('Storage properties failed for %s: %s', speciesLabel, ME.message);
        results.Psat_300K_kPa(i) = nan;
        results.rho_300K(i)      = nan;
    end

    fprintf('Processing %s...\n', speciesLabel);

    for j = 1:nT
        optsLocal = opts;
        optsLocal.species     = speciesLabel;
        optsLocal.T0          = Tvec(j);
        optsLocal.speciesMeta = prop;
        optsLocal.speciesData = speciesData;

        try
            design = thrusterDesigner(optsLocal);
            if isnan(design.Isp)
                results.success(i,j) = false;
                continue;
            end
            results.Isp(i,j)     = design.Isp;
            if ~isnan(results.rho_tank(i))
                results.Iv(i,j) = results.rho_tank(i) * design.Isp * 9.80665;
            end
            results.mdot(i,j)    = design.mdot;
            results.rt(i,j)      = design.rt;
            results.re(i,j)      = design.re;
            results.At(i,j)      = design.At;
            results.Ae(i,j)      = design.Ae;
            results.eps(i,j)     = design.eps;
            results.pe(i,j)      = design.pe;
            results.Te(i,j)      = design.Te;
            results.ve(i,j)      = design.ve;
            results.Me(i,j)      = design.Me;
            results.gamma(i,j)   = design.gamma;
            results.success(i,j) = true;

            % Propellant heating power using enthalpy rise
            Tin = opts.tank.T;
            pin = opts.tank.P;

            h_in = hSpecies(Tin, pin, prop, speciesData);
            h_0  = hSpecies(Tvec(j), opts.p0, prop, speciesData);

            delta_h = h_0 - h_in;
            P_prop  = design.mdot * delta_h;

            results.delta_h(i,j)  = delta_h;
            results.P_prop(i,j)   = P_prop;
            results.W_per_mN(i,j) = P_prop / (opts.F_des * 1000);
            if ~isnan(results.Iv(i,j)) && results.W_per_mN(i,j) > 0
                results.powerVolScore(i,j) = results.Iv(i,j) / results.W_per_mN(i,j);
            end
        catch ME
            warning('Failed for %s at T0 = %.1f K: %s', speciesLabel, Tvec(j), ME.message);
            results.success(i,j) = false;
        end
    end
end

% Extract volumetric impulse at 300 K and 700 K
idx300 = find(results.Tvec == 300, 1);
idx700 = find(results.Tvec == 700, 1);
results.Iv_300K = results.Iv(:, idx300);
results.Iv_700K = results.Iv(:, idx700);

% Print storage and performance summary
fprintf('\nChamber pressure: %.3g bar\n', opts.p0/1e5);

fprintf('\n%-20s %-20s %-25s %-25s %-25s\n', ...
    'Species', 'Psat @300K [kPa]', 'Storage Density [kg/m^3]', ...
    sprintf('Iv @%.0fK [N.s/m^3]', results.Tvec(idx300)), ...
    sprintf('Iv @%.0fK [N.s/m^3]', results.Tvec(idx700)));
fprintf('%s\n', repmat('-',1,120));
for i = 1:nProp
    Psat = results.Psat_300K_kPa(i);
    rho  = results.rho_300K(i);
    Iv300 = results.Iv_300K(i);
    Iv700 = results.Iv_700K(i);
    if isnan(Psat), Psat_str = 'N/A'; else, Psat_str = sprintf('%.3g', Psat); end
    if isnan(rho),  rho_str  = 'N/A'; else, rho_str  = sprintf('%.3f', rho); end
    if isnan(Iv300), Iv300_str = 'N/A'; else, Iv300_str = sprintf('%.3g', Iv300); end
    if isnan(Iv700), Iv700_str = 'N/A'; else, Iv700_str = sprintf('%.3g', Iv700); end

    fprintf('%-20s %-20s %-25s %-25s %-25s\n', ...
        results.propList{i}, Psat_str, rho_str, Iv300_str, Iv700_str);
end
% Print top propellants by volumetric impulse
printTopIv(results.propList, results.Iv_300K, results.Tvec(idx300));
printTopIv(results.propList, results.Iv_700K, results.Tvec(idx700));

% Plot Specific Impulse against Temperature
figure;
hold on;
grid on;
box on;
for i = 1:nProp
    mask = results.success(i,:);
    plot(results.Tvec(mask), results.Isp(i,mask), ...
        'LineWidth', 1.8, ...
        'Color', results.color(i,:), ...
        'LineStyle', results.lineStyle(i), ...
        'DisplayName', results.propList{i});
end
xlabel('Chamber Temperature, T_0 [K]');
ylabel('Specific Impulse, I_{sp} [s]');
title('Specific Impulse vs Temperature');
legend('Location','best');
hold off;

% Plot Volumetric Impulse against Temperature
figure;
hold on;
grid on;
box on;
for i = 1:nProp
    mask = results.success(i,:) & ~isnan(results.Iv(i,:));
    plot(results.Tvec(mask), results.Iv(i,mask), ...
        'LineWidth', 1.8, ...
        'Color', results.color(i,:), ...
        'LineStyle', results.lineStyle(i), ...
        'DisplayName', results.propList{i});
end
xlabel('Chamber Temperature, T_0 [K]');
ylabel('Volumetric Impulse, I_v [N·s/m^3]');
title('Volumetric Impulse vs Temperature');
legend('Location','best');
hold off;

% Plot Specific Power against Temperature
figure;
hold on;
grid on;
box on;
for i = 1:nProp
    mask = results.success(i,:) & ~isnan(results.W_per_mN(i,:));
    plot(results.Tvec(mask), results.W_per_mN(i,mask), ...
        'LineWidth', 1.8, ...
        'Color', results.color(i,:), ...
        'LineStyle', results.lineStyle(i), ...
        'DisplayName', results.propList{i});
end
xlabel('Chamber Temperature, T_0 [K]');
ylabel('Propellant Heating Power per Thrust (Specific Power) [W/mN]');
title('Specific Power vs Temperature');
legend('Location','best');
hold off;

% Plot Volumetric Impulse per unit of Specific Power against Temperature
figure;
hold on;
grid on;
box on;
for i = 1:nProp
    mask = results.success(i,:) ...
        & ~isnan(results.powerVolScore(i,:)) ...
        & results.powerVolScore(i,:) > 0;
    plot(results.Tvec(mask), results.powerVolScore(i,mask), ...
        'LineWidth', 1.8, ...
        'Color', results.color(i,:), ...
        'LineStyle', results.lineStyle(i), ...
        'DisplayName', results.propList{i});
end
xlabel('Chamber Temperature, T_0 [K]');
ylabel('I_v / (W/mN)');
title('Volumetric Impulse per unit of Specific Power vs Temperature');
legend('Location','best');
hold off;
end

%% -------------------------- local functions -------------------------- %%

% ------------- Specific heat capacity at constant pressure ------------- %
function cp = cpSpecies(T, P, prop, data)
% Returns cp using CoolProp or NASA-7 polynomials
if prop.useCoolProp
    % Use CoolProp
    cp = double(py.CoolProp.CoolProp.PropsSI('Cpmass', 'T', T, 'P', P, prop.cpName)); % J/(kg.K)
else
    if isempty(data)
        cp = nan;
        return;
    end
    % Use NASA-7 polynomials
    if T < data.Tmin || T > data.Tmax
        cp = nan; 
        return;
    end

    if T < data.Tmid
        a = data.low;
    else
        a = data.high;
    end
    cp_over_Ru = a(1) + a(2)*T + a(3)*T^2 + a(4)*T^3 + a(5)*T^4;
    Ru = 8.31446261815324;              % J/mol/K
    cp = (Ru / data.M) * cp_over_Ru;    % J/(kg.K)
end
end

% ------------------------ Species Gas Constant ------------------------- %
function R = R_species(prop, data)
% Returns specific gas constant
Ru = 8.31446261815324; % J/mol/K
if prop.useCoolProp
    % Use CoolProp
    M = double(py.CoolProp.CoolProp.PropsSI('M', prop.cpName)); % kg/mol
else
    if isempty(data)
        R = nan;
        return;
    end
     M = data.M;    % kg/mol
end
R  = Ru / M;        % J/(kg.K)
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

% ------------------------ Empty Design Structure ----------------------- %
function design = emptyDesign()
design.rt    = nan;
design.re    = nan;
design.At    = nan;
design.Ae    = nan;
design.eps   = nan;
design.Me    = nan;
design.pe    = nan;
design.Te    = nan;
design.ve    = nan;
design.mdot  = nan;
design.Isp   = nan;
design.gamma = nan;
end

% --------------------- Print Top Volumetric Impulse -------------------- %
function printTopIv(propList, IvValues, Tlabel)
validMask = ~isnan(IvValues) & IvValues > 0;
validIv   = IvValues(validMask);
validProp = propList(validMask);
[sortedIv, idx] = sort(validIv, 'descend');
sortedProp = validProp(idx);
nPrint = min(15, numel(sortedIv));

fprintf('\nTop %d propellants by volumetric impulse at %.0f K:\n', nPrint, Tlabel);
fprintf('%-5s %-20s %-25s\n', 'Rank', 'Species', 'Iv [N.s/m^3]');
fprintf('%s\n', repmat('-',1,55));
for k = 1:nPrint
    fprintf('%-5d %-20s %-25.3g\n', k, sortedProp{k}, sortedIv(k));
end
end

% --------------------- Candidate Nozzle Calculator --------------------- %
function state = candidateThruster(pe, T0, p0, pa, F_des, re_max, R, gamma, prop)
% Calculates nozzle state for a chosen exit pressure and checks feasibility

% Calculate exit conditions
Me = sqrt((2/(gamma-1)) * ((p0/pe)^((gamma-1)/gamma) - 1));
Te = T0 / (1 + (gamma-1)/2 * Me^2);
ve = Me * sqrt(gamma * R * Te);

% Nozzle expansion ratio
eps = (1/Me) * ((2/(gamma+1)) * (1 + (gamma-1)/2 * Me^2))^((gamma+1)/(2*(gamma-1)));

% Choked mass flux parameter
G = p0 * sqrt(gamma/(R*T0)) * (2/(gamma+1))^((gamma+1)/(2*(gamma-1)));

% Calculate nozzle dimensions from F = At*(G*ve + (pe-pa)*eps)
den = G * ve + (pe - pa) * eps;
At  = F_des / den;
Ae  = eps * At;

rt = sqrt(At/pi);
re = sqrt(Ae/pi);

% Exit phase check
if prop.useCoolProp
    ph = lower(char(py.CoolProp.CoolProp.PhaseSI('T', Te, 'P', pe, prop.cpName)));
    isGas = contains(ph, 'gas') || contains(ph, 'supercritical');

elseif strcmpi(prop.dbField, 'I2')
    isGas = iodinePhaseChecker(pe, Te);
else
    % Other ideal-gas/NASA species: no phase check available
    isGas = true;
end

state.pe    = pe;
state.Me    = Me;
state.Te    = Te;
state.ve    = ve;
state.eps   = eps;
state.At    = At;
state.Ae    = Ae;
state.rt    = rt;
state.re    = re;
state.G     = G;
state.isGas = isGas;

state.feasible = isGas ...
    && isreal(Me) && isreal(Te) && isreal(ve) ...
    && isreal(rt) && isreal(re) ...
    && At > 0 && Ae > 0 ...
    && den > 0 ...
    && re <= re_max;
end

% ------------------------ Final Nozzle Selector ------------------------ %
function design = thrusterDesigner(opts)
% Designs a feasible nozzle for the given propellant and chamber state
prop    = opts.speciesMeta;
data    = opts.speciesData;
T0      = opts.T0;
p0      = opts.p0;
pa      = opts.environment.pa;
re_max  = opts.re_max;
F_des   = opts.F_des;

if ~prop.useCoolProp && isempty(data)
    design = emptyDesign();
    return;
end

% Check chamber phase before calculating gas properties
if prop.useCoolProp
    try
        ph0 = lower(char(py.CoolProp.CoolProp.PhaseSI('T', T0, 'P', p0, prop.cpName)));
        chamberIsGas = contains(ph0, 'gas') || contains(ph0, 'supercritical');
    catch
        chamberIsGas = false;
    end
elseif strcmpi(prop.dbField, 'I2')
    chamberIsGas = iodinePhaseChecker(p0, T0);
else
    chamberIsGas = true;
end
if ~chamberIsGas
    design = emptyDesign();
    return;
end

% Bisection to find most feasible nozzle state
tol     = 1e-3;
maxIter = 40;
pe_lo = pa;
pe_hi = 0.9 * p0;
R     = R_species(prop, data);
cp    = cpSpecies(T0, p0, prop, data);
gamma = cp / (cp - R);
lo = candidateThruster(pe_lo, T0, p0, pa, F_des, re_max, R, gamma, prop);
hi = candidateThruster(pe_hi, T0, p0, pa, F_des, re_max, R, gamma, prop);

if lo.feasible
    best = lo;
else
    if ~hi.feasible
        design = emptyDesign();
        return;
    end
    best = hi;
    for k = 1:maxIter
        pe_mid = 0.5 * (pe_lo + pe_hi);
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

design.rt    = best.rt;
design.re    = best.re;
design.At    = best.At;
design.Ae    = best.Ae;
design.eps   = best.eps;
design.Me    = best.Me;
design.pe    = best.pe;
design.Te    = best.Te;
design.ve    = best.ve;
design.mdot  = best.At * best.G;
design.Isp   = best.ve / 9.80665;
design.gamma = gamma;
end