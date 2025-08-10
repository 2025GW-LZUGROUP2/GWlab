% SIGNAL 信号类
%   用于描述和生成参数化数学信号，支持符号表达式、参数替换和信号向量生成。
%
%   用法：
%       obj = Signal(name, timeVec, SigExpr, indpVar, coeffNames, coeffValues)
%
%   输入属性（Input properties）：
%       name        (char/string)      - 信号名称，如 'QuadraticChirp'
%       timeVec     (double array)     - 时间向量，如 0:0.1:1
%       SigExpr     (sym)              - 信号表达式（符号表达式），如 A*sin(2*pi*(a_1*t + a_2*t^2 + a_3*t^3))
%       indpVar     (sym)              - 信号自变量，如 t
%       coeffName   (cellstr)          - 系数名称（符号名字符串元胞数组），如 {'a_1', 'a_2', 'a_3', 'A'}
%       coeffValue  (double array)     - 系数数值（与coeffName一一对应），如 [1, 0.5, 0.1, 2]
%
%   输出属性（Output properties）：
%       SigVec              (double array) - 信号数值向量，由时间向量和系数代入信号表达式得到
%       SigExpr_with_coeff  (sym)          - 代入系数后的信号表达式
%       FreqExpr            (sym)          - 频率表达式，通过傅立叶变换求其频率（预留）
%
%   主要方法：
%       updateOutputs       - 根据当前参数自动更新信号表达式和信号向量
%
%   示例：
%       syms t a_1 a_2 a_3 A;
%       expr = A*sin(2*pi*(a_1*t + a_2*t^2 + a_3*t^3));
%       s = Signal('QuadraticChirp', 0:0.01:1, expr, t, {'a_1','a_2','a_3','A'}, [1,0.5,0.1,2]);
%       plot(s.timeVec, s.SigVec);
%
%   作者：2025GW-LZUGROUP2
%   日期：2025-08-08
classdef Signal
    properties
        % 输入：信号名称，如 'QuadraticChirp' (char/string)
        name
        % 输入：时间向量，如 0:0.1:1 (double array)
        timeVec
        % 输入：信号符号表达式，如 A*sin(2*pi*(a_1*t + a_2*t^2 + a_3*t^3)) (sym)
        SigExpr
        % 输入：信号自变量，如 t (sym)
        indpVar
        % 输入：系数名称（符号名字符串元胞数组），如 {'a_1', 'a_2', 'a_3', 'A'} (cellstr)
        coeffName
        % 输入：系数数值，如 [1, 0.5, 0.1, 2] (double array)
        coeffValue
        % 输出：信号数值向量，由时间向量和系数代入信号表达式得到 (double array)
        SigVec
        % 输出：代入系数后的信号表达式 (sym)
        SigExpr_with_coeff
        % 输出：频率表达式，通过傅立叶变换求其频率（预留）(sym)
        FreqExpr
    end
    methods
        function obj=Signal(name,timeVec,SigExpr,indpVar,coeffNames,coeffValues)
            % 构造函数：初始化信号对象各属性
            obj.name=name;
            obj.SigExpr=SigExpr;
            obj.indpVar=indpVar;
            obj.coeffName=coeffNames;
            obj.coeffValue=coeffValues;
            obj.timeVec=timeVec;
            obj=obj.updateOutputs(); % 自动生成输出属性
        end
        function obj=set.name(obj,val)
            % 设置name属性时自动更新输出
            obj.name=val;
            obj=obj.updateOutputs();
        end
        function obj=set.timeVec(obj,val)
            % 设置timeVec属性时自动更新输出
            obj.timeVec=val;
            obj=obj.updateOutputs();
        end
        function obj=set.SigExpr(obj,val)
            % 设置SigExpr属性时自动更新输出
            obj.SigExpr=val;
            obj=obj.updateOutputs();
        end
        function obj=set.indpVar(obj,val)
            % 设置indpVar属性时自动更新输出
            obj.indpVar=val;
            obj=obj.updateOutputs();
        end
        function obj=set.coeffName(obj,val)
            % 设置coeffName属性时自动更新输出
            obj.coeffName=val;
            obj=obj.updateOutputs();
        end
        function obj=set.coeffValue(obj,val)
            % 设置coeffValue属性时自动更新输出
            obj.coeffValue=val;
            obj=obj.updateOutputs();
        end


        function obj=updateOutputs(obj)
            % 根据当前属性自动生成输出属性
            if isempty(obj.SigExpr) || isempty(obj.indpVar) || isempty(obj.coeffName) || isempty(obj.coeffValue)
                obj.SigExpr_with_coeff = [];
                obj.SigVec = [];
                return;
            end
            % 构造符号系数向量
            sym_val=[];
            for i=1:length(obj.coeffName)
                sym_val=[sym_val,sym(obj.coeffName{i})];
            end
            % 代入具体数值，得到具体表达式
            obj.SigExpr_with_coeff=subs(obj.SigExpr,sym_val,obj.coeffValue);

            % 计算信号数值向量
            obj.SigVec=double(subs(obj.SigExpr_with_coeff,obj.indpVar,obj.timeVec));
        end
    end
end