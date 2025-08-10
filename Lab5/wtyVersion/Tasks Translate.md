# Tasks

## code needed

在SDMBIGDAT19/CODES中我们需要以下代码：
 r2ss.m：辅助函数；无需查看内部
 r2sv.m：辅助函数；无需查看内部
 s2rs.m：辅助函数；无需查看内部
 s2rv.m：辅助函数；无需查看内部
 crcbchkstdsrchrng.m：辅助函数；无需查看内部
 crcbpso.m：可应用于任何适应度函数的主PSO代码
 crcbpsotestfunc.m：一个基准适应度函数；也是如何编写与crcbpso.m配合使用的适应度函数的示例
 crcbqcfitfunc.m：用于二次啁啾GLRT（在白高斯噪声中）的适应度函数
 crcbqcpso.m：将PSO应用于二次啁啾适应度函数
 test_crcbpso.m：crcbpso.m的测试函数
 test_crcbqcpso.m：crcbqcpso.m的测试函数

## Task Set 1

- **目标**：修改你为生成指定信号所编写的函数，使其使用一个结构体（`struct`）作为输入参数来指定信号参数。
例如，若你的函数名为`foo(dataX, SNR, list_of_parameters)`，其中`list_of_parameters`要么是一个向量（如`SIGNALS/crcbgenqcsig.m`中那样），要么是一组输入参数，那么将参数封装在一个结构体（`P`）中传递：
  - 将`foo(dataX, SNR, list_of_parameters)`修改为`foo_new(dataX, SNR, P)`，其中`P`是一个结构体。
  - 例如，若你的参数为$a_1, a_2, a_3$，则结构体应为：
    - $P = \text{struct}('meaningful\_name\_of\_param1', a_1,'meaningful\_name\_of\_param2', a_2,...)$，其中你应使用能让代码读者了解参数性质的有意义的字段名。
你可查看`SDMBIGDAT19/CODES/s2rv.m`以了解如何将结构体传递给函数以及在函数内部如何使用它。
比较`foo_new`与`foo`在相同输入值下的输出，确保二者相同。
创建一个测试脚本以运行`foo_new`，该脚本需绘制（a）时间轴以秒为单位的信号时间序列图，以及（b）正频率的信号周期图（频率轴以赫兹为单位）。
