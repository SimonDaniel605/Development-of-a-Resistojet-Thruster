function prop = resolvePropellant(speciesName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   resolvePropellant.m
%   Name:           Simon Craig DANIEL
%   Student Number: 25848887
%   Institution:    Stellenbosch University,
%                   Electronic Systems Laboratory (ESL)
%   Date:           April 2026
%   Version:        2.0
%   Project:        Development of a Resistojet Thruster
%   Description:    
%   This file maps user species names to a NASA polynomial database or to 
%   CoolProp.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
speciesName = string(speciesName);

switch speciesName

% =========================================================================
% Practically non-condensable gases
% =========================================================================

    case "Air"
        prop.dbField = "Air";
        prop.cpName = "Air";
        prop.useCoolProp = true;
        prop.colorName = "blue";
        prop.lineStyle = "-";

    case "Helium"
        prop.dbField = "He";
        prop.cpName = "Helium";
        prop.useCoolProp = true;
        prop.colorName = "cyan";
        prop.lineStyle = "-";

    case "Neon"
        prop.dbField = "Ne";
        prop.cpName = "Neon";
        prop.useCoolProp = true;
        prop.colorName = "springgreen";
        prop.lineStyle = "-";

    case "Argon"
        prop.dbField = "Ar";
        prop.cpName = "Argon";
        prop.useCoolProp = true;
        prop.colorName = "forestgreen";
        prop.lineStyle = "-";

    case "Krypton"
        prop.dbField = "Kr";
        prop.cpName = "Krypton";
        prop.useCoolProp = true;
        prop.colorName = "yellow";
        prop.lineStyle = "-";

    case "Xenon"
        prop.dbField = "Xe";
        prop.cpName = "Xenon";
        prop.useCoolProp = true;
        prop.colorName = "orange";
        prop.lineStyle = "-";
    
    case "Hydrogen"
        prop.dbField = "H2";
        prop.cpName = "Hydrogen";
        prop.useCoolProp = true;
        prop.colorName = "orangered";
        prop.lineStyle = "-";

    case "Deuterium"
        prop.dbField = "D2";
        prop.cpName = "Deuterium";
        prop.useCoolProp = true;
        prop.colorName = "crimson";
        prop.lineStyle = "-";

    case "Nitrogen"
        prop.dbField = "N2";
        prop.cpName = "Nitrogen";
        prop.useCoolProp = true;
        prop.colorName = "magenta";
        prop.lineStyle = "-";

    case "Oxygen"
        prop.dbField = "O2";
        prop.cpName = "Oxygen";
        prop.useCoolProp = true;
        prop.colorName = "purple";
        prop.lineStyle = "-";

    case "Fluorine"
        prop.dbField = "F2";
        prop.cpName = "Fluorine";
        prop.useCoolProp = true;
        prop.colorName = "black";
        prop.lineStyle = "-";

    case "NitrousOxide"
        prop.dbField = "N2O";
        prop.cpName = "NitrousOxide";
        prop.useCoolProp = true;
        prop.colorName = "blue";
        prop.lineStyle = ":";

    case "CarbonMonoxide"
        prop.dbField = "CO";
        prop.cpName = "CarbonMonoxide";
        prop.useCoolProp = true;
        prop.colorName = "cyan";
        prop.lineStyle = ":";

    case "CarbonDioxide"
        prop.dbField = "CO2";
        prop.cpName = "CarbonDioxide";
        prop.useCoolProp = true;
        prop.colorName = "springgreen";
        prop.lineStyle = ":";

    case "HydrogenChloride"
        prop.dbField = "HCl";
        prop.cpName = "HydrogenChloride";
        prop.useCoolProp = true;
        prop.colorName = "forestgreen";
        prop.lineStyle = ":";

    case "Methane"
        prop.dbField = "CH4";
        prop.cpName = "Methane";
        prop.useCoolProp = true;
        prop.colorName = "yellow";
        prop.lineStyle = ":";    
    
    case "Ethane"
        prop.dbField = "C2H6";
        prop.cpName = "Ethane";
        prop.useCoolProp = true;
        prop.colorName = "orange";
        prop.lineStyle = ":";

    case "Ethylene"
        prop.dbField = "C2H4";
        prop.cpName = "Ethylene";
        prop.useCoolProp = true;
        prop.colorName = "orangered";
        prop.lineStyle = ":";
    
    case "R13"
        prop.dbField = "R13";
        prop.cpName = "R13";
        prop.useCoolProp = true;
        prop.colorName = "crimson";
        prop.lineStyle = "-.";
    
    case "R14"
        prop.dbField = "R14";
        prop.cpName = "R14";
        prop.useCoolProp = true;
        prop.colorName = "magenta";
        prop.lineStyle = "-.";
    
    case "R23"
        prop.dbField = "R23";
        prop.cpName = "R23";
        prop.useCoolProp = true;
        prop.colorName = "purple";
        prop.lineStyle = "-.";

    case "R41"
        prop.dbField = "R41";
        prop.cpName = "R41";
        prop.useCoolProp = true;
        prop.colorName = "black";
        prop.lineStyle = "-.";

    case "R116"
        prop.dbField = "R116";
        prop.cpName = "R116";
        prop.useCoolProp = true;
        prop.colorName = "blue";
        prop.lineStyle = "-.";

% =========================================================================
% Condensable inorganic molecular fluids
% =========================================================================

    case "Ammonia"
        prop.dbField = "NH3";
        prop.cpName = "Ammonia";
        prop.useCoolProp = true;
        prop.colorName = "crimson";
        prop.lineStyle = ":";

    case "Water"
        prop.dbField = "H2O";
        prop.cpName = "Water";
        prop.useCoolProp = true;
        prop.colorName = "dodgerblue";
        prop.lineStyle = "-";

    case "HeavyWater"
        prop.dbField = "D2O";
        prop.cpName = "HeavyWater";
        prop.useCoolProp = true;
        prop.colorName = "lightblue";
        prop.lineStyle = "-";

    case "SulfurDioxide"
        prop.dbField = "SO2";
        prop.cpName = "SulfurDioxide";
        prop.useCoolProp = true;
        prop.colorName = "orange";
        prop.lineStyle = ":";

    case "SulfurHexafluoride"
        prop.dbField = "SF6";
        prop.cpName = "SulfurHexafluoride";
        prop.useCoolProp = true;
        prop.colorName = "black";
        prop.lineStyle = "-";

    case "HydrogenSulfide"
        prop.dbField = "H2S";
        prop.cpName = "HydrogenSulfide";
        prop.useCoolProp = true;
        prop.colorName = "khaki";
        prop.lineStyle = ":";

    case "CarbonylSulfide"
        prop.dbField = "COS";
        prop.cpName = "CarbonylSulfide";
        prop.useCoolProp = true;
        prop.colorName = "olive";
        prop.lineStyle = ":";

    case "Iodine"
        prop.dbField = "I2";
        prop.cpName = "";
        prop.useCoolProp = false;
        prop.colorName = "grey";
        prop.lineStyle = "-";

% =========================================================================
% Hydrocarbons
% =========================================================================

    case "Propylene"
        prop.dbField = "C3H6";
        prop.cpName = "Propylene";
        prop.useCoolProp = true;
        prop.colorName = "darkcyan";
        prop.lineStyle = ":";

    case "Propyne"
        prop.dbField = "Propyne";
        prop.cpName = "Propyne";
        prop.useCoolProp = true;
        prop.colorName = "grey";
        prop.lineStyle = ":";

    case "n-Propane"
        prop.dbField = "C3H8";
        prop.cpName = "n-Propane";
        prop.useCoolProp = true;
        prop.colorName = "black";
        prop.lineStyle = ":";

    case "CycloPropane"
        prop.dbField = "CycloPropane";
        prop.cpName = "CycloPropane";
        prop.useCoolProp = true;
        prop.colorName = "lightblue";
        prop.lineStyle = ":";

    case "1-Butene"
        prop.dbField = "C4H8";
        prop.cpName = "1-Butene";
        prop.useCoolProp = true;
        prop.colorName = "deepskyblue";
        prop.lineStyle = ":";

    case "cis-2-Butene"
        prop.dbField = "cis-2-Butene";
        prop.cpName = "cis-2-Butene";
        prop.useCoolProp = true;
        prop.colorName = "dodgerblue";
        prop.lineStyle = ":";

    case "trans-2-Butene"
        prop.dbField = "trans-2-Butene";
        prop.cpName = "trans-2-Butene";
        prop.useCoolProp = true;
        prop.colorName = "blue";
        prop.lineStyle = ":";

    case "IsoButene"
        prop.dbField = "IsoButene";
        prop.cpName = "IsoButene";
        prop.useCoolProp = true;
        prop.colorName = "darkblue";
        prop.lineStyle = ":";

    case "n-Butane"
        prop.dbField = "C4H10_n";
        prop.cpName = "n-Butane";
        prop.useCoolProp = true;
        prop.colorName = "darkslateblue";
        prop.lineStyle = ":";

    case "IsoButane"
        prop.dbField = "C4H10_iso";
        prop.cpName = "IsoButane";
        prop.useCoolProp = true;
        prop.colorName = "mediumslateblue";
        prop.lineStyle = ":";

    case "n-Pentane"
        prop.dbField = "C5H12";
        prop.cpName = "n-Pentane";
        prop.useCoolProp = true;
        prop.colorName = "blueviolet";
        prop.lineStyle = ":";

    case "Isopentane"
        prop.dbField = "IsoPentane";
        prop.cpName = "Isopentane";
        prop.useCoolProp = true;
        prop.colorName = "purple";
        prop.lineStyle = ":";

    case "Neopentane"
        prop.dbField = "Neopentane";
        prop.cpName = "Neopentane";
        prop.useCoolProp = true;
        prop.colorName = "orchid";
        prop.lineStyle = ":";

    case "Cyclopentane"
        prop.dbField = "C5H10";
        prop.cpName = "Cyclopentane";
        prop.useCoolProp = true;
        prop.colorName = "magenta";
        prop.lineStyle = ":";

    case "n-Hexane"
        prop.dbField = "n-Hexane";
        prop.cpName = "n-Hexane";
        prop.useCoolProp = true;
        prop.colorName = "deeppink";
        prop.lineStyle = ":";

    case "Isohexane"
        prop.dbField = "Isohexane";
        prop.cpName = "Isohexane";
        prop.useCoolProp = true;
        prop.colorName = "maroon";
        prop.lineStyle = ":";

    case "CycloHexane"
        prop.dbField = "CycloHexane";
        prop.cpName = "CycloHexane";
        prop.useCoolProp = true;
        prop.colorName = "crimson";
        prop.lineStyle = ":";

    case "n-Heptane"
        prop.dbField = "n-Heptane";
        prop.cpName = "n-Heptane";
        prop.useCoolProp = true;
        prop.colorName = "lightcoral";
        prop.lineStyle = ":";

    case "n-Octane"
        prop.dbField = "n-Octane";
        prop.cpName = "n-Octane";
        prop.useCoolProp = true;
        prop.colorName = "orangered";
        prop.lineStyle = ":";

    case "n-Nonane"
        prop.dbField = "n-Nonane";
        prop.cpName = "n-Nonane";
        prop.useCoolProp = true;
        prop.colorName = "orange";
        prop.lineStyle = ":";

    case "n-Decane"
        prop.dbField = "n-Decane";
        prop.cpName = "n-Decane";
        prop.useCoolProp = true;
        prop.colorName = "sandybrown";
        prop.lineStyle = ":";

    case "n-Undecane"
        prop.dbField = "n-Undecane";
        prop.cpName = "n-Undecane";
        prop.useCoolProp = true;
        prop.colorName = "khaki";
        prop.lineStyle = ":";

    case "n-Dodecane"
        prop.dbField = "n-Dodecane";
        prop.cpName = "n-Dodecane";
        prop.useCoolProp = true;
        prop.colorName = "olive";
        prop.lineStyle = ":";

    case "Benzene"
        prop.dbField = "C6H6";
        prop.cpName = "Benzene";
        prop.useCoolProp = true;
        prop.colorName = "saddlebrown";
        prop.lineStyle = ":";

    case "Toluene"
        prop.dbField = "C7H8";
        prop.cpName = "Toluene";
        prop.useCoolProp = true;
        prop.colorName = "yellow";
        prop.lineStyle = ":";

    case "EthylBenzene"
        prop.dbField = "EthylBenzene";
        prop.cpName = "EthylBenzene";
        prop.useCoolProp = true;
        prop.colorName = "yellowgreen";
        prop.lineStyle = ":";

    case "o-Xylene"
        prop.dbField = "C8H10_o";
        prop.cpName = "o-Xylene";
        prop.useCoolProp = true;
        prop.colorName = "lawngreen";
        prop.lineStyle = ":";

    case "m-Xylene"
        prop.dbField = "C8H10_m";
        prop.cpName = "m-Xylene";
        prop.useCoolProp = true;
        prop.colorName = "lightgreen";
        prop.lineStyle = ":";

    case "p-Xylene"
        prop.dbField = "C8H10_p";
        prop.cpName = "p-Xylene";
        prop.useCoolProp = true;
        prop.colorName = "darkseagreen";
        prop.lineStyle = ":";

% =========================================================================
% Organic fluids (oxygenated, halogenated, heavy, and siloxanes)
% =========================================================================

    case "Methanol"
        prop.dbField = "CH3OH";
        prop.cpName = "Methanol";
        prop.useCoolProp = true;
        prop.colorName = "forestgreen";
        prop.lineStyle = "-.";

    case "Ethanol"
        prop.dbField = "C2H5OH";
        prop.cpName = "Ethanol";
        prop.useCoolProp = true;
        prop.colorName = "springgreen";
        prop.lineStyle = "-.";

    case "Acetone"
        prop.dbField = "C3H6O";
        prop.cpName = "Acetone";
        prop.useCoolProp = true;
        prop.colorName = "cyan";
        prop.lineStyle = "-.";

    case "DiethylEther"
        prop.dbField = "C4H10O";
        prop.cpName = "DiethylEther";
        prop.useCoolProp = true;
        prop.colorName = "darkcyan";
        prop.lineStyle = "-.";

    case "DimethylEther"
        prop.dbField = "DimethylEther";
        prop.cpName = "DimethylEther";
        prop.useCoolProp = true;
        prop.colorName = "grey";
        prop.lineStyle = "-.";

    case "DimethylCarbonate"
        prop.dbField = "DimethylCarbonate";
        prop.cpName = "DimethylCarbonate";
        prop.useCoolProp = true;
        prop.colorName = "black";
        prop.lineStyle = "-.";

    case "EthyleneOxide"
        prop.dbField = "C2H4O";
        prop.cpName = "EthyleneOxide";
        prop.useCoolProp = true;
        prop.colorName = "lightblue";
        prop.lineStyle = "-.";

    case "Tetrahydrofuran"
        prop.dbField = "Tetrahydrofuran";
        prop.cpName = "Tetrahydrofuran";
        prop.useCoolProp = true;
        prop.colorName = "deepskyblue";
        prop.lineStyle = "-.";

    case "Formaldehyde"
        prop.dbField = "Formaldehyde";
        prop.cpName = "Formaldehyde";
        prop.useCoolProp = true;
        prop.colorName = "dodgerblue";
        prop.lineStyle = "-.";

    case "MM"
        prop.dbField = "MM";
        prop.cpName = "MM";
        prop.useCoolProp = true;
        prop.colorName = "blue";
        prop.lineStyle = "-.";

    case "MDM"
        prop.dbField = "MDM";
        prop.cpName = "MDM";
        prop.useCoolProp = true;
        prop.colorName = "darkblue";
        prop.lineStyle = "-.";

    case "MD2M"
        prop.dbField = "MD2M";
        prop.cpName = "MD2M";
        prop.useCoolProp = true;
        prop.colorName = "darkslateblue";
        prop.lineStyle = "-.";

    case "MD3M"
        prop.dbField = "MD3M";
        prop.cpName = "MD3M";
        prop.useCoolProp = true;
        prop.colorName = "mediumslateblue";
        prop.lineStyle = "-.";

    case "MD4M"
        prop.dbField = "MD4M";
        prop.cpName = "MD4M";
        prop.useCoolProp = true;
        prop.colorName = "blueviolet";
        prop.lineStyle = "-.";

    case "D4"
        prop.dbField = "D4";
        prop.cpName = "D4";
        prop.useCoolProp = true;
        prop.colorName = "purple";
        prop.lineStyle = "-.";

    case "D5"
        prop.dbField = "D5";
        prop.cpName = "D5";
        prop.useCoolProp = true;
        prop.colorName = "orchid";
        prop.lineStyle = "-.";

    case "D6"
        prop.dbField = "D6";
        prop.cpName = "D6";
        prop.useCoolProp = true;
        prop.colorName = "magenta";
        prop.lineStyle = "-.";

    case "MethylOleate"
        prop.dbField = "MethylOleate";
        prop.cpName = "MethylOleate";
        prop.useCoolProp = true;
        prop.colorName = "deeppink";
        prop.lineStyle = "-.";

    case "MethylPalmitate"
        prop.dbField = "MethylPalmitate";
        prop.cpName = "MethylPalmitate";
        prop.useCoolProp = true;
        prop.colorName = "maroon";
        prop.lineStyle = "-.";

    case "MethylStearate"
        prop.dbField = "MethylStearate";
        prop.cpName = "MethylStearate";
        prop.useCoolProp = true;
        prop.colorName = "crimson";
        prop.lineStyle = "-.";

    case "MethylLinoleate"
        prop.dbField = "MethylLinoleate";
        prop.cpName = "MethylLinoleate";
        prop.useCoolProp = true;
        prop.colorName = "lightcoral";
        prop.lineStyle = "-.";

    case "MethylLinolenate"
        prop.dbField = "MethylLinolenate";
        prop.cpName = "MethylLinolenate";
        prop.useCoolProp = true;
        prop.colorName = "orangered";
        prop.lineStyle = "-.";

    case "HFE143m"
        prop.dbField = "HFE143m";
        prop.cpName = "HFE143m";
        prop.useCoolProp = true;
        prop.colorName = "black";
        prop.lineStyle = ":";

    case "Novec649"
        prop.dbField = "Novec649";
        prop.cpName = "Novec649";
        prop.useCoolProp = true;
        prop.colorName = "purple";
        prop.lineStyle = "-";

    case "SES36"
        prop.dbField = "SES36";
        prop.cpName = "SES36";
        prop.useCoolProp = true;
        prop.colorName = "deepskyblue";
        prop.lineStyle = "-.";

    case "n-Perfluorobutane"
        prop.dbField = "n-Perfluorobutane";
        prop.cpName = "n-Perfluorobutane";
        prop.useCoolProp = true;
        prop.colorName = "dodgerblue";
        prop.lineStyle = "-.";

    case "n-Perfluoropentane"
        prop.dbField = "n-Perfluoropentane";
        prop.cpName = "n-Perfluoropentane";
        prop.useCoolProp = true;
        prop.colorName = "blue";
        prop.lineStyle = "-.";

    case "n-Perfluorohexane"
        prop.dbField = "n-Perfluorohexane";
        prop.cpName = "n-Perfluorohexane";
        prop.useCoolProp = true;
        prop.colorName = "darkblue";
        prop.lineStyle = ":";

    case "Chloroform"
        prop.dbField = "Chloroform";
        prop.cpName = "Chloroform";
        prop.useCoolProp = true;
        prop.colorName = "darkslateblue";
        prop.lineStyle = ":";

    case "Dichloromethane"
        prop.dbField = "Dichloromethane";
        prop.cpName = "Dichloromethane";
        prop.useCoolProp = true;
        prop.colorName = "mediumslateblue";
        prop.lineStyle = ":";

    case "Dichloroethane"
        prop.dbField = "Dichloroethane";
        prop.cpName = "Dichloroethane";
        prop.useCoolProp = true;
        prop.colorName = "blueviolet";
        prop.lineStyle = ":";

    case "VinylChloride"
        prop.dbField = "VinylChloride";
        prop.cpName = "VinylChloride";
        prop.useCoolProp = true;
        prop.colorName = "purple";
        prop.lineStyle = ":";

% =========================================================================
% Refrigerants
% =========================================================================

    case "R13I1"
        prop.dbField = "R13I1";
        prop.cpName = "R13I1";
        prop.useCoolProp = true;
        prop.colorName = "darkblue";
        prop.lineStyle = "-";

    case "R134a"
        prop.dbField = "R134a";
        prop.cpName = "R134a";
        prop.useCoolProp = true;
        prop.colorName = "yellow";
        prop.lineStyle = "-";

    case "R236FA"
        prop.dbField = "R236FA";
        prop.cpName = "R236FA";
        prop.useCoolProp = true;
        prop.colorName = "blueviolet";
        prop.lineStyle = "-";

    case "R245fa"
        prop.dbField = "R245fa";
        prop.cpName = "R245fa";
        prop.useCoolProp = true;
        prop.colorName = "magenta";
        prop.lineStyle = "-";

    case "R1234yf"
        prop.dbField = "R1234yf";
        prop.cpName = "R1234yf";
        prop.useCoolProp = true;
        prop.colorName = "saddlebrown";
        prop.lineStyle = ":";

    case "R1234ze(E)"
        prop.dbField = "R1234ze(E)";
        prop.cpName = "R1234ze(E)";
        prop.useCoolProp = true;
        prop.colorName = "deeppink";
        prop.lineStyle = "-";

    case "R11"
        prop.dbField = "R11";
        prop.cpName = "R11";
        prop.useCoolProp = true;
        prop.colorName = "yellowgreen";
        prop.lineStyle = ":";

    case "R12"
        prop.dbField = "R12";
        prop.cpName = "R12";
        prop.useCoolProp = true;
        prop.colorName = "mediumslateblue";
        prop.lineStyle = "-";

    case "R21"
        prop.dbField = "R21";
        prop.cpName = "R21";
        prop.useCoolProp = true;
        prop.colorName = "olive";
        prop.lineStyle = "-";

    case "R22"
        prop.dbField = "R22";
        prop.cpName = "R22";
        prop.useCoolProp = true;
        prop.colorName = "lawngreen";
        prop.lineStyle = "-";

    case "R32"
        prop.dbField = "R32";
        prop.cpName = "R32";
        prop.useCoolProp = true;
        prop.colorName = "orange";
        prop.lineStyle = "-";

    case "R40"
        prop.dbField = "R40";
        prop.cpName = "R40";
        prop.useCoolProp = true;
        prop.colorName = "grey";
        prop.lineStyle = ":";

    case "R113"
        prop.dbField = "R113";
        prop.cpName = "R113";
        prop.useCoolProp = true;
        prop.colorName = "lightblue";
        prop.lineStyle = "-";

    case "R114"
        prop.dbField = "R114";
        prop.cpName = "R114";
        prop.useCoolProp = true;
        prop.colorName = "deepskyblue";
        prop.lineStyle = ":";

    case "R115"
        prop.dbField = "R115";
        prop.cpName = "R115";
        prop.useCoolProp = true;
        prop.colorName = "maroon";
        prop.lineStyle = "-";

    case "R123"
        prop.dbField = "R123";
        prop.cpName = "R123";
        prop.useCoolProp = true;
        prop.colorName = "darkcyan";
        prop.lineStyle = "-";

    case "R124"
        prop.dbField = "R124";
        prop.cpName = "R124";
        prop.useCoolProp = true;
        prop.colorName = "deepskyblue";
        prop.lineStyle = "-";

    case "R125"
        prop.dbField = "R125";
        prop.cpName = "R125";
        prop.useCoolProp = true;
        prop.colorName = "saddlebrown";
        prop.lineStyle = "-";

    case "R141b"
        prop.dbField = "R141b";
        prop.cpName = "R141b";
        prop.useCoolProp = true;
        prop.colorName = "blueviolet";
        prop.lineStyle = ":";

    case "R142b"
        prop.dbField = "R142b";
        prop.cpName = "R142b";
        prop.useCoolProp = true;
        prop.colorName = "lightcoral";
        prop.lineStyle = "-";

    case "R143a"
        prop.dbField = "R143a";
        prop.cpName = "R143a";
        prop.useCoolProp = true;
        prop.colorName = "orchid";
        prop.lineStyle = ":";

    case "R152A"
        prop.dbField = "R152A";
        prop.cpName = "R152A";
        prop.useCoolProp = true;
        prop.colorName = "magenta";
        prop.lineStyle = ":";

    case "R161"
        prop.dbField = "R161";
        prop.cpName = "R161";
        prop.useCoolProp = true;
        prop.colorName = "deeppink";
        prop.lineStyle = ":";

    case "R218"
        prop.dbField = "R218";
        prop.cpName = "R218";
        prop.useCoolProp = true;
        prop.colorName = "crimson";
        prop.lineStyle = "-";

    case "R227EA"
        prop.dbField = "R227EA";
        prop.cpName = "R227EA";
        prop.useCoolProp = true;
        prop.colorName = "orangered";
        prop.lineStyle = "-";

    case "R236EA"
        prop.dbField = "R236EA";
        prop.cpName = "R236EA";
        prop.useCoolProp = true;
        prop.colorName = "yellowgreen";
        prop.lineStyle = "-";

    case "R245ca"
        prop.dbField = "R245ca";
        prop.cpName = "R245ca";
        prop.useCoolProp = true;
        prop.colorName = "forestgreen";
        prop.lineStyle = "-";

    case "R365MFC"
        prop.dbField = "R365MFC";
        prop.cpName = "R365MFC";
        prop.useCoolProp = true;
        prop.colorName = "orange";
        prop.lineStyle = ":";

    case "R404A"
        prop.dbField = "R404A";
        prop.cpName = "R404A";
        prop.useCoolProp = true;
        prop.colorName = "sandybrown";
        prop.lineStyle = ":";

    case "R407C"
        prop.dbField = "R407C";
        prop.cpName = "R407C";
        prop.useCoolProp = true;
        prop.colorName = "springgreen";
        prop.lineStyle = "-";

    case "R410A"
        prop.dbField = "R410A";
        prop.cpName = "R410A";
        prop.useCoolProp = true;
        prop.colorName = "cyan";
        prop.lineStyle = "-";

    case "R507A"
        prop.dbField = "R507A";
        prop.cpName = "R507A";
        prop.useCoolProp = true;
        prop.colorName = "saddlebrown";
        prop.lineStyle = ":";

    case "R1233zd(E)"
        prop.dbField = "R1233zd(E)";
        prop.cpName = "R1233zd(E)";
        prop.useCoolProp = true;
        prop.colorName = "darkseagreen";
        prop.lineStyle = ":";

    case "R1234ze(Z)"
        prop.dbField = "R1234ze(Z)";
        prop.cpName = "R1234ze(Z)";
        prop.useCoolProp = true;
        prop.colorName = "forestgreen";
        prop.lineStyle = ":";

    case "R1243zf"
        prop.dbField = "R1243zf";
        prop.cpName = "R1243zf";
        prop.useCoolProp = true;
        prop.colorName = "springgreen";
        prop.lineStyle = ":";

    case "R1336mzz(E)"
        prop.dbField = "R1336mzz(E)";
        prop.cpName = "R1336mzz(E)";
        prop.useCoolProp = true;
        prop.colorName = "cyan";
        prop.lineStyle = ":";

    case "RC318"
        prop.dbField = "RC318";
        prop.cpName = "RC318";
        prop.useCoolProp = true;
        prop.colorName = "grey";
        prop.lineStyle = ":";

    otherwise
        error('Unknown species: %s', speciesName);
end

prop.label = speciesName;
prop.color = colorNameToRGB(prop.colorName);

end

function rgb = colorNameToRGB(colorName)

switch lower(string(colorName))
    case "lightblue"
        rgb = [173, 216, 230]/255;
    case "deepskyblue"
        rgb = [0, 191, 255]/255;
    case "dodgerblue"
        rgb = [30, 144, 255]/255;
    case "blue"
        rgb = [0, 0, 255]/255;
    case "darkblue"
        rgb = [0, 0, 139]/255;
    case "darkslateblue"
        rgb = [72, 61, 139]/255;
    case "mediumslateblue"
        rgb = [123, 104, 238]/255;
    case "blueviolet"
        rgb = [138, 43, 226]/255;
    case "purple"
        rgb = [128, 0, 128]/255;
    case "orchid"
        rgb = [218, 112, 214]/255;
    case "magenta"
        rgb = [255, 0, 255]/255;
    case "deeppink"
        rgb = [255, 20, 147]/255;
    case "maroon"
        rgb = [176, 48, 96]/255;
    case "crimson"
        rgb = [220, 20, 60]/255;
    case "lightcoral"
        rgb = [240, 128, 128]/255;
    case "orangered"
        rgb = [255, 69, 0]/255;
    case "orange"
        rgb = [255, 165, 0]/255;
    case "sandybrown"
        rgb = [244, 164, 96]/255;
    case "khaki"
        rgb = [240, 230, 140]/255;
    case "olive"
        rgb = [128, 128, 0]/255;
    case "saddlebrown"
        rgb = [139, 69, 19]/255;
    case "yellow"
        rgb = [255, 255, 0]/255;
    case "yellowgreen"
        rgb = [154, 205, 50]/255;
    case "lawngreen"
        rgb = [124, 252, 0]/255;
    case "lightgreen"
        rgb = [144, 238, 144]/255;
    case "darkseagreen"
        rgb = [143, 188, 143]/255;
    case "forestgreen"
        rgb = [34, 139, 34]/255;
    case "springgreen"
        rgb = [0, 255, 127]/255;
    case "cyan"
        rgb = [0, 255, 255]/255;
    case "darkcyan"
        rgb = [0, 139, 139]/255;
    case "grey"
        rgb = [128, 128, 128]/255;
    case "white"
        rgb = [255, 255, 255]/255;
    case "black"
        rgb = [0, 0, 0]/255;
    otherwise
        rgb = [0, 0, 0]/255;
end

end
