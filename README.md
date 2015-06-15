# Simple consumer and producer to play with RabbitMQ

## Quickstart

### Build consumer and procuder
```
make build
```

### Run consumer
```
make run-consumer host=somehost user=someuser path=somepath pass=somepass
```

### Run producer
```
while make -s run-producer host=somehost user=someuser path=somepath pass=somepass; do
  sleep 10m
done
```
