---
title: 'workflow-orchestration'
type: post
author: scottyob
date: 2022-10-05
categories:
 - programming


---

At Meta, we have a few internal workflow orchestration engines.  The idea is to allow long-running jobs, or things that can be split into tasks and need to have safe "checkpoints" behind them be defined in a system that can safely execute them and make sure they're executed in a durable, reliable and scalable way.

As I stumble upon things that fit paradigms within Facebook externally, this page is to document them.

## Core-Workflow-Services, Task-Oriented tools

These typically have the concept of a "worker" program to define the flow of the workflow, and distributed "workers" to execute the steps.

* [Amazon SWF](https://docs.aws.amazon.com/amazonswf/latest/developerguide/swf-welcome.html)
* [Azure Durable Functions](https://learn.microsoft.com/en-us/azure/azure-functions/durable/durable-functions-overview?tabs=csharp)
* [Uber Cadence](https://github.com/uber/cadence)
* [Temporal.io](https://temporal.io/)

## State machine driven approach

These differ from the above by having very fixed, simple states that we transition to.  Typically better to build a nicer UI, but less flexible unless creating complex states (sub-jobs, etc)

* [AWS Step Functions](https://aws.amazon.com/step-functions/)
* [Apache Airflow](https://airflow.apache.org/)