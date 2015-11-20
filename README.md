Current Needs
=============

What is covered here:

- [Our Current Needs](#our-current-needs)
- [Test ECL Programs for Verifying Model Correctness](#test-ecl-programs-for-verifying-model-correctness)
- [Test ECL Programs for Verifying Learner's Execution Time on Large Training Sets](#test-ecl-programs-for-verifying-learners-execution-time-on-large-training-sets)
- [Submission Requirements](#submission-requirements)
- [Other Useful Information for Submissions](#other-useful-information-for-submissions)

## Our Current Needs

Currently we need:

1\. Test ECL programs that verify the correctness of the models created by these learning algorithms:

 - Decision Trees
 - Random Forest
 - SoftMax
 - Deep Learning
 - Neural Networks

2\. Test ECL programs that verify the execution time of the learner on large training sets.

In the [ML.Tests.Benchmarks](https://github.com/hpcc-systems/ecl-ml/tree/master/ML/Tests/Benchmarks) folder, there are two examples of test ECL programs that verify the correctness of the created model and two examples of test ECL programs that verify the execution time of the learner on large training sets. The following are these test ECL programs:

- Linear\_verify_model.ecl
- Logistic\_verify_model.ecl
- Linear\_runtime\_on\_large\_trainingset.ecl
- Logistic\_runtime\_on\_large\_trainingset.ecl

**NOTE.** Documents that describe these ECL programs are in the folder, [Docs](https://github.com/hpcc-systems/ecl-ml/docs) (LinearRegressionIntroduction.htm and LogisticRegressionIntroduction.htm).

**NOTE.** If you have never contributed to our Machine Learning (ML) Project  then read [BeginnerContributorGuidelines.md](https://github.com/hpcc-systems/ecl-ml/CONTRIBUTING/BeginnerContributorGuidelines.md).

## Test ECL Programs for Verifying Model Correctness

This ECL program should compare the created model to that created by an R version of the same learning algorithm when both versions of the learning algorithm have the same training set.

The training set of this test ECL program should be small, no more than 25 observations, and should be inline.

Also, at the top of the test ECL program, in a comment block, should be the R program that executes the R equivalent learning algorithm on the same training set (See both Linear\_verify\_model.ecl and Logistic\_verify\_model.ecl for examples). 

The R code should be setup in the comment block so one can cut and paste it into an R window to execute it. The following is the R code at the top of Linear\_verify\_model.ecl.

<pre>
A <- matrix(c(1,0.13197,25.114,3,0.0,72.009,5,0.95613,71.9,7,0.57521,97.91,9,0.0,102.2,
11,0.23478,118.48,13,0.0,145.83,15,0.0,181.51,17,0.015403,197.38,19,0.0,214.03,
21,0.16899,216.61,23,0.64912,270.63,25,0.73172,281.17,27,0.64775,295.11,29,0.45092,314.04,
31,0.54701,331.86,33,0.29632,345.95,35,0.74469,385.31,37,0.18896,390.91,39,0.6868,423.49), nrow = 20, ncol = 3, byrow=TRUE);

Y <- A[, 3];
X1 <- A[, 1];
X2 <- A[, 2];
model <- lm(Y ~ 1 + X1 + X2);
summary(model)
</pre>

## Test ECL Programs for Verifying Learners Execution Time on Large Training Sets

This ECL program should execute the learning algorithm on a large training set and record the execution time in a comment block at the top of the ECL program (see Linear\_runtime\_on\_large\_trainingset.ecl and/or Logistic\_runtime\_on\_large\_trainingset.ecl for examples, in [ML.Tests.Benchmarks](https://github.com/hpcc-systems/ecl-ml/tree/master/ML/Tests/Benchmarks)).

Also, notice that these two test ECL programs use two different methods for obtaining a large training set. For Linear\_runtime\_on\_large\_trainingset.ecl, it uses the functions of the ML.Distribution (lines 15 through 22). And, the test ECL program, Logistic\_runtime\_on\_large\_trainingset.ecl, gets a large training set from one of the online machine learning repositories (read the documentation for these test ECL program for more information in the folder, [Docs](https://github.com/hpcc-systems/ecl-ml/docs) (LinearRegressionIntroduction.htm and LogisticRegressionIntroduction.htm).

**NOTE.** You can get more information about ML.Distribution in [MachineLearning.pdf](https://github.com/hpcc-systems/ecl-ml/docs/MachineLearning.pdf).

## Submission Requirements

Submissions should be placed in the folder, [ML.Tests.Benchmarks](https://github.com/hpcc-systems/ecl-ml/tree/master/ML/Tests/Benchmarks). 

The name of any test ECL program for verifying a model's correctness should end with "\_verify\_model.ecl". And, the name of any test ECL program for verifying the execution time of a learner on a large training set should end with "\_runtime\_on\_large\_trainingset.ecl".

For a model correctness test ECL program, place in a comment block at the top of the program, a small R program that executes R's version of the learning algorithm and outputs the model. You don't have to use R. We will accept other statistical languages. But we must be able to run your "other language" program.

## Other Useful Information for Submissions

The example programs given in the folder, [ML.Tests.Explanatory](https://github.com/hpcc-systems/ecl-ml/tree/master/ML/Tests/Explanatory), is a good place to start making a test ECL program that verifies the correctness of the created model for one of the target learning algorithms. All of the target learning algorithms have at least one example program in this folder.

Read the documentation, [LinearRegressionIntroduction.htm and LogisticRegressionIntroduction.htm](https://github.com/hpcc-systems/ecl-ml/tree/master/docs), for the Linear and Logistic test ECL programs in the Benchmarks folder.

**Getting execution times:** After you have ran a test ECL program, you can get execution times in ECL Watch by 1) clicking on your workunit's id,  then 2) click on the "Timers" tab, and then 3) scrolling to the end of the list of timings where you will see "Total cluster time", which is given in seconds.

**Answers to questions** related to HPCC Systems can often be found by doing a Google search that includes "site:hpccsystems.com" (without the quotes).

 
