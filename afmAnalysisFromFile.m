function [betaAmp, betaPhase] = afmAnalysisFromFile(filename)

% Read in Data File
data = dlmread(filename, '\t');

% Assign vectors from data
% Frequency <=> x
frequency = data(:,1);
% Amplitude <=> y
amplitude = data(:,2);
% Phase <=> phi
phase = data(:,3);

% Declare amplitude fit model (Lorentzian)
lorentzianModel = @(b,x) (b(1) + b(2)./((x - b(3)).^2 + b(4)));
% Declare phase fit model (arctan)
phaseModel = @(b,x) (((((x .* b(1))./(b(2)))./(b(1).^2 - x.^2))));

% Declare initial fit data
beta0Amp = [min(amplitude); 1; 30000; 1];
beta0Phase = [30000; 450];

% Set Options for Fitting
% Increase max iterations for better fit
options.MaxIter = 15000;
options.TolX = 1e-15;

% Generate fit for frequency/amplitude
betaAmp = nlinfit(frequency, amplitude, lorentzianModel, beta0Amp, options);
% Make fitted function from regression coefficients
fittedAmp = @(x) (betaAmp(1) + betaAmp(2)./((x - betaAmp(3)).^2 + betaAmp(4)));

% Generate fit for frequency/phase
betaPhase = nlinfit(frequency, tan(phase), phaseModel, beta0Phase, options);
% Make fitted function from regression coefficients
fittedPhase = @(x) tan((((((x .* betaPhase(1))./(betaPhase(2)))./(betaPhase(1).^2 - x.^2)))));

% Generate amplitude plot
figure
hold on

% Plot data
plot(frequency, amplitude);

% Plot fit
fplot(fittedAmp, [min(frequency), max(frequency)], 'red');

% Set graph properties
legend('Experimental Data', 'Fitted Function');
xlabel('Frequency (Hz)');
ylabel('Amplitude (V)');

hold off

% Generate phase plot
figure
hold on

% Plot data
plot(frequency, phase);

% Plot fit
fplot(fittedPhase, [min(frequency), max(frequency)], 'red');

% Set graph properties
legend('Experimental Data', 'Fitted Function');
xlabel('Phase (Radians)');
ylabel('Amplitude (V)');

hold off

end