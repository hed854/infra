provider "google" {
	credentials = file("credentials.json")
	project = "udacity-kube"
	region = "europe-west1"
}


