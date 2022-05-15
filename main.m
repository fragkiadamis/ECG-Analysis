%% Clean enviroment
clear; clc;

%% ECG Analysis

% Import ECG data using importfile function.
% importfile function was generated using the import tool
% of matlab in order to import the data using correct types
% datetime (m:ss.SSS) for time and numeric for voltage.
data = importfile("./samplesECG/samples/arrythmia1.txt");
timeX = data.time;
voltageY = data.voltage;

% Find Q and R peaks (Q, R for voltage and TQ, TR for time of peak)
[R, TR]  = findpeaks(voltageY, timeX, 'MinPeakHeight', 0.5);
[Q, TQ]  = findpeaks(-voltageY, timeX, 'MinPeakHeight', 0.4, 'minPeakDistance', milliseconds(500));

% Find the R to R timeframe (how many milliseconds is each R peak from its next)
for t=1:length(R)-1
    RR(t, 1) = milliseconds(TR(t+1, 1) - TR(t, 1));
end

% Mean timeframe from R to R
RRmean = mean(RR);
% Check if any R to R time is 100ms greater than the RRmean
arrythmiaPos = -1; % Set arrythmiaPos to -1.
for i=1:length(RR)
    if RR(i) - RRmean > 100
        disp("There is an arrythmia");
        arrythmiaPos = i; % Store R position that indicates the arrythmia
    end
end

%% Plot ECG with analysis results

figure(1)
% Plot ECG with QR peaks
subplot(2,1,1);
plot(timeX, voltageY, 'Color', [0 0.4470 0.7410])
hold on
plot(TR, R, '^r')
plot(TQ, -Q, 'vg')
hold off
grid on
legend('ECG', 'R-peaks', 'Q-peaks', 'Location', 'south')

% If arrythmia found and changed the arrythmiaPos from -1 to a positive
% number, plot the ecg with the arrythmia marked
if arrythmiaPos > 0
    % Plot ECG with Arrythmia
    subplot(2,1,2);
    plot(timeX, voltageY, 'Color', [0 0.4470 0.7410])
    hold on
    plot(TR(arrythmiaPos), R(arrythmiaPos), 'or')
    grid on
    legend('ECG', 'Arrythmia', 'Location', 'south')
end