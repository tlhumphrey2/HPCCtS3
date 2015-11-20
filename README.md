Beginner Contributor Guide
==========================

This document is for those who have never contributed to our Machine Learning (ML) Project and/or never contributed to any github project.

What we hope to cover, here, is everything you need to get started as a contributor. I believe the following list covers everything. By the way, you can use the order of this list to tell you when to do what.

 - Get a github account (click [here](#get-github-account) for instructions).
 - Download git onto your PC (click [here](#download-git) for instructions).
 - Setup git onto your PC (click [here](#setup-git) for instructions).
 - For the ML repository, make 1) a fork of it on github and 2) a local copy of it  (click [here](#fork-and-make-a-local-copy-of-the-ml-repository) for instructions).
 - Get access to our THOR cluster for contributors or download a VMWare HPCC System (click [here](#get-access-to-thor-cluster) for instructions).
 - Download ECL IDE (click [here](#download-ecl-ide) for instructions).
 - Configure ECL IDE so local ML repository is seen (click [here](#configure-ecl-ide-so-local-ml-repository-is-seen) for instructions).
 - Learn ECL (click [here](#configure-ecl-ide) for instructions).
 - Run some of the example ML programs (click [here](#run-example-ml-programs) for example).
 - Decide what contribution you want to make (look at our [Current Needs](https://github.com/hpcc-systems/ecl-ml/CONTRIBUTING/CurrentNeeds.md)).
 - Make a branch in your local ML repository for your contribution (click [here](#creating-a-branch) for instructions).
 - Make a contribution
 - Create a pull request (click [here](#create-pull-request) for instructions).

## Get Github Account

Click [here](https://github.com/join) to begin creating a github account.

## Download git

Click [here](https://desktop.github.com/) to download the latest version of Github Desktop.

## Setup git

This github article tells you what to do to setup git: [help.github.com/articles/set-up-git](https://help.github.com/articles/set-up-git/). You may have to scroll down to get to the section on Setting Up Git. There are 4 steps to this setup process.

## Fork and Make a Local Copy of the ML Repository

This github article tells you how to fork a repository and make a local copy of it: [help.github.com/articles/fork-a-repo](https://help.github.com/articles/fork-a-repo/).

There are 2 steps in the forking process under the header, **"Fork an example repository"**.

Also, this article tells you how to keep your fork updated with the ML repository, see **"Keep your fork synced"**.

For instructions for making a local copy of the ML repository (one that is on your PC), go to the section, **"Create a local clone of your fork"**. This local copy will be a copy of your fork.

## Get Access To THOR Cluster

**TBD**

## Download ECL IDE

Click [here](https://hpccsystems.com/download/developer-tools/ecl-ide) to download the latest version of ECL IDE.

## Configure ECL IDE so Local ML Repository is Seen

In Perferences, click on the Compiler tab. There are several text boxes. One is called "ECL Folders". Click on the "Add" button below it and, in the "Browse For Folder" popup dialog box, find the "ecl-ml" folder of your local ML repository. Then, click on the folder's name and then click "OK". The path to the "ecl-ml" folder should now be in the "ECL Folders" text box.

## Run Example ML Programs

Example ML programs can be found [here](https://github.com/tlhumphrey2/ecl-ml/tree/master/ML/Tests/Explanatory). Example programs for a particular learning algorithm, e.g. Logistic, will the name of the learning algorithm in its file name. For example, when I searched for example Logistic programs, I found 2 (LogisticRegressionStatistics.ecl and classify_logistic.ecl).

## Creating a Branch

A **branch** is like a total copy of your local the ML repository.

This github article gives general information about git branches and tells you how to create a branch and why (see [this](https://github.com/Kunena/Kunena-Forum/wiki/Create-a-new-branch-with-git-and-manage-branches)).

The following terms in this article probably need to be defined:

 - **master branch** refers to the main branch (or starting branch) of your local ML repository.
 - **origin** in a git command, like "git push" refers to your fork on github.
 - **original branch from official repository** for us that would be the original ML repository, which is [here](https://github.com/hpcc-systems/ecl-ml).

**Example of a branch:** Before you make any changes to your local ML repository, create a branch using git. For example the following git command creates a branch I will use to add to the Benchmark folder a test program for verifying the correctness of the DecisionTree learning algorithm.

<pre>
git checkout -b add-decisiontree-model-correctness
</pre>

## Create Pull Request

Once you have completed making changes to your branch, you must make us aware of these changes so we can critic them and give you feedback. The way you do that is by submitting a "pull request". 

But, before submitting a "pull request", there are other things you need to do, first. So, refer to [this document](https://github.com/hpcc-systems/HPCC-Platform/wiki/Git-step-by-step). This document gives a lot of detailed information. But, I want you to start reading at the section named **(1) Resync**. Here are the steps you want to do.

1. **Resync** your local ML repository using the 4 git commands in the article.
2. **Create a branch** using the article's instructions or those give [above](#creating-a-branch).
3. **Make your changes**. For the next step, staging, you need to know all the changes you have made. You can get a list of the changes you have made with the following git command "git status -s".
4. **Stage** the changes you have made using "git add" (see article).
5. **Commit staged changes** (see article).
6. **Push the committed changes** to your github fork (see article).
7. **Pull Request**. This is done on github. This github article gives general information about creating a pull request (see [this](https://help.github.com/articles/creating-a-pull-request)). (**Upstream** in this article refers to the original ML repository on github, i.e. [here](https://github.com/hpcc-systems/ecl-ml)).
