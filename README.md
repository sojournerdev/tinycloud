# tinycloud

tinycloud uses the concepts of cloud-native platforms by building a Kubernetes platform around a custom operator. The goal is to self-serve higher-level primitives for CPU (e.g. apps) and GPU (e.g. agents, models, inferences) workloads, while abstracting away lower-level building blocks such as other CRDs and operators under the hood.

I started by attempting to build a homelab by deploying a cluster using K3s on a desktop I repurposed.
I did not enjoy having to use more than a few automation tools to get the job done. To me, it seems worth it
to deal with the complexity of the inner workings of controllers and CRDs so that, at the surface level,
you get a nice user interface.

## Current Status

This project is in early development.

## License

This project is licensed under the [MIT LICENSE](LICENSE).
