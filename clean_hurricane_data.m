% hurricane cleaning

clc
clear
close all

years = ["2018" "2019" "2020" "2021"];

% hurr = readmatrix("2021_Sam.txt");
% disp(hurr)

% clean all of the data
    % save as csv's in train/test folders
    % remove unneccessary  files
    % convert knots (Wind Speed, kt) to m/s 
    % [lat, long] + dx, dy
format default
format short
format compact
count = 0;
prob = [""];
good = [""];
% prob = [];

%find the usable ones
for yr = max(size(years)):-1:2 % split by year
    a = dir(years(yr) + "*");
    for tot = 1:length(a)
        hurr = readmatrix(a(tot).name);
        size_hurr = size(hurr);
        filename = convertCharsToStrings(a(tot).name);

        headers = ["Date" "/" "Time" "Latitude(^oN)" "Longitude(^oW)" "Pressure (mb)" "Wind Speed (kt)" "Stage"];

        if size_hurr(2) ~= 8
            prob(count + 1) = filename + ", a.ind = " + tot + " of " + length(a);
            count = count + 1;          
            % hurr 
        else
            good(length(good)+1) = filename;
        end
    end  
end
% good'
% %%

good = good(2: length(good));
for name = good
    hurr = readmatrix(name);
    size_hurr = size(hurr);
    filename = convertStringsToChars(name); 
    headers = ["Date" "/" "Time" "Latitude(^oN)" "Longitude(^oW)" "Pressure (mb)" "Wind Speed (kt)" "Stage"];

    % clear unneccessary col's (data and headers), col2, col8
    hurr = hurr(:, 3:7); % hurr, headers change together
    headers = headers(:, 3:7); % headers = [Time Lat Long Pressure WindSpeed]

    % calc dx, dy
    % equals (x+1) - x; f(x+1) - f(x)
    hurr = cat(2, hurr, zeros(length(hurr), 2));
    headers = cat(2, headers, ["dx" "dy"]); % headers = [Time Lat Long Pressure WindSpeed dx dy]

    dt = zeros(length(hurr)-1, 1); dx = dt; dy = dt;
    for ind = 1:length(hurr(:, 1))-1
        dx(ind) = hurr(ind, 3) - hurr(ind+1, 3);
        dy(ind) = hurr(ind, 2) - hurr(ind+1, 2);
        dt(ind) = hurr(ind, 1) - hurr(ind+1, 1);
    end

    dt(round(abs(dt)) == 18) = 6;
    dt = dt./600;
    dx = dx./dt; % keep dx, dy normalized to 6hr dt.
    dy = dy./dt;
%     disp([dx, dy]);

    hurr = hurr(1:length(hurr)-1, :); % shave off bottom row (no dx, dy, data there)

    hurr(:, length(hurr(1, :))-1) = dx;
    hurr(:, length(hurr(1, :)) ) = dy;

    hurr = hurr(:, 2: length(hurr(1, :)));
    headers = headers(2:length(headers));
    % reorder
    hurr = hurr(:, [1 2 5 6 3 4]);
    headers = headers([1 2 5 6 3 4]);

    % save in train, test IF they don't already exist
    nam = convertStringsToChars(good(good == name));
    year = convertCharsToStrings(nam(1:4));

    if (year == "2020") || (year == "2021")
        folder = "train\";
    else
        folder = "test\";
    end
    
    data = hurr;

    filename = filename(1:length(filename)-4) + ".mat";
    cd(folder)
    disp(folder)
    save(filename, "data", "headers")
    cd ..
    
    % if year >= 2020 : train
    % if year  < 2020 : test

    
%     clear headers; clear hurr
end


% prob'
good'
