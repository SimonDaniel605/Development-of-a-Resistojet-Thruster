%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   iodinePhaseChecker.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           April 2026
%   Version:        1.0
%   Project:        Development of a Resistojet Thruster
%   Description:    
%   This file determines whether iodine is in the vapour phase under the
%   specified thermodynamic conditions. It is used in thruster nozzle
%   simulations to verify that iodine remains gaseous throughout the
%   nozzle, so that the ideal-gas assumption used in the nozzle model
%   remains valid. It can also calculate an Antoine-type fit for iodine 
%   saturation pressure if requested.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculateAntoineFit();
function gas = iodinePhaseChecker(P, T)

p_sat = iodineVapourPressure(T);
gas = P <= p_sat;

end

%% -------------------------- local functions -------------------------- %%
% ------------------------- Iodine Antoine Fit -------------------------- %
function p_sat = iodineVapourPressure(T)
% Critical Point of Iodine
Tcrit = 819;        % K
Pcrit = 11.7e6;     % Pa

% NIST Antoine Constants (311.9 – 456.3 K)
A1 = 3.36429;
B1 = 1653.4;
C1 = -32.61;

% Generated High-T Antoine Constants (456.3 – 819 K)
A2 = 4.390143321345;
B2 = 1785.320336716318;
C2 = -50.264108364090;

if T > Tcrit
    p_sat = Pcrit;

elseif T > 456.3 && T <= Tcrit
    % High-temperature Antoine
    p_bar = 10^(A2 - B2/(T + C2));
    p_sat = p_bar * 1e5;

elseif T > 311.9 && T <= 456.3
    % NIST Antoine
    p_bar = 10^(A1 - B1/(T + C1));
    p_sat = p_bar * 1e5;

elseif T <= 311.9 && 150 <= T
    % Clausius–Clapeyron equation (sublimation region)
    R = 8.314;
    T0 = 311.9;
    p0_bar = 10^(A1 - B1/(T0 + C1));
    p0 = p0_bar * 1e5;

    dHsub = 62000;
    p_sat = p0 * exp((dHsub/R)*(1/T0 - 1/T));
else
    p_sat = 0;   % Engineering zero
end

end



% ------------------------- Antione Curve Fitter ------------------------ %
function calculateAntoineFit()
% The following data points represent iodine's triple point, boiling point
% at 1 atm, and critical point. These three pressure-temperature states are 
% used to generate an approximate Antoine-type curve of the form
% log10(P) = A - B/(T + C). This approximation is intended for estimating
% iodine saturation pressure at temperatures above 456 K, where the NIST
% Antoine fit is no longer valid.
T = [113.5; 184.3; 546.0] + 273.15;   % (K)
P = [12.1; 101.3; 11700] / 100;       % (Bar)

x0 = [4.0, 1500, -50];   % Initial Guess (A, B, C)
x = fminsearch(@(x) antoineObjective(x, T, P), x0);

A = x(1);
B = x(2);
C = x(3);

% Display results
fprintf('Fitted Antoine constants:\n');
fprintf('A = %.12f\n', A);
fprintf('B = %.12f\n', B);
fprintf('C = %.12f\n', C);

% Check fitted values
P_fit = 10.^(A - B ./ (T + C));

fprintf('\nPoint check:\n');
for i = 1:length(T)
    fprintf('T = %.2f K | P_true = %.6f bar | P_fit = %.6f bar\n', ...
        T(i), P(i), P_fit(i));
end

% Plot Antoine Fit
Tplot = linspace(300, 850, 500);
Pplot = 10.^(A - B ./ (Tplot + C));

figure;
semilogy(T, P, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5); hold on;
semilogy(Tplot, Pplot, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('Temperature [K]');
ylabel('Pressure [bar]');
legend('Data points', 'Antoine fit', 'Location', 'best');
title('Antoine Fit for Iodine');
end

function err = antoineObjective(x, T, P)
    A = x(1);
    B = x(2);
    C = x(3);

    P_model = 10.^(A - B ./ (T + C));

    % Fit in log space
    err = sum((log10(P_model) - log10(P)).^2);
end