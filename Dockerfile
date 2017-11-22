FROM debian:stretch-slim

# Jupyter
RUN apt-get update && \
    apt-get -y install python3-pip && \
    pip3 --no-cache-dir install jupyter

# Spark
ARG APACHE_SPARK_VERSION=2.2.0
ARG HADOOP_VERSION=2.7
ENV SPARK_NAME=spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

ENV SPARK_DIR /opt/${SPARK_NAME}
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$SPARK_HOME/python/lib/pyspark.zip
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

RUN mkdir -p /usr/share/man/man1 && \
    apt-get install -y --no-install-recommends \
      openjdk-8-jre-headless \
      ca-certificates-java \
      curl && \
    apt-get clean && \
    curl http://d3kbcqa49mib13.cloudfront.net/${SPARK_NAME}.tgz | \
    tar xzf - -C /opt

# Standardize system
RUN ln -s $SPARK_DIR $SPARK_HOME && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    ln -s /usr/bin/python3 /usr/bin/python

# Disable jupyter token
RUN mkdir /root/.jupyter && \
    echo "c.NotebookApp.token = ''" > ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.notebook_dir = '/home'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.port = 8080" >> ~/.jupyter/jupyter_notebook_config.py

# Toree
RUN pip install --no-cache-dir https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz && \
    jupyter toree install --spark_home=/usr/local/spark

EXPOSE 8080

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--allow-root"]

