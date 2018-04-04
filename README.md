# Jupyter Spark Docker

Dockerfile with spark and jupyter instalation. It's the base for the [engine](https://github.com/src-d/engine) image.

It contains:

* Jupyter 5.2.1
* Spark 2.7.4
* Toree dev 0.2.0

## Build

```
docker build -t srcd/jupyter-spark .
```

## Run

```
docker run -it -p 8888:8888 srcd/jupyter-spark
```

Jupyter listens in port 8888. You'll have to use the token provided in the log file to access the service.

In case you want to change the configuration to listen in another port or skip token check you can create a configuration file. For example:

```dockerfile
RUN mkdir -p /root/.jupyter && \
    echo "c.NotebookApp.token = ''" > ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.notebook_dir = '/home'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.port = 8080" >> ~/.jupyter/jupyter_notebook_config.py
```

You can modify Spark options at runtime by setting the `SPARK_OPTS` environment variable. For example:

```
docker run -it -p 8888:8888 -e 'SPARK_OPTS=--driver-memory=8g' srcd/jupyter-spark
```
