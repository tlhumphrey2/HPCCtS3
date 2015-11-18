# Current Needs

Currently we need:

1. Test ECL programs that verify the correctness of the models created by these learning algorithms:

 - Decision Trees
 - Random Forest
 - SoftMax
 - Deep Learning
 - Neural Networks

2. Test ECL programs that verify the execution time of the learner on large training sets.


In the [ML.Tests.Benchmarks](https://github.com/hpcc-systems/ecl-ml/tree/master/ML/Tests/Benchmarks) folder, there are two examples of test ECL programs that verifies the correctness of the created model and two examples of test ECL programs that verifies the execution time of the learner on large training sets.

- Linear\_verify_model.ecl
- Logistic\_verify_model.ecl
- Linear\_runtime\_on\_large\_trainingset.ecl
- Logistic\_runtime\_on\_large\_trainingset.ecl


## Submissions

Submissions should be placed in the folder, [ML.Tests.Benchmarks](https://github.com/hpcc-systems/ecl-ml/tree/master/ML/Tests/Benchmarks). 

The name of any test ECL program for verifying a model's correctness should end with '\_verify\_model.ecl'. And, the name of any test ECL program for verifying the execution time of a learner on a large training set should end with '\_runtime\_on\_large\_trainingset.ecl'.

### Test ECL Program for Verifying Created Model's Correctness

The training set of this test ECL program should be small, no more than 25 observations, and should be inline.

Also, at the top of the test ECL program, in a comment block, should be an R program that executes an R equivalent learning algorithm on the same training set. There are examples in both Linear\_verify\_model.ecl and Logistic\_verify\_model.ecl. The R code should be setup in the comment block so one came cut and paste it into an R window to execute it. The following is the R code at the top of Linear\_verify\_model.ecl.

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

**NOTE.** It may be worthwhile to look-at and run **example ECL Programs** for the learning algorithms listed above. Some can be found in the folder, [ML.Tests.Explanatory](https://github.com/hpcc-systems/ecl-ml/tree/master/ML/Tests/Explanatory).

### Test ECL Program for Verifying Execution Time of a Large Training Set

