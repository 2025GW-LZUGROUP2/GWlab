%% Signals and audio
% Time domain signal: sum of two sinusoids with frequencies 5 Hz and 1 Hz
nSamples = 8192*1;%prop time
GenSamplingFreq = 4;
t = (0:(nSamples-1))/samplingFreq;
st = sin(2*pi*2*t);

PlayerSamplFreq=8192;
soundsc(st,PlayerSamplFreq);

trueFreq=SigFreq*PlayerSamplFreq/GenSamplingFreq;

% audiowrite('SampleSoundSignal.wav',st,8192);