# gethfenni

This repo contains essential scripts to build up an Ethereum network using a Go Implementation (Geth.)

To create network

- Create bootnode - bootnode -genkey boot.key

- ./gennodekey (Number of nodes)

- Create your consensus algorithm using puppeth

- Init nodes

- Start bootnode

- Start all the nodes



For benchmarking

- ./read_throughput generate 2 txt with transaction per seconds (real means counting block lost too)

- ./metrics generate txt file with average latency of messages (in ms)

- ./propagation generate txt file with the total time of propagation of block from it's mined to the last node who receive the information about this blocks

-./congestioncontrol generate txt file where there is propagation time with a threshold. When a block overcome this threshold the packet should be discarded so it will be not counted on benchamark



Pay attention to fix paths on script
