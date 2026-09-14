%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   generateLookupTable.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           September 2026
%   Version:        1.0
%   Project:        Development of a Resistojet Thruster
%   Description:
%   This file generates thermodynamic property lookup tables for a selected
%   propellant using CoolProp. The generated data is intended for use in
%   the resistojet controller to determine the required plenum fill
%   conditions for a desired final pressure and temperature.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;

% Select propellant

fluid = input('Enter propellant name: ', 's');

safeFluidName = matlab.lang.makeValidName(fluid);

% Lookup table ranges

temperatureGrid = 270:1:370;      % K
pressureGrid = 0.1:0.1:6.0;     % bar

nT = length(temperatureGrid);
nP = length(pressureGrid);

densityTable = zeros(nT, nP);

% Generate density table

for i = 1:nT

    for j = 1:nP

        T = temperatureGrid(i);
        P = pressureGrid(j) * 1e5;     % bar -> Pa

        densityTable(i,j) = py.CoolProp.CoolProp.PropsSI( ...
            'D', 'P', P, 'T', T, fluid);

    end

end

% Write lookup table to text file

filename = sprintf('%s_lookup_table.txt', fluid);

fileID = fopen(filename, 'w');

fprintf(fileID, ...
    'static const LookupEntry %s_lookupTable[] = {\n', ...
    safeFluidName);

for i = 1:nT
    for j = 1:nP

        fprintf(fileID, '    {%.1ff, %.2ff, %.6ff}', ...
            temperatureGrid(i), ...
            pressureGrid(j), ...
            densityTable(i,j));

        if ~(i == nT && j == nP)
            fprintf(fileID, ',');
        end

        fprintf(fileID, '\n');

    end
end

fprintf(fileID, '};\n');

fclose(fileID);

fprintf('Table Generated.\n');