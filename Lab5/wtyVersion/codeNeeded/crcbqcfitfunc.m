
function [fitVal,varargout] = crcbqcfitfunc(xVec,params)
%Fitness function for quadratic chirp regression  % 二次啁啾回归的适应度函数
%F = CRCBQCFITFUNC(X,P)  % F = CRCBQCFITFUNC(X,P)
%Compute the fitness function (sum of squared residuals function after  % 计算适应度函数（对幅值参数最大化后的残差平方和）
%maximimzation over the amplitude parameter) for data containing the  % 针对包含二次啁啾信号的数据。X为输入，适应度值返回在F中
%quadratic chirp signal. X.  The fitness values are returned in F. X is  % X是标准化的，即0<=X(i,j)<=1。
%standardized, that is 0<=X(i,j)<=1. The fields P.rmin and P.rmax  are used  % P.rmin和P.rmax用于内部转换X(i,j)
%to convert X(i,j) internally before computing the fitness:  % 计算适应度前的内部转换：
%X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j).  % X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j)
%The fields P.dataY and P.dataX are used to transport the data and its  % P.dataY和P.dataX用于传递数据及其时间戳
%time stamps. The fields P.dataXSq and P.dataXCb contain the timestamps  % P.dataXSq和P.dataXCb分别为时间戳的平方和立方
%squared and cubed respectively.  %
%
%[F,R] = CRCBQCFITFUNC(X,P)  % [F,R] = CRCBQCFITFUNC(X,P)
%returns the quadratic chirp coefficients corresponding to the rows of X in R.   % 返回X每一行对应的二次啁啾系数R
%
%[F,R,S] = CRCBQCFITFUNC(X,P)  % [F,R,S] = CRCBQCFITFUNC(X,P)
%Returns the quadratic chirp signals corresponding to the rows of X in S.  % 返回X每一行对应的二次啁啾信号S

%Soumya D. Mohanty  % Soumya D. Mohanty
%June, 2011  % 2011年6月
%April 2012: Modified to switch between standardized and real coordinates.  % 2012年4月：修改以支持标准化与实际坐标切换

%Shihan Weerathunga  % Shihan Weerathunga
%April 2012: Modified to add the function rastrigin.  % 2012年4月：添加rastrigin函数

%Soumya D. Mohanty  % Soumya D. Mohanty
%May 2018: Adapted from rastrigin function.  % 2018年5月：自rastrigin函数改编

%Soumya D. Mohanty  % Soumya D. Mohanty
%Adapted from QUADCHIRPFITFUNC  % 改编自QUADCHIRPFITFUNC
%==========================================================================

%rows: points
%columns: coordinates of a point
[nVecs,~]=size(xVec);

%storage for fitness values
fitVal = zeros(nVecs,1);

%Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
%Set fitness for invalid points to infty
fitVal(~validPts)=inf;
xVec(validPts,:) = s2rv(xVec(validPts,:),params);

for lpc = 1:nVecs
    if validPts(lpc)
    % Only the body of this block should be replaced for different fitness
    % functions
        x = xVec(lpc,:);
        fitVal(lpc) = ssrqc(x, params);
    end
end

%Return real coordinates if requested
if nargout > 1
    varargout{1}=xVec;
end

%Sum of squared residuals after maximizing over amplitude parameter
function ssrVal = ssrqc(x,params)
%Generate normalized quadratic chirp
phaseVec = x(1)*params.dataX + x(2)*params.dataXSq + x(3)*params.dataXCb;
qc = sin(2*pi*phaseVec);
qc = qc/norm(qc);

%Compute fitness
ssrVal = -(params.dataY*qc')^2;