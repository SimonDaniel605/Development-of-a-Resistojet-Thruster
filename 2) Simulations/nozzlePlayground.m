%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   nozzle.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           March 2026
%   Version:        1.0
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
% out.Isp = arrayfun(@(T0) specificImpulse(T0,cfg.p0,cfg.nozzle.rt, ...
%     cfg.nozzle.re,cfg.species),cfg.Tvec);
% out.F   = arrayfun(@(T0) thrust(T0,cfg.p0,cfg.environment.pa, ...
%     cfg.nozzle.rt,cfg.nozzle.re,cfg.species),cfg.Tvec);
% phaseChecker(cfg.T0, cfg.p0, cfg.nozzle.rt, cfg.nozzle.re, cfg.species);
% figure;
% plot(cfg.Tvec, out.Isp, "-");
% xlabel("Temperature (K)");
% ylabel("Specific Impulse (s)");
% grid on;
% figure;
% plot(cfg.Tvec, out.F, "-");
% xlabel("Temperature (K)");
% ylabel("Thrust (N)");
% grid on;
nT = numel(cfg.Tvec);

out.Isp   = nan(size(cfg.Tvec));
out.F     = nan(size(cfg.Tvec));
out.m_dot = nan(size(cfg.Tvec));
out.ve    = nan(size(cfg.Tvec));
out.pe    = nan(size(cfg.Tvec));
out.valid = false(size(cfg.Tvec));

for k = 1:nT
    T0 = cfg.Tvec(k);

    state = thrusterState(T0, cfg.p0, cfg.environment.pa, ...
        cfg.nozzle.rt, cfg.nozzle.re, cfg.species);

    if state.valid
        out.valid(k) = true;
        out.Isp(k)   = state.Isp;
        out.F(k)     = state.F;
        out.m_dot(k) = state.m_dot;
        out.ve(k)    = state.ve;
        out.pe(k)    = state.pe;
    end
end

% Display full properties at cfg.T0 in terminal
state0 = thrusterState(cfg.T0, cfg.p0, cfg.environment.pa, ...
    cfg.nozzle.rt, cfg.nozzle.re, cfg.species);

fprintf('\n============================================================\n');
fprintf('Thruster properties at T0 = %.3f K for %s\n', cfg.T0, cfg.species);
fprintf('============================================================\n');
fprintf('Chamber phase : %s\n', state0.phase_chamber);
fprintf('Throat phase  : %s\n', state0.phase_throat);
fprintf('Exit phase    : %s\n', state0.phase_exit);
fprintf('Valid nozzle state path: %d\n', state0.valid);

if state0.valid
    fprintf('cp      = %.6f J/kg/K\n', state0.cp);
    fprintf('R       = %.6f J/kg/K\n', state0.R);
    fprintf('gamma   = %.6f\n', state0.gamma);
    fprintf('pt      = %.6f Pa\n', state0.pt);
    fprintf('Tt      = %.6f K\n', state0.Tt);
    fprintf('pe      = %.6f Pa\n', state0.pe);
    fprintf('Te      = %.6f K\n', state0.Te);
    fprintf('Me      = %.6f\n', state0.Me);
    fprintf('ve      = %.6f m/s\n', state0.ve);
    fprintf('m_dot   = %.6e kg/s\n', state0.m_dot);
    fprintf('F       = %.6e N\n', state0.F);
    fprintf('Isp     = %.6f s\n', state0.Isp);
else
    fprintf('No performance values printed because chamber/throat/exit are not all gas.\n');
end
fprintf('============================================================\n\n');

figure;
plot(cfg.Tvec, out.Isp, "-");
xlabel("Temperature (K)");
ylabel("Specific Impulse (s)");
grid on;

figure;
plot(cfg.Tvec, out.F, "-");
xlabel("Temperature (K)");
ylabel("Thrust (N)");
grid on;
end


%% -------------------------- local functions -------------------------- %%

% --------------------------- NASA-7 Cp Model --------------------------- %
function cp = cpNASA(T, data)
% Returns ideal-gas cp [J/(kg.K)] from NASA-7 coefficients in propellantDB.

if T < data.Tmin || T > data.Tmax
    error('cpNASA:TemperatureOutOfRange', ...
        'Temperature %.3f K is outside valid range [%.3f, %.3f] K for %s.', ...
        T, data.Tmin, data.Tmax, data.name);
end

if T < data.Tmid
    a = data.low;
else
    a = data.high;
end

cp_over_Ru = a(1) + a(2)*T + a(3)*T^2 + a(4)*T^3 + a(5)*T^4;
Ru = 8.31446261815324; % J/mol/K
cp = (Ru / data.M) * cp_over_Ru;
end

% ------------- Specific heat capacity at constant pressure ------------- %
function cp = cpCP(T, p, species)
% cp in J/kg/K
cp = double(py.CoolProp.CoolProp.PropsSI('Cpmass','T',T,'P',p,species));
end

% ---------------------------- Gas Constant ----------------------------- %
function R = R_CP(species)
Ru = 8.314462618; % J/mol/K
M  = double(py.CoolProp.CoolProp.PropsSI('M', species)); % kg/mol
R  = Ru / M; % J/kg/K
end

% ---------------------------- Exit Pressure ---------------------------- %
function [pe, Me, gamma, R, cp, eps] = exitPressure(T0, p0, rt, re, species)
R = R_CP(species);          % Specific gas constant
cp = cpCP(T0, p0, species); % Specific heat capacity
gamma = cp / (cp - R);      % Heat capacity ratio
eps = (re/rt)^2;            % Nozzle expansion area ratio 

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
R = R_CP(species);                      % Specific gas constant
cp = cpCP(T0, p0, species);             % Specific heat capacity
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
At = pi * rt^2;             % Throat area (m^2)
R = R_CP(species);          % Specific gas constant
cp = cpCP(T0, p0, species); % Specific heat capacity
gamma = cp / (cp - R);      % Heat capacity ratio

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

% % ---------------------------- Phase Checker ---------------------------- %
% function phaseChecker(T0,p0,rt,re,species)
% R = R_CP(species);          % Specific gas constant
% cp = cpCP(T0, p0, species); % Specific heat capacity
% gamma = cp / (cp - R);      % Heat capacity ratio
% 
% % Nozzle throat and exit states
% pt = p0 * (2/(gamma+1))^(gamma/(gamma-1));
% pe = exitPressure(T0,p0,rt,re,species);
% Tt = 2*T0 / (gamma+1);
% Te = T0 * (pe/p0)^((gamma-1)/gamma);
% 
% % Chamber
% ph = lower(char(py.CoolProp.CoolProp.PhaseSI('T',T0,'P',p0,species)));
% if contains(ph,'gas') || contains(ph,'supercritical')
%     state = "PURE GAS";
% else
%     state = "NOT GAS";
% end
% fprintf('Chamber: T = %.3f K, P = %.3f Pa, %s\n', T0, p0, state);
% 
% % Throat
% ph = lower(char(py.CoolProp.CoolProp.PhaseSI('T',Tt,'P',pt,species)));
% if contains(ph,'gas') || contains(ph,'supercritical')
%     state = "PURE GAS";
% else
%     state = "NOT GAS";
% end
% fprintf('Throat:  T = %.3f K, P = %.3f Pa, %s\n', Tt, pt, state);
% 
% % Exit
% ph = lower(char(py.CoolProp.CoolProp.PhaseSI('T',Te,'P',pe,species)));
% if contains(ph,'gas') || contains(ph,'supercritical')
%     state = "PURE GAS";
% else
%     state = "NOT GAS";
% end
% fprintf('Exit:    T = %.3f K, P = %.3f Pa, %s\n', Te, pe, state);
% 
% end

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
    ph = lower(char(py.CoolProp.CoolProp.PhaseSI('T', T, 'P', p, species)));
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

% -------------------------- Thruster State ----------------------------- %
function state = thrusterState(T0, p0, pa, rt, re, species)

g = 9.80665;
At = pi * rt^2;
Ae = pi * re^2;

state = struct();

% Default values
state.valid = false;
state.species = species;
state.T0 = T0;
state.p0 = p0;
state.pa = pa;
state.cp = nan;
state.R = nan;
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
state.phase_chamber = "";
state.phase_throat = "";
state.phase_exit = "";

% First check chamber phase before asking for cp
ph0 = phaseString(T0, p0, species);
state.phase_chamber = ph0;

if ~isGasPhase(ph0)
    return
end

% Only now continue with property calculations
if strcmpi(species, "Iodine") || strcmpi(species, "I2")
    data = propellantDB();
    data = data.I2;

    R  = 8.314462618 / data.M;
    cp = cpNASA(T0, data);
else
    R  = R_CP(species);
    cp = cpCP(T0, p0, species);
end

gamma = cp / (cp - R);

pt = p0 * (2/(gamma+1))^(gamma/(gamma-1));
Tt = 2*T0 / (gamma+1);

% Exit pressure and exit Mach
if strcmpi(species, "Iodine") || strcmpi(species, "I2")
    [pe, Me] = exitPressureGivenGamma(p0, rt, re, gamma);
else
    [pe, Me, gamma, R, cp] = exitPressure(T0, p0, rt, re, species);
end
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
Isp = ve / g;

state.valid = true;
state.cp = cp;
state.R = R;
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

end

