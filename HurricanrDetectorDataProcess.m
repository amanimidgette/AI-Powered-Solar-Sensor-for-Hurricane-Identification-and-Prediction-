clear, clc

%T = readtable('HurricaneCooridnates.csv')
%T


%fgetl(hfile)
%fscanf(file, 'Latitude (°N)   Longitude (°W) ' )
%Table = (file, 'Latitude (°N)   Longitude (°W) ')
%fclose(file)
%fprintf ('Latitude (°N)')
%fprintf('%10.1f')
%Lo = [66.6 74.4 74.0 71.9 84.9 84.9 85.8]
%La = [15.2 21.5 20.5 14.8 19.5 17.6 22.8]

hfile = fopen('HurricaneCooridnates.csv');
H = readtable('HurricaneCooridnates.csv')
Lo = H.Longitude__W_
La = H.Latitude__N_
DetermineV= (Lo(2)-Lo(1))/(La(2)-La(1))

sub0 = 0;
plus0 = 6;

if (DetermineV > sub0)
    disp('Going to the Left')
elseif (DetermineV < sub0)
    disp('Going to the right')
else
    disp('Going straight')
end


