% build_nasa7.m
clc
clear
close all
if exist("thermoNASA.dat","file")
    delete("thermoNASA.dat")
end

Tmin =  300;
Tmid = 1000;
Tmax = 1500;
Npts =  241;

specs = [
  struct("fluid","R134a" ,"speciesID","R134A" ,"name","R134a" ,"elements",["C","H","F"],"atoms",[2 2 4],"M",102.03200e-3)
  struct("fluid","R245fa","speciesID","R245FA","name","R245fa","elements",["C","H","F"],"atoms",[3 3 5],"M",134.04794e-3)
  struct("fluid","R245ca","speciesID","R245CA","name","R245ca","elements",["C","H","F"],"atoms",[3 3 5],"M",134.04794e-3)
  struct("fluid","R236fa","speciesID","R236FA","name","R236fa","elements",["C","H","F"],"atoms",[3 2 6],"M",152.03800e-3)
  struct("fluid","R236ea","speciesID","R236EA","name","R236ea","elements",["C","H","F"],"atoms",[3 2 6],"M",152.03800e-3)
];

for i = 1:numel(specs)
    spec = specs(i);

    [T,CP_R,H_RT,S_R,CP_R_zero,S_R_zero,H_RT_zero] = make_data(spec,Tmin,Tmax,Npts);

    % derivative at midpoint
    [~,mid] = min(abs(T-Tmid));
    dcp = gradient(CP_R,T);
    DCPRDT = dcp(mid);

    z = [T.';CP_R.';H_RT.';S_R.'];

    [x,cp_fit,index_mid,a_0_6,a_1_6,s_fit,a_0_7,a_1_7,h_fit] = ...
        poly_cp(z,Tmin,Tmid,Tmax,CP_R_zero,DCPRDT,S_R_zero,H_RT_zero);

    low  = [x(1:5).'  a_0_6 a_0_7];
    high = [x(6:10).' a_1_6 a_1_7];

    write_nasa7(spec.speciesID,low,high,Tmin,Tmid,Tmax)

end


function [T,CP_R,H_RT,S_R,CP_R_zero,S_R_zero,H_RT_zero] = make_data(spec,Tmin,Tmax,N)
Ru = 8.31446261815324;
Rspec = Ru/spec.M;
T = linspace(Tmin,Tmax,N).';
cp0 = zeros(size(T));

for k = 1:numel(T)
cp0(k) = double(py.CoolProp.CoolProp.PropsSI('CP0MASS','T',T(k),'P',101325,spec.fluid));
end
CP_R = cp0./Rspec;

% integrate to get h and s
h = cumtrapz(T,cp0);
s = cumtrapz(T,cp0./T);
H_RT = h./(Rspec*T);
S_R  = s./Rspec;
CP_R_zero = double(py.CoolProp.CoolProp.PropsSI('CP0MASS','T',298.15,'P',101325,spec.fluid))/Rspec;
S_R_zero = 0;
H_RT_zero = 0;
end


function write_nasa7(name,low,high,Tmin,Tmid,Tmax)
fid = fopen("thermoNASA.dat","a");
fprintf(fid,'%-18sG%10.2f%10.2f%10.2f    1\n',name,Tmin,Tmax,Tmid);
fprintf(fid,'%15.8E%15.8E%15.8E%15.8E%15.8E    2\n',high(1:5));
fprintf(fid,'%15.8E%15.8E%15.8E%15.8E%15.8E    3\n', ...
    high(6),high(7),low(1),low(2),low(3));
fprintf(fid,'%15.8E%15.8E%15.8E%15.8E                   4\n', ...
    low(4),low(5),low(6),low(7));
fclose(fid);
end