%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   propellantDB.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           March 2026
%   Version:        1.0
%   Project:        Development of a Resistojet Thruster
%   Description:    
%   This file acts as a database of candidate resistojet propellants and
%   stores their thermodynamic properties in a consistent MATLAB format for
%   use by the resistojet performance model under varying operating 
%   conditions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function db = propellantDB()
db = struct();

%==========================================================================
% Start of propellant database
%==========================================================================
%==========================================================================
% Hydrogen (H2)
%==========================================================================

db.H2.name    = "Hydrogen";
db.H2.formula = "H2";
db.H2.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                "Thermodynamic Polynomial Database";

db.H2.M    = 2.01588e-3;   % [kg/mol]
db.H2.Tmin = 200.0;        % [K]
db.H2.Tmid = 1000.0;       % [K] standard NASA split
db.H2.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.H2.high = [ 2.93286579E+00,  8.26607967E-04, -1.46402335E-07, ...
     1.54100359E-11, -6.88804432E-16, -8.13065597E+02, -1.02432887E+00];

% Low-T set (T < 1000 K): a1..a7
db.H2.low  = [ 2.34433112E+00,  7.98052075E-03, -1.94781510E-05, ...
     2.01572094E-08, -7.37611761E-12, -9.17935173E+02,  6.83010238E-01];


%==========================================================================
% Helium (He)
%==========================================================================

db.He.name    = "Helium";
db.He.formula = "He";
db.He.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                "Thermodynamic Polynomial Database";

db.He.M    = 4.00260e-3;   % [kg/mol]
db.He.Tmin = 200.0;        % [K]
db.He.Tmid = 1000.0;       % [K] standard NASA split
db.He.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.He.high = [ 2.50000000E+00,  0.00000000E+00,  0.00000000E+00, ...
     0.00000000E+00,  0.00000000E+00, -7.45375000E+02,  9.28723974E-01 ];

% Low-T set (T < 1000 K): a1..a7
db.He.low  = [ 2.50000000E+00,  0.00000000E+00,  0.00000000E+00, ...
     0.00000000E+00,  0.00000000E+00, -7.45375000E+02,  9.28723974E-01 ];


%==========================================================================
% Nitrogen (N2)
%==========================================================================

db.N2.name    = "Nitrogen";
db.N2.formula = "N2";
db.N2.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                "Thermodynamic Polynomial Database";

db.N2.M    = 28.01348e-3;  % [kg/mol]
db.N2.Tmin = 200.0;        % [K]
db.N2.Tmid = 1000.0;       % [K] standard NASA split
db.N2.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.N2.high = [ 2.95257626E+00,  1.39690057E-03, -4.92631691E-07, ...
     7.86010367E-11, -4.60755321E-15, -9.23948645E+02,  5.87189252E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.N2.low  = [ 3.53100528E+00, -1.23660987E-04, -5.02999437E-07, ...
     2.43530612E-09, -1.40881235E-12, -1.04697628E+03,  2.96747468E+00 ];


%==========================================================================
% Ammonia (NH3)
%==========================================================================

db.NH3.name    = "Ammonia";
db.NH3.formula = "NH3";
db.NH3.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                 "Thermodynamic Polynomial Database";

db.NH3.M    = 17.03056e-3;  % [kg/mol]
db.NH3.Tmin = 200.0;        % [K]
db.NH3.Tmid = 1000.0;       % [K] standard NASA split
db.NH3.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.NH3.high = [ 2.71709692E+00,  5.56856338E-03, -1.76886396E-06, ...
     2.67417260E-10, -1.52731419E-14, -6.58451989E+03,  6.09289837E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.NH3.low  = [ 4.30177808E+00, -4.77127330E-03,  2.19341619E-05, ...
    -2.29856489E-08,  8.28992268E-12, -6.74806394E+03, -6.90644393E-01 ];


%==========================================================================
% Methane (CH4)
%==========================================================================

db.CH4.name    = "Methane";
db.CH4.formula = "CH4";
db.CH4.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                 "Thermodynamic Polynomial Database";

db.CH4.M    = 16.04276e-3;  % [kg/mol]
db.CH4.Tmin = 200.0;        % [K]
db.CH4.Tmid = 1000.0;       % [K] standard NASA split
db.CH4.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.CH4.high = [ 1.63552643E+00,  1.00842795E-02, -3.36916254E-06, ...
     5.34958667E-10, -3.15518833E-14, -1.00056455E+04,  9.99313326E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.CH4.low  = [ 5.14987613E+00, -1.36709788E-02,  4.91800599E-05, ...
    -4.84743026E-08,  1.66693956E-11, -1.02466476E+04, -4.64130376E+00 ];


%==========================================================================
% Water Vapor (H2O)
%==========================================================================

db.H2O.name    = "Water Vapor";
db.H2O.formula = "H2O";
db.H2O.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                 "Thermodynamic Polynomial Database";

db.H2O.M    = 18.01528e-3;  % [kg/mol]
db.H2O.Tmin = 200.0;        % [K]
db.H2O.Tmid = 1000.0;       % [K] standard NASA split
db.H2O.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.H2O.high = [ 2.67703787E+00,  2.97318329E-03, -7.73769690E-07, ...
     9.44336689E-11, -4.26900959E-15, -2.98858938E+04,  6.88255571E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.H2O.low  = [ 4.19864056E+00, -2.03643410E-03,  6.52040211E-06, ...
    -5.48797062E-09,  1.77197817E-12, -3.02937267E+04, -8.49032208E-01 ];


%==========================================================================
% Carbon Dioxide (CO2)
%==========================================================================

db.CO2.name    = "Carbon Dioxide";
db.CO2.formula = "CO2";
db.CO2.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                 "Thermodynamic Polynomial Database";

db.CO2.M    = 44.00980e-3;  % [kg/mol]
db.CO2.Tmin = 200.0;        % [K]
db.CO2.Tmid = 1000.0;       % [K] standard NASA split
db.CO2.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.CO2.high = [ 4.63659493E+00,  2.74131991E-03, -9.95828531E-07, ...
     1.60373011E-10, -9.16103468E-15, -4.90249341E+04, -1.93534855E+00 ];


% Low-T set (T < 1000 K): a1..a7
db.CO2.low  = [ 2.35677352E+00,  8.98459677E-03, -7.12356269E-06, ...
     2.45919022E-09, -1.43699548E-13, -4.83719697E+04,  9.90105222E+00 ];


%==========================================================================
% Nitrous Oxide (N2O)
%==========================================================================

db.N2O.name    = "Nitrous Oxide";
db.N2O.formula = "N2O";
db.N2O.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                 "Thermodynamic Polynomial Database";

db.N2O.M    = 44.01288e-3;  % [kg/mol]
db.N2O.Tmin = 200.0;        % [K]
db.N2O.Tmid = 1000.0;       % [K] standard NASA split
db.N2O.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.N2O.high = [ 4.82318873E+00,  2.62685279E-03, -9.58426058E-07, ...
    1.59991296E-10, -9.77416939E-15,  8.07335662E+03, -2.20236600E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.N2O.low  = [ 2.25716860E+00,  1.13046338E-02, -1.36710350E-05, ...
    9.68162098E-09, -2.93055583E-12,  8.74177146E+03,  1.07579154E+01 ];


%==========================================================================
% Argon (Ar)
%==========================================================================

db.Ar.name    = "Argon";
db.Ar.formula = "Ar";
db.Ar.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                "Thermodynamic Polynomial Database";

db.Ar.M    = 39.94800e-3;  % [kg/mol]
db.Ar.Tmin = 200.0;        % [K]
db.Ar.Tmid = 1000.0;       % [K] standard NASA split
db.Ar.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.Ar.high = [ 2.50000000E+00,  0.00000000E+00,  0.00000000E+00, ...
    0.00000000E+00,  0.00000000E+00, -7.45375000E+02,  4.37967491E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.Ar.low  = [ 2.50000000E+00,  0.00000000E+00,  0.00000000E+00, ...
    0.00000000E+00,  0.00000000E+00, -7.45375000E+02,  4.37967491E+00 ];


%==========================================================================
% Xenon (Xe)
%==========================================================================

db.Xe.name    = "Xenon";
db.Xe.formula = "Xe";
db.Xe.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                "Thermodynamic Polynomial Database";

db.Xe.M    = 131.29000e-3; % [kg/mol]
db.Xe.Tmin = 200.0;        % [K]
db.Xe.Tmid = 1000.0;       % [K] standard NASA split
db.Xe.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.Xe.high = [ 2.50005322E+00, -1.05136544E-07,  6.75326897E-11, ...
    -1.70944909E-14,  1.47681049E-18, -7.45394186E+02,  6.16412898E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.Xe.low  = [ 2.50000000E+00, -8.99141330E-14,  2.52196860E-16, ...
    -2.92186662E-19,  1.18949218E-22, -7.45375000E+02,  6.16441993E+00 ];


%==========================================================================
% Sulfur Dioxide (SO2)
%==========================================================================

db.SO2.name    = "Sulfur Dioxide";
db.SO2.formula = "SO2";
db.SO2.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                 "Thermodynamic Polynomial Database";

db.SO2.M    = 64.06480e-3;  % [kg/mol]
db.SO2.Tmin = 300.0;        % [K]
db.SO2.Tmid = 1000.0;       % [K] standard NASA split
db.SO2.Tmax = 5000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.SO2.high = [ 5.24513640E+00,  1.97042040E-03, -8.03757690E-07, ...
     1.51499690E-10, -1.05580040E-14, -3.75582270E+04, -1.07404892E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.SO2.low  = [ 3.26653380E+00,  5.32379020E-03,  6.84375520E-07, ...
    -5.28100470E-09,  2.55904540E-12, -3.69081480E+04,  9.66465108E+00 ];


%==========================================================================
% Sulfur Hexafluoride (SF6)
%==========================================================================

db.SF6.name    = "Sulfur Hexafluoride";
db.SF6.formula = "SF6";
db.SF6.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                 "Thermodynamic Polynomial Database";

db.SF6.M    = 146.05642e-3; % [kg/mol]
db.SF6.Tmin = 300.0;        % [K]
db.SF6.Tmid = 1000.0;       % [K] standard NASA split
db.SF6.Tmax = 5000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.SF6.high = [ 1.51629500E+01,  4.38423180E-03, -1.94863370E-06, ...
    3.82471960E-10, -2.76050500E-14, -1.52268010E+05, -5.44157194E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.SF6.low  = [ -3.83880880E+00,  8.32217210E-02, -1.31816890E-04, ...
    9.96361540E-08, -2.92487670E-11, -1.48364770E+05,  3.71611426E+01 ];


%==========================================================================
% n-Propane (C3H8)
%==========================================================================

db.C3H8.name    = "n-Propane";
db.C3H8.formula = "C3H8";
db.C3H8.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                  "Thermodynamic Polynomial Database";

db.C3H8.M    = 44.09652e-3;  % [kg/mol]
db.C3H8.Tmin = 200.0;        % [K]
db.C3H8.Tmid = 1000.0;       % [K] standard NASA split
db.C3H8.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.C3H8.high = [ 6.66789363E+00,  2.06120214E-02, -7.36553027E-06, ...
     1.18440761E-09, -7.06953210E-14, -1.62748521E+04, -1.31859503E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.C3H8.low  = [ 4.21102620E+00,  1.71599803E-03,  7.06183472E-05, ...
    -9.19594116E-08,  3.64421372E-11, -1.43812106E+04,  5.60930491E+00 ];


%==========================================================================
% n-Butane (C4H10)
%==========================================================================

db.C4H10_n.name    = "n-Butane";
db.C4H10_n.formula = "C4H10";
db.C4H10_n.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                     "Thermodynamic Polynomial Database";

db.C4H10_n.M    = 58.12340e-3;  % [kg/mol]
db.C4H10_n.Tmin = 200.0;        % [K]
db.C4H10_n.Tmid = 1000.0;       % [K] standard NASA split
db.C4H10_n.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.C4H10_n.high = [ 9.44535834E+00,  2.57858073E-02, -9.23619122E-06, ...
     1.48632755E-09, -8.87897158E-14, -2.01382165E+04, -2.63470076E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.C4H10_n.low  = [ 6.14746806E+00,  1.55947389E-04,  9.67913517E-05, ...
    -1.25483910E-07,  4.97816555E-11, -1.75994402E+04, -1.09409879E+00 ];


%==========================================================================
% Isobutane (C4H10)
%==========================================================================

db.C4H10_iso.name    = "Isobutane";
db.C4H10_iso.formula = "C4H10";
db.C4H10_iso.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                       "Thermodynamic Polynomial Database";

db.C4H10_iso.M    = 58.12340e-3;  % [kg/mol]
db.C4H10_iso.Tmin = 200.0;        % [K]
db.C4H10_iso.Tmid = 1000.0;       % [K] standard NASA split
db.C4H10_iso.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.C4H10_iso.high = [ 9.76991245E+00,  2.54997210E-02, -9.14142932E-06, ...
     1.47328271E-09, -8.80800188E-14, -2.14052647E+04, -3.00329101E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.C4H10_iso.low  = [ 4.45479276E+00,  8.26057985E-03,  8.29886664E-05, ...
    -1.14647642E-07,  4.64570101E-11, -1.84593931E+04,  4.92743175E+00 ];


%==========================================================================
% n-Pentane (C5H12)
%==========================================================================

db.C5H12.name    = "n-Pentane";
db.C5H12.formula = "C5H12";
db.C5H12.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                   "Thermodynamic Polynomial Database";

db.C5H12.M    = 72.15028e-3;   % [kg/mol]
db.C5H12.Tmin = 0;        % [K]
db.C5H12.Tmid = 1000.0;       % [K] standard NASA split
db.C5H12.Tmax = 0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.C5H12.high = [ 1.35469980E+01,  2.84217860E-02, -9.41746480E-06, ...
     1.38935890E-09, -7.42126090E-14, -2.45776800E+04, -4.70211850E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.C5H12.low  = [ 1.89836790E+00,  4.12030370E-02,  1.23121750E-05, ...
    -3.65895010E-08,  1.50425090E-11, -2.00915000E+04,  1.86790720E+01 ];


%==========================================================================
% 1-Butene (C4H8)
%==========================================================================

db.C4H8.name    = "1-Butene";
db.C4H8.formula = "C4H8";
db.C4H8.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                  "Thermodynamic Polynomial Database";

db.C4H8.M    = 56.10752e-3;  % [kg/mol]
db.C4H8.Tmin = 298.15;       % [K]
db.C4H8.Tmid = 1000.0;       % [K] standard NASA split
db.C4H8.Tmax = 5000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.C4H8.high = [ 8.02147991E+00,  2.26010707E-02, -8.31284033E-06, ...
     1.37803072E-09, -8.42175459E-14, -4.30852153E+03, -1.71170697E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.C4H8.low  = [ 4.42674073E+00,  6.63946249E-03,  6.80652815E-05, ...
    -9.28753562E-08,  3.73473949E-11, -2.11532796E+03,  7.54694860E+00 ];


%==========================================================================
% Cyclopentane (C5H10)
%==========================================================================

db.C5H10.name    = "Cyclopentane";
db.C5H10.formula = "C5H10";
db.C5H10.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                   "Thermodynamic Polynomial Database";

db.C5H10.M    = 70.13440e-3;  % [kg/mol]
db.C5H10.Tmin = 200.0;        % [K]
db.C5H10.Tmid = 1000.0;       % [K] standard NASA split
db.C5H10.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.C5H10.high = [ 9.13295790E+00,  3.01130430E-02, -1.09169137E-05, ...
     1.77298767E-09, -1.06575248E-13, -1.51597372E+04, -2.92618828E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.C5H10.low  = [ 3.70327955E+00, -1.15565354E-02,  1.64111439E-04, ...
    -2.09368134E-07,  8.31054507E-11, -1.10951786E+04,  1.19777761E+01 ];


%==========================================================================
% Ethylene Oxide (C2H4O)
%==========================================================================

db.C2H4O.name    = "Ethylene Oxide (Oxyrane)";
db.C2H4O.formula = "C2H4O";
db.C2H4O.source  = "Burcat & Ruscic (2005), Third Millennium Ideal " + ...
    "Gas and Condensed Phase Thermochemical Database for Combustion " + ...
    "with Updates from Active Thermochemical Tables";

db.C2H4O.M    = 44.05256e-3;  % [kg/mol]
db.C2H4O.Tmin = 200.0;        % [K]
db.C2H4O.Tmid = 1000.0;       % [K] standard NASA split
db.C2H4O.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.C2H4O.high = [ 5.48876410E+00,  1.20461900E-02, -4.33369310E-06, ...
     7.00283110E-10, -4.19490880E-14, -9.18042510E+03, -7.07996050E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.C2H4O.low  = [ 3.75905320E+00, -9.44121800E-03,  8.03097210E-05, ...
    -1.00807880E-07,  4.00399210E-11, -7.56081430E+03,  7.84974750E+00 ];


%==========================================================================
% Diethyl Ether (C4H10O)
%==========================================================================

db.C4H10O.name    = "Diethyl Ether";
db.C4H10O.formula = "C4H10O";
db.C4H10O.source  = "OpenFOAM thermoData (NASA-7), " + ...
    "https://github.com/OpenFOAM/OpenFOAM-2.2.x/blob/master/etc/" + ...
    "thermoData/thermoData";

db.C4H10O.M    = 74.1237e-3; % [kg/mol]
db.C4H10O.Tmin = 200.0;      % [K]
db.C4H10O.Tmid = 1000.0;     % [K] standard NASA split
db.C4H10O.Tmax = 6000.0;     % [K]

% High-T set (T >= 1000 K): a1..a7
db.C4H10O.high = [ 1.21149E+01, 2.68657E-02, -1.00091E-05, 1.6482E-09, ...
    -9.99139E-14, -3.71098E+04, -3.89453E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.C4H10O.low  = [ 7.80074E+00, -1.19289E-02, 1.38604E-04, -1.6741E-07, ...
      6.34538E-11, -3.33823E+04, -4.1921E+00 ];


%==========================================================================
% R134a (C2H2F4)
%==========================================================================

db.R134a.name    = "R134a (1,1,1,2-Tetrafluoroethane)";
db.R134a.formula = "C2H2F4";
db.R134a.source  = "Ideal-gas Cp from CoolProp v6.x, " + ...
    "NASA-7 fit by author (MATLAB)";

db.R134a.M    = 102.032e-3;   % [kg/mol]
db.R134a.Tmin = 200.0;        % [K]
db.R134a.Tmid = 1000.0;       % [K] standard NASA split
db.R134a.Tmax = 1500.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.R134a.high = [ 4.07866015E+00, 2.37677602E-02, -7.99340168E-06, ...
    2.59285103E-09, -3.79485956E-13, -2.24277572E+03, -3.00842293E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.R134a.low  = [ 2.50834630E+00, 3.10375157E-02, -2.06956254E-05, ...
    1.24692870E-08, -3.25313984E-12, -1.96764326E+03, -2.27292610E+01 ];


%==========================================================================
% R245fa (C3H3F5)
%==========================================================================

db.R245fa.name    = "R245fa (1,1,1,3,3-Pentafluoropropane)";
db.R245fa.formula = "C3H3F5";
db.R245fa.source  = "Ideal-gas Cp from CoolProp v6.x, " + ...
    "NASA-7 fit by author (MATLAB)";

db.R245fa.M    = 134.048e-3;   % [kg/mol]
db.R245fa.Tmin = 300.0;        % [K]
db.R245fa.Tmid = 1000.0;       % [K] standard NASA split
db.R245fa.Tmax = 1500.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.R245fa.high = [ -4.75786424E-01, 5.82697200E-02, -4.59565394E-05, ...
    1.78089975E-08, -2.75893533E-12, -2.03345308E+03, -1.26457871E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.R245fa.low  = [ 4.15104127E+00, 3.42808952E-02, -6.54096721E-07, ...
    -1.93367242E-08, 8.44634088E-12, -2.72130738E+03, -3.36885889E+01 ];


%==========================================================================
% R245ca (C3H3F5)
%==========================================================================

db.R245ca.name    = "R245ca (1,1,2,3,3-Pentafluoropropane)";
db.R245ca.formula = "C3H3F5";
db.R245ca.source  = "Ideal-gas Cp from CoolProp v6.x, " + ...
    "NASA-7 fit by author (MATLAB)";

db.R245ca.M    = 134.048e-3;   % [kg/mol]
db.R245ca.Tmin = 300.0;        % [K]
db.R245ca.Tmid = 1000.0;       % [K] standard NASA split
db.R245ca.Tmax = 1500.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.R245ca.high = [ 5.74010821E+00, 4.29565663E-02, -3.46657121E-05, ...
    1.37425106E-08, -2.17483476E-12, -3.52174264E+03, -4.45533438E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.R245ca.low  = [ -1.75687327E+00, 7.70700964E-02, -9.32960560E-05, ...
    5.86505338E-08, -1.50690626E-11, -2.18623845E+03, -9.31017266E+00 ];


%==========================================================================
% R236fa (C3H2F6)
%==========================================================================

db.R236fa.name    = "R236fa (1,1,1,3,3,3-Hexafluoropropane)";
db.R236fa.formula = "C3H2F6";
db.R236fa.source  = "Ideal-gas Cp from CoolProp v6.x, " + ...
    "NASA-7 fit by author (MATLAB)";

db.R236fa.M    = 152.038e-3;   % [kg/mol]
db.R236fa.Tmin = 300.0;        % [K]
db.R236fa.Tmid = 1000.0;       % [K] standard NASA split
db.R236fa.Tmax = 1500.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.R236fa.high = [ 2.17960857E+01, -3.38537620E-02, 9.01702835E-05, ...
    -4.82353745E-08, 8.58682478E-12, -6.13245226E+03, -1.18818718E+02 ];

% Low-T set (T < 1000 K): a1..a7
db.R236fa.low  = [ 5.10239764E+00, 3.80704121E-02, -2.54992930E-05, ...
    3.41060053E-08, -1.33154647E-11, -3.04921287E+03, -3.95637464E+01 ];


%==========================================================================
% R236ea (C3H2F6)
%==========================================================================

db.R236ea.name    = "R236ea (1,1,1,2,3,3-Hexafluoropropane)";
db.R236ea.formula = "C3H2F6";
db.R236ea.source  = "Ideal-gas Cp from CoolProp v6.x, " + ...
    "NASA-7 fit by author (MATLAB)";

db.R236ea.M    = 152.038e-3;   % [kg/mol]
db.R236ea.Tmin = 300.0;        % [K]
db.R236ea.Tmid = 1000.0;       % [K] standard NASA split
db.R236ea.Tmax = 1500.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.R236ea.high = [ 9.23894219E+00, 3.61303210E-02, -3.22654988E-05, ...
    1.44213238E-08, -2.52578519E-12, -4.40713851E+03, -6.28637984E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.R236ea.low  = [ 2.50086392E+00, 5.88526124E-02, -5.86599226E-05, ...
    2.59956086E-08, -3.68985927E-12, -2.89282105E+03, -2.94109585E+01 ];


%==========================================================================
% Iodine (I2)
%==========================================================================

db.I2.name    = "Iodine";
db.I2.formula = "I2";
db.I2.source  = "";

db.I2.M    = 253.80894e-3; % [kg/mol]
db.I2.rho_storage  = 4930; % [kg/m^3] solid iodine
db.I2.Tmin = 200.0;        % [K]
db.I2.Tmid = 1000.0;       % [K] standard NASA split
db.I2.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.I2.high = [ 4.56588102E+00, -3.42229361E-04,  4.84410977E-07, ...
    -1.42632157E-10,  1.14951099E-14,  6.16085432E+03,  5.41958286E+00 ];

% Low-T set (T < 1000 K): a1..a7
db.I2.low  = [ 3.87234634E+00,  3.64265414E-03, -7.95349191E-06, ...
     7.82149773E-09, -2.80608071E-12,  6.24706424E+03,  8.49410267E+00 ];

%==========================================================================
% Naphthalene (C10H8)
%==========================================================================

db.C10H8.name    = "Naphthalene";
db.C10H8.formula = "C10H8";
db.C10H8.source  = "NASA Technical Memorandum 4513 (1993), " + ...
                   "Thermodynamic Polynomial Database";

db.C10H8.M    = 128.17352e-3; % [kg/mol]
db.C10H8.rho_storage = 1140;  % [kg/m^3] solid at room temperature (approx.)
db.C10H8.Tmin = 200.0;        % [K]
db.C10H8.Tmid = 1000.0;       % [K] standard NASA split
db.C10H8.Tmax = 6000.0;       % [K]

% High-T set (T >= 1000 K): a1..a7
db.C10H8.high = [ ...
     1.86129899E+01,  3.04494141E-02, -1.11224799E-05, ...
     1.81615406E-09, -1.09601224E-13,  8.91552944E+03, ...
    -8.00230479E+01 ];

% Low-T set (T < 1000 K): a1..a7
db.C10H8.low  = [ ...
    -1.04919326E+00,  4.62970611E-02,  7.07592203E-05, ...
    -1.38408186E-07,  6.20475748E-11,  1.59846388E+04, ...
     3.02121571E+01 ];

%==========================================================================
% End of propellant database
%==========================================================================

end