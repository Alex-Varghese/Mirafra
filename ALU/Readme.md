# ALU
# Introduction
The Arithmetic Logic Unit (ALU) is a fundamental building block of any digital processing system, responsible for performing a range of arithmetic and logical operations. This report presents the design and implementation of a parameterized ALU that supports both signed and unsigned operations for particular operations with some control features. The ALU design integrates arithmetic functions such as addition, subtraction, and increment/decrement operations, as well as logic functions including AND, OR, XOR, NOT, and their variants. Additionally, the design supports operations such as shift and rotate (both left and right), along with conditional comparisons and flag generation.  
The ALU is designed to be flexible and configurable through a clearly defined set of control and data input pins, allowing it to operate under different modes (arithmetic or logic) and command types. It includes an input validation mechanism, flag outputs (carry, overflow, error, greater-than, less-than, equal), and a timing control interface using clock, reset, and clock enable signals.  
# Objectives
- To design a parameterized N-bit Arithmetic Logic Unit (ALU) using Verilog that supports a wide range of arithmetic and logical operations.  
- To incorporate support for parameterized command sets, input/output widths, and operation modes (arithmetic or logic).  
- To validate the functionality of the ALU through comprehensive simulation using various input combinations and comparing the results against expected outputs.  
- To develop a synthesizable and reusable ALU design compliant with hardware design best practices.  



