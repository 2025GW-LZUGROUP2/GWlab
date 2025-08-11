
function [fitVal,varargout] = crcbpsotestfunc(xVec,params)
%A benchmark test function for CRCBPSO  % CRCBPSO 的基准测试函数
%F = CRCBPSOTESTFUNC(X,P)  % F = CRCBPSOTESTFUNC(X,P)
%Compute the Generalized Rastrigin fitness function for each row of X.  The fitness  % 计算X每一行的广义Rastrigin适应度函数，结果返回在F中
%values are returned in F. X is standardized, that is 0<=X(i,j)<=1. P has  % X是标准化的，即0<=X(i,j)<=1。P有两个数组P.rmin和P.rmax
%two arrays P.rmin and P.rmax that are used to convert X(i,j) internally to  % 用于将X(i,j)内部转换为实际坐标值
%actual coordinate values before computing fitness: X(:,j) ->  % 计算适应度前的实际坐标值：X(:,j) ->
%X(:,j)*(rmax(j)-rmin(j))+rmin(j).   % X(:,j)*(rmax(j)-rmin(j))+rmin(j)。
%
%For standardized coordinates, F = infty if a point X(i,:) falls  % 对于标准化坐标，如果X(i,:)落在超立方体外，则F=无穷大
%outside the hypercube defined by 0<=X(i,j)<=1.  % 超立方体由0<=X(i,j)<=1定义
%
%[F,R] =  CRCBPSOTESTFUNC(X,P)  % [F,R] =  CRCBPSOTESTFUNC(X,P)
%returns the real coordinates in R.   % 返回实际坐标R
%
%[F,R,Xp] = CRCBPSOTESTFUNC(X,P)  % [F,R,Xp] = CRCBPSOTESTFUNC(X,P)
%Returns the standardized coordinates in Xp. This option is to be used when  % 返回标准化坐标Xp。该选项用于有特殊边界条件（如角度坐标环绕）
%there are special boundary conditions (such as wrapping of angular  % 这些特殊边界条件更适合在适应度函数内部处理
%coordinates) that are better handled by the fitness function itself.  %

%Soumya D. Mohanty, Aug 2015  % Soumya D. Mohanty, 2015年8月
%Just a renamed version of the rastrigin benchmark function.  % 只是rastrigin基准函数的重命名版本

%Soumya D. Mohanty  % Soumya D. Mohanty
%June, 2011  % 2011年6月
%April 2012: Modified to switch between standardized and real coordinates.  % 2012年4月：修改以支持标准化与实际坐标切换

%Shihan Weerathunga  % Shihan Weerathunga
%April 2012: Modified to add the function rastrigin.  % 2012年4月：添加rastrigin函数

%Soumya D. Mohanty  % Soumya D. Mohanty
%May 2016: New optional output argument introduced in connection with  % 2016年5月：新增可选输出参数用于特殊边界条件处理
%handling of special boundary conditions.  %

%Soumya D. Mohanty  % Soumya D. Mohanty
%Dec 2017: Modified PTAPSOTESTFUNC (just renaming) for the LDAC school.  % 2017年12月：为LDAC学校重命名PTAPSOTESTFUNC

%Soumya D. Mohanty  % Soumya D. Mohanty
%Dec 2018: Changed name  % 2018年12月：更名
%==========================================================================

%rows: points
%columns: coordinates of a point
[nrows,~]=size(xVec);

%storage for fitness values
fitVal = zeros(nrows,1);
validPts = ones(nrows,1);

%Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
%Set fitness for invalid points to infty
fitVal(~validPts)=inf;
%Convert valid points to actual locations
xVec(validPts,:) = s2rv(xVec(validPts,:),params);


for lpc = 1:nrows
    if validPts(lpc)
    % Only the body of this block should be replaced for different fitness
    % functions
        x = xVec(lpc,:);
        fitVal(lpc) = sum(x.^2-10*cos(2*pi*x)+10);
    end
end

%Return real coordinates if requested
if nargout > 1
    varargout{1}=xVec;
    if nargout > 2
        varargout{2} = r2sv(xVec,params);
    end
end






