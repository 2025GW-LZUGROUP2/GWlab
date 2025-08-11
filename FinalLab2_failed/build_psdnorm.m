function PSDnorm = build_psdnorm(Ppos, N)
%BUILD_PSDNORM 由单边 PSD Ppos 构造长度为 N 的双边 PSD 向量
% 双边顺序与内积/白化保持一致： [Ppos , mirror]
% mirror 的起点按奇偶处理，避免重复 DC/Nyq
Nyq = floor(N/2)+1;
neg_f_strt = 1 - mod(N,2);  % 偶数->1, 奇数->0
PSDnorm = [Ppos , Ppos(((Nyq-1)-neg_f_strt):-1:1)];
end
