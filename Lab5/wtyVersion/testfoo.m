nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples - 1)) / sampFreq;
timeLen=timeVec(end)-timeVec(1);
Parmt.a1=10;Parmt.a2=3;Parmt.a3=3;
SNR=10;
SigVec=foo(timeVec,SNR,Parmt);

figure("Name",'间轴以秒为单位的信号时间序列图');
plot(timeVec,SigVec);
xlabel('Times/s');
ylabel('Signal');
grid on;

%%画信号周期图 periodogram图

N = length(timeVec); %时间向量的分量数
timeLength=timeVec(end)-timeVec(1);
fftVec = fft(SigVec);
NyqLimIdx = floor(N / 2) + 1; %Nyquist Limit频率所对应的指数 Nyquist Limit Index(the the index when f=fs/2)
posFreq = (0:(NyqLimIdx - 1) );
fftVec_posFreq = fftVec(1:NyqLimIdx);
figure('Name', 'Periodogram(|fft|-f)', 'Position', [100 100 800 600]);
fftline = plot(posFreq, abs(fftVec_posFreq));
hold on;
xlabel("频率Frequency(Hz)");
ylabel("|fft|");

