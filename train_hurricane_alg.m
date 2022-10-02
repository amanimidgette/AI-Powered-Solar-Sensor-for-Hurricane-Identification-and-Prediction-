% hurricane train, test algorithm


clc
close all

train = true;
test = false;
costlist = [];
trials = 0;

% init
if train == true
    A1 = rand(2, 6);
    A2 = rand(6, 4);
    A3 = rand(4, 1);

    b1 = rand(2, 6);
    b2 = rand(2, 4);
    b3 = rand(2, 1);

    progress = [];
end

% cd("train\")

a = dir(fullfile("*")); % get everything, range 3-length(a)
for fil = 3:length(a)
    h = open(a(fil).name);
    hurr = h.data;

    for pt = 1:length(hurr(1, :))-1
        M = diag(hurr(pt));

        L1 = A1*M + b1;
        L2 = L1*A2 + b2;
        R = L2*A3 + b3;
        % R(1) = vxr, R(2) = vyr
        % hurr.data(

        vx = hurr(pt+1, 3); vxr = R(1);
        vy = hurr(pt+1, 4); vyr = R(2);
        cost = (vxr-vx)^2 + (vyr-vy)^2;

        trials = trials + 1;
        costlist(trials) = cost;
        % backprop:

%         shift = @(A) rand(size(A)).*(cost/10);

        A3 = A3 - rand(size(A3)).*(cost/10000);
        A2 = A2 - rand(size(A2)).*(cost/10000);
        A1 = A1 - rand(size(A1)).*(cost/10000);

        b1 = b1 - rand(size(b1)).*(cost/10000);
        b2 = b2 - rand(size(b2)).*(cost/10000);
        b3 = b3 - rand(size(b3)).*(cost/10000);

    end
end


save("decent_cost_2", "A1", "A2", "A3", "b1", "b2", "b3", "costlist", "trials")

plot(1:trials, costlist)