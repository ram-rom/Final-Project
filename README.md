User Guide - Ram Rom Final Project (TEAM 2)

This document will serve as the definitive guide for team Ram Rom's project.
For those of you that have to review our team's (Team 2) project this document will
provide you with all information needed to test and run our project. This
documentation is broken down into the following sections.

1. Introduction
2. Ram Rom CLI
3. Project Workflow
4. Run File
5. Expected Results and Analysis


1. Introduction
--------------------
Branch prediction is one of several important pieces needed to execute what
is known as dynamic execution. The purpose of branch prediction is to enable
and improve the flow of instruction pipelining and to avoid idling in the CPU.
Branch prediction methods can be split into two separate groups: dynamic and
static. Static branch prediction methods are methods are those prediction
schemes that do not rely on dynamic branch history and are typically implemented
in compilers, while dynamic branch prediction methods are those that are typically
implemented in hardware, and rely both on the current branch instruction as well
as dynamic history execution. In our project we looked at implementing several
dynamic branch prediction algorithms in a hardware simulator known as SimpleScalar.
The algorithms we implemented are: 1) dynamic perceptrons and 2)gshare. Dynamic
perceptrons uses a table of perceptrons (table of weights) to train and
improve the speculative performance of the branch predictor. Weights are incremented
when the branch was taken and decremented otherwise. The branch is taken when the
dot product of the global history and the index perceptron is positive and not taken
otherwise. Gshare on the other hand uses a table of 2-bit saturation counters and
the indexed counter is incremented when a branch is taken and decremented otherwise.


2. Ram Rom CLI
--------------------
In building this project we implemented an easy-to-use command-line interface(CLI) that
can be used by the groups testing our project. The tool has the following commands:
    i) Install:                 Command to install Simple Scalar
    ii) Compile:                Command to compile Simple Scalar
    iii) Simple-Test:           Command to run a simple test
    iv) Plan:                   Command to run benchmarks based on a plan file
    v) Analyze:                 Command to collect statistics from plan runs
Here is a detailed description of each command and what it does.

i) Install
----------------------
The install command will allow you to install Simple Scalar. Before running any other
commands in the CLI you must run this command. To run this command you just need to type
the following in a bash shell when in the projects root.
    ./bin/ram-rom --install
It is possible that you will encounter an error stating that you are missing several Ruby
packages. If this is the case you can this command from the same shell:
    gem install pry
After running this command go back and run the original install command. There is no need
to run this command again after it runs successfully.

ii) Compile
----------------------
The compile command will allow you to compile simple scalar once you make any changes to
its source files. Examples to changes you will need to make to its source files include
changing the global history register size, changing the perceptron table size, and changing
the perceptron training threshold. To run this command you just need to type the following
in a bash shell when in the projects root.
   ./bin/ram-rom --compile
After running this command you should run simple-test(below) as a sanity check to make sure
that everything compiled correctly..

iii) Simple-Test
-----------------------
The simple-test command will allow you to run a simple test that checks whether Simple-Scalar
is working correctly or not. This test should be run every time after you run the compile command.
To run this command you just need to type the following in a bash shell when in the projects root.
   ./bin/ram-rom --simple-test
Optionally, you can add the name of a branch from <nottaken, taken, bimod, perceptron, gshare, random>
and it will use that specific branch predictor in running its tests. For example, if you wanted to use
perceptron in this command, you would run
   ./bin/ram-rom --simple-test perceptron

iv) Plan
----------------------
The plan command will allow you to run the full suite of benchmarks. In order to run this command you
must provide it a plan yaml file. We have provided a template file for those groups that are going to
be testing our software. You should only need to change the plan name, number of executions and the predictors
you would like to test. By default the plan file will run 10 executions of the full set of branch predictors.
This will take a really long time to run and it is not advised that you run the default plan file unless
you feel you must. To run this command you just need to type the following in a bash shell when in the projects
root.
   ./bin/ram-rom --plan plan.yml
After running the plan command you must run the below analyze command in order to accumulate all of the statistics
into easy-to-read csv files. Be advised that if you want to run multiple plans you will need to change the plan
name.

v) Analyze
----------------------
The analyze command should only be ran after you have ran the plan command. The analyze command will aggregate all
data currently in the plan folder(it can handle multiple plans) and will aggregate the results into an analyze folder.
This folder will have sub folders for each execution and nested sub folders for each predictor. The final sub folder
will contain csv files with the results of running plan. To run the analyze command you just need to type the following
in a bash shell when in the projects root.
   ./bin/ram-rom --analyze

3. Project Workflow
-----------------------
Here is a detailed description on how the workflow for our project works.

     Step 1: Run the Install command
     Step 2: Run the compile command
     Step 3: Run the simple-test command
     Step 4: Edit the plan.yml file to your specifications
       - Only edit the name, number of executions and the predictors you would like to test
     Step 5: Run the plan command with your edited plan.yml file as many times as necessary
       - Remember to change the name of the plan after each run
     Step 6: Run the analyze command
     Step 7: Evaluate the results in the analyze folder. 

These steps should be enough to fully evaluate our project. 

4. Run File
--------------------------
We have included a run file in the root directory that you can use to generate some sample results
for your analysis. It includes the following configurations for you to sample:
   1. Perceptron - Table size: 128 Global History size: 2
   2. Perceptron - Table size: 256 Global History size: 4
   3. Perceptron - Table size: 512 Global History size: 8
   4. GShare     - Table size: 2^2 Global History size: 2
   5. GShare     - Table size: 2^4 Global History size: 4
   6. GShare     - Table size: 2^8 Global History size: 8

5. Expected Results and Analysis
------------------------------------
After running the project workflow I am sure you are wondering what you are supposed to do now.
The key thing to do is to look at the csvs that are produced by the analyze command and see
how the different predictors compare. You will notice that the csvs only contain information
about the miss rate. The reason we chose to only look at the miss rate can best be explained by
looking at how the execution time of a program relates to the miss rate. We all know that
        Execution Time = Instruction Count * Clock Rate * CPI
In our case we are running the same benchmarks with the same simulator architecture each run,
and thus Instruction Count and Clock Rate are unchanged with each execution. Because of this
We can confidently say that Execution Time is directly related to CPI. But looking at CPI we know
       CPI = Ideal CPI + Miss Penalty * Miss Rate
Since we are using the same simulated architecture each run, we know that the Ideal CPI and
Miss Penalty will be the same with each execution. But that means that CPI is directly
related to miss rate, and by extension that Execution time is directly related to miss rate. That
is why we chose miss rate as our key indicator in this project. When you look at the csvs you
can determine performance by looking for the predictor with the lowest miss rate.
