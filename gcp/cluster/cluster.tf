# https://www.terraform.io/docs/providers/google/d/google_container_cluster.html
# 
resource "google_container_cluster" "home-cluster" {
	name = "home-cluster"
	network = "default"
	location = "europe-west1-b"
	initial_node_count = 2
}

output "endpoint" {
	value = data.google_container_cluster.my_cluster.endpoint
}

// we need a way to output a kubeconfig to link Helm with its provider

