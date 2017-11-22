# Jupyter Scala Docker

Dockerfile with spark and jupyter instalation. It's the base for the [engine](https://github.com/src-d/engine) image.

## Build

```
docker build -t srcd/jupyter-spark .
```

## Run

```
docker run -it -p 8080:8080 srcd/jupyter-spark
```

