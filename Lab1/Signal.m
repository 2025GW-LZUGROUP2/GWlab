classdef Signal
    properties
        name%信号名称，如'QuadraticChirp'
        timeVec%时间间隔序列，如0:0.1:1
        SigExpr%信号表达式，如A*sin(2*pi*(a_1*t + a_2*t^2 + a_3*t^3))
        FreqExpr%频率表达式，通过傅立叶变换求其频率
        coeffName
        coeffValue
        SigVec
    end
    methods
        function obj=Signal(name,timeVec,SigExpr,coeffNames,coeffValues)
            obj.name=name;
            obj.SigExpr=SigExpr;
            obj.coeffName=coeffNames;
            obj.coeffValue=coeffValues;
            obj.timeVec=timeVec;
            syms t;
            sym_val=[];
            for i=1:length(coeffNames)
                sym_val=[sym_val,sym(coeffNames{i})];
            end
            SigExpr_with_coeff=subs(SigExpr,sym_val,coeffValues);

            obj.SigVec=double(subs(SigExpr_with_coeff,t,timeVec));
        end
    end
end