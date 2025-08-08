clc,clear;
syms t;
%% 滤波 Filtering
filtNsampl = 2048;
filtSamplFreq = 1024; %Hz
filtTintv = 1 / filtSamplFreq;
filtTlen = (filtNsampl - 1) / filtSamplFreq;
filtTimeVec = 0:filtTintv:filtTlen;
% [fA1,fA2,fA3]=deal(10,5,2.5);
% [fF1,fF2,fF3]=deal(100,200,300);
% [fphi1,fphi2,fphi3]=deal(0,pi/6,phi/4);
filtCoeffName = {"fA1", "fA2", "fA3", "fF1", "fF2", "fF3", "fphi1", "fphi2", "fphi3"};
syms(filtCoeffName{:});
filtCoeffValue = [10, 5, 2.5, 100, 200, 300, 0, pi / 6, pi / 4];
filtSig1 = fA1 * sin(fF1 * t + fphi1);
filtSig2 = fA1 * sin(fF2 * t + fphi2);
filtSig3 = fA1 * sin(fF3 * t + fphi3);
filtSigExpr = filtSig1 + filtSig2 + filtSig3;
filtSig = Signal('sum of three sinusoids', filtTimeVec, filtSigExpr, t, filtCoeffName, filtCoeffValue);
flitMaxFreq = ExactEstmFreqBW(filtSig);
fprintf(' the maximum frequency of the discrete time sinusoid you can generate with this sampling frequency is %.4f',flitMaxFreq);

%滤fF1
filtOrder=20;
[fF1,fF2,fF3]=deal(100,200,300);
Wn1=(fF1/2)/(filtSamplFreq/2);
Wn2=(fF2/2)/(filtSamplFreq/2);
Wn3=(fF3/2)/(filtSamplFreq/2);
b1= fir1(filtOrder,Wn1,'low');
b2= fir1(filtOrder,Wn2,'low');
b3= fir1(filtOrder,Wn3,'low');
filtVec1=fftfilt(b1,filtSig.SigVec);
filtVec2=fftfilt(b2,filtSig.SigVec);
filtVec3=fftfilt(b3,filtSig.SigVec);

figure('Name','低通滤f1波');
hold on;
filtL1=plot(filtTimeVec,filtVec1);
oriL=plot(filtTimeVec,filtSig.SigVec);
legend([filtL1,oriL],{'低通滤f1波','原波'})
axis xy;
xlabel('Time /s');

figure('Name','低通滤f2波');
hold on;
filtL2=plot(filtTimeVec,filtVec2);
oriL=plot(filtTimeVec,filtSig.SigVec);
legend([filtL2,oriL],{'低通滤f2波','原波'})
axis xy;
xlabel('Time /s');

figure('Name','低通滤f3波');
hold on;
filtL3=plot(filtTimeVec,filtVec3);
oriL=plot(filtTimeVec,filtSig.SigVec);
legend([filtL3,oriL],{'低通滤f3波','原波'})
axis xy;
xlabel('Time /s');