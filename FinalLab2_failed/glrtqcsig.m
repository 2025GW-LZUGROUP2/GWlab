function glrt_val = glrtqcsig(timeVec, dataVec, Fs, psd_pos, qcCoefs)
%GLRTQCSIG  单模板（sin）GLRT：先单位 SNR 归一，再算 llr=(x|s_unit)，返回 llr^2
timeVec = timeVec(:).'; dataVec = dataVec(:).';
sig = crcbgenqcsig(timeVec, 1, qcCoefs);
[s_unit, ~] = normsig4psd(sig, Fs, psd_pos, 1);
llr = innerprod_psd(dataVec, s_unit, Fs, psd_pos);
glrt_val = llr^2;
end
