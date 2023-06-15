---
title: How to Design a Robust Airflow Pipeline
author: Jan Kislinger
date: May 26th 2020
---

--- 

## Description

Apache Airflow is a great tool for data processing and similar pipelines. But there are some
drawbacks and catches that can make it painful to work with. I want to talk about the mistakes we
made and how it led us to the design that we're currently using. I will also mention a few concepts
that we decided to use (protocol classes, dataclasses).

--- 

## Outline

1. What is Airflow and what is it good for

2. Bloated global scope
    - Explain briefly how Airflow scheduler works
    - Why it's good to move heavy imports elsewhere (e.g. pandas)
    - Where to work with airflow variables (and where to avoid them)

3. Dags are hard to test
    - Setting up environment locally is hard (if not impossible)
    - Unit tests with connections created deep in stack requires ugly mocking

4. Build layer between Airflow and own code
    - Move all custom code to separate modules
    - Create resources high in a stack (e.g. database connection, http hooks, ...)
    - Use dataclass (or similar) for parameter encapsulation

5. Testing and debugging made easy
    - Easy unit testing with resources using protocol classes
    - Python debug mode enable even with production data

---

# What is Airflow

---

```python
dag = DAG(
    dag_id="data_processing",
    schedule_interval=datetime.timedelta(hours=1),
)


def do_something_callable():
    """Implementation of 'doing something'."""


do_something = PythonOperator(
    task_id="do_something",
    python_callable=do_something_callable,
    dag=dag,
)
```

---

```python
with DAG(
    dag_id="data_processing",
    schedule_interval=datetime.timedelta(hours=1),
) as dag:
    @dag.task()
    def do_something_callable():
        """Implementation of 'doing something'."""
```

---
