% This script completes all Lab1 tasks in one go (本文件将一次性完成Lab1的所有任务)
% We define a class Signal to describe and generate parameterized mathematical signals, supporting symbolic expressions, parameter substitution, and signal vector generation. (定义了Signal类)
% Use help Signal; help ExactEstmFreqBW; for more info. (请使用help命令查看帮助)

clc; clear;
% Define symbolic variable (定义符号变量)
syms t;
SNR = 10; % Signal-to-noise ratio (信噪比)
tIntvl = [0, 1]; % Time interval [0,1] (时间区间)
fsInit = 300; % Initial high sampling rate (初始采样率)
timeLength = tIntvl(2) - tIntvl(1);
timeVec = (tIntvl(1):1 / fsInit:tIntvl(2));
run(fullfile(fileparts(mfilename('fullpath')), 'Lab1SigDef.m')) % Reference Lab1SigDef.m (引用信号定义文件)

%% Define all signal types and properties (定义所有信号类型及属性)
SigCho = [Sig_qc, Sig_lc, Sig_ss, Sig_FM, Sig_Sg, Sig_AM, Sig_AMFM];
SigTypes = {'qc', 'lc', 'ss', 'FM', 'Sg', 'AM', 'AMFM'};
PhiMap = struct();
PhiMap.qc = phi_qc;
PhiMap.lc = phi_lc;
PhiMap.ss = phi_ss;
PhiMap.FM = phi_FM;

signalNames = struct();
signalNames.qc = 'Quadratic Chirp (二次调频)';
signalNames.lc = 'Linear Chirp (线性调频)';
signalNames.ss = 'Sinusoidal Signal (正弦)';
signalNames.FM = 'FM Sinusoid (频率调制)';
signalNames.Sg = 'Sine-Gaussian (正弦-高斯)';
signalNames.AM = 'AM Sinusoid (幅度调制)';
signalNames.AMFM = 'AM-FM Sinusoid (幅频调制)';

scriptDir = fileparts(mfilename('fullpath'));
resultDir = fullfile(scriptDir, 'result');
if ~exist(resultDir, 'dir')
    mkdir(resultDir);
    fprintf('Created main result directory: %s (创建主结果目录)\n', resultDir);
end

%% Process each signal type (循环处理每种信号)
for sigIdx = 1:length(SigCho)
    try
        SigNow = SigCho(sigIdx);
        currentType = SigTypes{sigIdx};
        fprintf('\n\n============================================\n');
        fprintf('Processing signal type: %s - %s\n', currentType, signalNames.(currentType));
        fprintf('============================================\n');
        if isfield(PhiMap, currentType)
            phiNow = PhiMap.(currentType);
            fprintf('Set phi for standard sinusoid (设置标准正弦phi)\n');
        else
            phiNow = [];
            fprintf('Non-standard sinusoid, phi is empty (非标准正弦phi为空)\n');
        end
        maxFreq = ExactEstmFreqBW(SigNow);
        NyqFreq = 2 * maxFreq;
        sampFreq = 5 * NyqFreq;
        sampIntvl = 1 / sampFreq;
        timeVec = tIntvl(1):sampIntvl:tIntvl(2);
        SigNow.timeVec = timeVec;
        SigVec = SigNow.SigVec;
        SigVec = SNR * SigVec / norm(SigVec);
        N = length(timeVec);
        fftVec = fft(SigVec);
    catch e
        fprintf('Error processing signal %s: %s (处理信号出错)\n', currentType, e.message);
        fprintf('Skip this signal and continue (跳过此信号)\n');
        continue;
    end
    %% Plot Signal-Time
    fi1=figure('Name', ['Signal-Time - ', currentType]);
    plot(timeVec, SigVec, 'Marker', '.', 'MarkerSize', 20);
    xlabel('Time (s) (时间)');
    ylabel('Signal');
    title(['Signal: ', signalNames.(currentType)]);
    %% Plot Periodogram (|fft|-f)
    fprintf('Criterion: If most |fft| area is within 0-NyqFreq, maxFreq is correct. (判断标准)\n');
    NyqLimIdx = floor(N / 2) + 1;
    posFreq = (0:(NyqLimIdx - 1) / timeLength);
    fftVec_posFreq = fftVec(1:NyqLimIdx);
    fi2=figure('Name', ['Periodogram |fft|-f - ', currentType], 'Position', [100 100 800 600]);
    fftline = plot(posFreq, abs(fftVec_posFreq));
    hold on;
    xlabel('Frequency (Hz) (频率)');
    ylabel('|fft|');
    title(['Signal: ', signalNames.(currentType)]);
    fillX = [posFreq(posFreq <= NyqFreq), NyqFreq];
    fillY = [abs(fftVec_posFreq(1:sum(posFreq <= NyqFreq))), 0];
    fill([fillX, flip(fillX)], [fillY, zeros(size(fillY))], 'cyan', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    h1 = xline(maxFreq, 'r--', 'LineWidth', 1);
    h2 = xline(NyqFreq, 'b--', 'LineWidth', 1);
    grid on;
    legend([fftline, h1, h2], {'|fft|', 'max Frequency', 'Nyquist Frequency'});
    %% Compare periodogram
    fi3=figure("Name", ['Periodogram Compare - ', currentType]);
    [pxx, w] = periodogram(SigVec, rectwin(N), N, sampFreq); 
    plot(w,sqrt(length(pxx)*abs(pxx)))
    xlabel('Frequency (Hz) (频率)');
    title(['Signal: ', signalNames.(currentType)]);
    %% Spectrogram
    fi4=figure("Name", ['Spectrogram - ', currentType]);
    winTlen = 0.2/20;
    ovlTlen = 0.1/20;
    winSamplN = floor(winTlen * sampFreq * 10);
    ovlSamplN = floor(ovlTlen * sampFreq * 10);
    [S, F, T] = spectrogram(SigVec, winSamplN, ovlSamplN, [], sampFreq * 10);
    imagesc(T, F, abs(S));
    axis xy;
    xlabel('Time (s) (时间)'); ylabel('Frequency (Hz) (频率)')
    title(['Signal: ', signalNames.(currentType)]);



    %  保存结果到 /result/信号类型 文件夹
    scriptDir = fileparts(mfilename('fullpath'));
    resultDir = fullfile(scriptDir, 'result');
    if ~exist(resultDir, 'dir'), mkdir(resultDir); end
    
    % 确保有效的信号类型标识符
    if ~isfield(signalNames, currentType)
        warning('未知的信号类型标识符: %s，跳过处理', currentType);
        continue;
    end
    
    % 创建当前信号类型的文件夹
    sigDir = fullfile(resultDir, signalNames.(currentType));
    if ~exist(sigDir, 'dir'), mkdir(sigDir); end
    fprintf('为 %s 创建输出目录: %s\n', currentType, sigDir);
    
    % 准备保存图像（三种格式：fig, pdf, jpg）
    % 图1: 信号的Signal-Time图
    sigTimePath_fig = fullfile(sigDir, 'signal_time.fig');
    sigTimePath_pdf = fullfile(sigDir, 'signal_time.pdf');
    sigTimePath_jpg = fullfile(sigDir, 'signal_time.jpg');
    
    % 图2: Periodogram图，信号的|fft|-f图
    fftPath_fig = fullfile(sigDir, 'periodogram.fig');
    fftPath_pdf = fullfile(sigDir, 'periodogram.pdf');
    fftPath_jpg = fullfile(sigDir, 'periodogram.jpg');
    
    % 图3: periodogram比较图
    periPath_fig = fullfile(sigDir, 'periodogram_compare.fig');
    periPath_pdf = fullfile(sigDir, 'periodogram_compare.pdf');
    periPath_jpg = fullfile(sigDir, 'periodogram_compare.jpg');
    
    % 图4: 时频图spectrogram
    specPath_fig = fullfile(sigDir, 'spectrogram.fig');
    specPath_pdf = fullfile(sigDir, 'spectrogram.pdf');
    specPath_jpg = fullfile(sigDir, 'spectrogram.jpg');
    
    % 保存所有图像，三种格式
    try
        % 保存图1 - 移除工具栏并使用更好的导出选项
        saveas(fi1, sigTimePath_fig);
        ax1 = gca(fi1); % 获取当前坐标区
        ax1.Toolbar.Visible = 'off'; % 隐藏工具栏
        exportgraphics(fi1, sigTimePath_pdf, 'Resolution', 300, 'ContentType', 'vector');
        exportgraphics(fi1, sigTimePath_jpg, 'Resolution', 300);
        
        % 保存图2
        saveas(fi2, fftPath_fig);
        ax2 = gca(fi2);
        ax2.Toolbar.Visible = 'off';
        exportgraphics(fi2, fftPath_pdf, 'Resolution', 300, 'ContentType', 'vector');
        exportgraphics(fi2, fftPath_jpg, 'Resolution', 300);
        
        % 保存图3
        saveas(fi3, periPath_fig);
        ax3 = gca(fi3);
        ax3.Toolbar.Visible = 'off';
        exportgraphics(fi3, periPath_pdf, 'Resolution', 300, 'ContentType', 'vector');
        exportgraphics(fi3, periPath_jpg, 'Resolution', 300);
        
        % 保存图4
        saveas(fi4, specPath_fig);
        ax4 = gca(fi4);
        ax4.Toolbar.Visible = 'off';
        exportgraphics(fi4, specPath_pdf, 'Resolution', 300, 'ContentType', 'vector');
        exportgraphics(fi4, specPath_jpg, 'Resolution', 300);
    catch
        % 如果exportgraphics失败，尝试使用saveas作为备选
        try
            if ~exist(sigTimePath_jpg, 'file')
                saveas(fi1, sigTimePath_jpg);
            end
            if ~exist(fftPath_jpg, 'file')
                saveas(fi2, fftPath_jpg);
            end
            if ~exist(periPath_jpg, 'file')
                saveas(fi3, periPath_jpg);
            end
            if ~exist(specPath_jpg, 'file')
                saveas(fi4, specPath_jpg);
            end
            
            if ~exist(sigTimePath_pdf, 'file')
                saveas(fi1, sigTimePath_pdf);
            end
            if ~exist(fftPath_pdf, 'file')
                saveas(fi2, fftPath_pdf);
            end
            if ~exist(periPath_pdf, 'file')
                saveas(fi3, periPath_pdf);
            end
            if ~exist(specPath_pdf, 'file')
                saveas(fi4, specPath_pdf);
            end
        catch
            warning('部分图像保存失败');
        end
    end
    
    %  保存文本结果
    txtPath = fullfile(sigDir, 'signal_info.txt');
    fid = fopen(txtPath, 'w');
    if fid ~= -1
        fprintf(fid, '信号类型: %s\n', signalNames.(currentType));
        fprintf(fid, '信号标识: %s\n', currentType);
        % 尝试获取信号表达式（如果可用）
        try
            fprintf(fid, '信号表达式: %s\n', char(SigNow.SigExp));
        catch
            fprintf(fid, '信号表达式: 不可用\n');
        end
        fprintf(fid, '最大频率: %f Hz\n', maxFreq);
        fprintf(fid, '奈奎斯特频率: %f Hz\n', NyqFreq);
        fprintf(fid, '采样频率: %f Hz\n', sampFreq);
        fprintf(fid, '时间区间: [%f, %f] s\n', tIntvl(1), tIntvl(2));
        fprintf(fid, '信噪比: %f\n', SNR);
        fclose(fid);
    else
        warning('无法写入文本文件：%s', txtPath);
    end
    
    fprintf('文件已保存至：\n  %s\n', sigDir);
    
    % 关闭图形窗口，准备处理下一个信号
    close(fi1);
    close(fi2);
    close(fi3);
    close(fi4);
    
    % 暂停一下，让用户可以查看输出
    pause(1);
end

%% 完成所有信号处理
fprintf('\n\n============================================\n');
fprintf('所有信号处理完毕！\n');
fprintf('结果已保存到目录：%s\n', resultDir);
fprintf('============================================\n');


