# Coevolutionary Multiobjective Particle Swarm Optimization (CMPSO) [1]

## Disclaimer:
This repository acts as an implementation of the authors' work in MATLAB.

## Introduction:

Inspired by Zhan et al., the CMPSO algorithm runs a regular particle swarm optimization scheme on multiple swarms (swarm size = number of objectives) and introduces an information sharing algorithm which places the non-dominated solutions in the ***Archive*** matrix in the code. 

Further information can be found in the reference paper.

## Table of Variables
| **Variable** | **Definition** | 
|----------|----------|
| var   | Number of optimization variables   | 
| varsize   | Row vector form of solution   | 
| swarms  | Number of objectives | 
| NA  | Max Archive size | 
| xmax  | Upper Limit of Search Space | 
| xmin  | Lower Limit of Search Space | 
| vlim  | Velocity Limit | 
| iterations  | Number of Iterations | 
| particles  | Number of Particles | 
| wmin  | Minimum Inertia | 
| wmax  | Maximum Inertia | 
| co1  | Personal Acceleration Coeff | 
| co2  | Social Acceleration Coeff | 
| co3  | Archive Acceleration Coeff | 
| particle  | Cell template of swarms | 
| GlobalBestEF  | Global Best Evaluation for Isolated Objectives | 
| GlobalBestPos  | Global Best Position for Isolated Objectives | 
| BestEF  | Best Evaluation at Each Iteration for Isolated Objectives | 
| Archive  | Pareto Set | 
| ArchEF  | Pareto Front | 
| BP  | Stores Best Positions across all swarms for the algorithm | 
| BP_EF  | Stores Best Positions' Evaluation across all swarms for the algorithm | 
| wasemptyArch | Checks if the Archive is empty |

## Table of Functions
| **Function** | **Definition** | 
|----------|----------|
| sat   | Limit a matrix of solutions to **upperlimit** and **lowerlimit** which must be row vectors   | 
| els   | Elitist Learning Strategy [1]   | 
| nondom_sol  | Extracts Non-dominated Solutions and their Positions | 
| dbs  | Density-Based Selection [1] |

## ***Evaluation Function***:
Line 32 of CMPSO.m must be set to the evaluation function, create a MATLAB function that takes in **positions** and **swarms** and returns an evaluation of said **positions**.
- **position**: matrix of input solutions (each row is a solution)

A *for* loop should be used to analyse the evaluation for each row of the **positions** input. 

## Example:

***cone_ef.m*** showcases the evaluation function for this example.

*Reference*: https://www.math.unipd.it/~marcuzzi/DIDATTICA/LEZ&ESE_PIAI_Matematica/3_cones.pdf

*Problem Statement*: 
- Input variables: radius and height of cone [r,h]
- Objectives: minimize Lateral Surface Area (S) and Total Area (T) [S,T]
- Constraint: Volume>200 cm^3

*Results*:

![Pareto Front](https://github.com/user-attachments/assets/4ab91ac0-647c-4d6f-9275-98811381e334)



## Reference:
[1] Multiple Populations for Multiple Objectives: A Coevolutionary Technique for Solving Multiobjective Optimization Problems (Zhi-Hui Zhan, Jingjing Li, Jiannong Cao, Jun Zhang, Henry Shu-Hung Chung and Yu-Hui Shi) 2013

