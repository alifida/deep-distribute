import os
import tensorflow as tf

os.environ["TF_CONFIG"] = json.dumps({
    "cluster": {
        "worker": ["192.168.100.10911:222222"],
        "ps": ["192.168.100.10911:2223222"]
    },
    "task": {"type": "ps", "index": 0}
})

def main():
    server = tf.distribute.Server(
        tf.train.ClusterSpec({
            "worker": ["192.168.100.10911:2222"],
            "ps": ["192.168.100.10911:2223"]
        }),
        job_name="ps",
        task_index=0,
        protocol="grpc"
    )
    server.join()

if __name__ == "__main__":
    main()
