function [beta] = afmAnalysisFromFile(filename)

% Read in Data File
data = dlmread(filename, '\t');

% Assign vectors from data
% Frequency <=> x
frequency = transpose(data(:,1));
% Amplitude <=> y
amplitude = transpose(data(:,2));
% Phase <=> phi
phase = data(:,3);

% Declare fit model (Lorentzian)
lorentzianModel = @(b,x) (b(1) + b(2)./((x - b(3)).^2 + b(4)));

% Declare initial fit data
beta0 = [0.1 10 300000 10];

% Generate fit
beta = nlinfit(frequency, amplitude, lorentzianModel, beta0);

% Make fitted function from regression coefficients
fittedFunction = @(x) (beta(1) + beta(2)./((x - beta(3)).^2 + beta(4)));

% Generate figure for first plot
figure
hold on

% Plot data
plot(frequency, amplitude);

% Plot fit
fplot(fittedFunction, [0, 2000]);

hold off

end