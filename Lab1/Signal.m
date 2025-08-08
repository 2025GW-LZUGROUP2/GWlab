classdef Signal
    properties
        name%输入：信号名称，如'QuadraticChirp'
        timeVec%输入：时间间隔序列，如0:0.1:1
        SigExpr%输入：信号表达式，如A*sin(2*pi*(a_1*t + a_2*t^2 + a_3*t^3))
        indpVar%输入：信号的自变量，如t
        coeffName%输入：各个系数的名称（抽象符号），如{'a_1', 'a_2', 'a_3', 'A'}
        coeffValue%输入：各个系数的具体数值（此数值需要与抽象符号一一对应），如[1, 0.5, 0.1, 2]
        SigVec%输出：信号向量，由时间间隔向量和系数代入信号表达式得到
        SigExpr_with_coeff%输出：将将系数的具体数值代入后，只含
        % FreqExpr%输出：频率表达式，通过傅立叶变换求其频率
    end
    methods
        function obj=Signal(name,timeVec,SigExpr,indpVar,coeffNames,coeffValues)
            obj.name=name;
            obj.SigExpr=SigExpr;
            obj.indpVar=indpVar;
            obj.coeffName=coeffNames;
            obj.coeffValue=coeffValues;
            obj.timeVec=timeVec;
            obj=obj.updateOutputs();
        end
        function obj=set.name(obj,val)
            obj.name=val;
            obj=obj.updateOutputs();
        end
        function obj=set.timeVec(obj,val)
            obj.timeVec=val;
            obj=obj.updateOutputs();
        end
        function obj=set.SigExpr(obj,val)
            obj.SigExpr=val;
            obj=obj.updateOutputs();
        end
        function obj=set.indpVar(obj,val)
            obj.indpVar=val;
            obj=obj.updateOutputs();
        end
        function obj=set.coeffName(obj,val)
            obj.coeffName=val;
            obj=obj.updateOutputs();
        end
        function obj=set.coeffValue(obj,val)
            obj.coeffValue=val;
            obj=obj.updateOutputs();
        end


        function obj=updateOutputs(obj)
            if isempty(obj.SigExpr) || isempty(obj.indpVar) || isempty(obj.coeffName) || isempty(obj.coeffValue)
                obj.SigExpr_with_coeff = [];
                obj.SigVec = [];
                return;
            end
            sym_val=[];
            for i=1:length(obj.coeffName)
                sym_val=[sym_val,sym(obj.coeffName{i})];
            end
            obj.SigExpr_with_coeff=subs(obj.SigExpr,sym_val,obj.coeffValue);

            obj.SigVec=double(subs(obj.SigExpr_with_coeff,obj.indpVar,obj.timeVec));


        end
    end
end