resource "tls_private_key" "etcd-ca" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "etcd-ca" {
  key_algorithm   = "${tls_private_key.etcd-ca.algorithm}"
  private_key_pem = "${tls_private_key.etcd-ca.private_key_pem}"

  subject {
    common_name  = "etcd-ca"
    organization = "etcd"
  }

  is_ca_certificate     = true
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

resource "tls_private_key" "etcd-server" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd-server" {
  key_algorithm   = "${tls_private_key.etcd-server.algorithm}"
  private_key_pem = "${tls_private_key.etcd-server.private_key_pem}"

  subject {
    common_name  = "etcd"
    organization = "etcd"
  }

  dns_names = ["k8s-node-2", "k8s-node-1", "k8s-master"]

  ip_addresses = ["192.168.1.100", "192.168.1.101", "192.168.1.102"]
}

resource "tls_locally_signed_cert" "etcd-server" {
  cert_request_pem      = "${tls_cert_request.etcd-server.cert_request_pem}"
  ca_key_algorithm      = "${tls_self_signed_cert.etcd-ca.key_algorithm}"
  ca_private_key_pem    = "${tls_private_key.etcd-ca.private_key_pem}"
  ca_cert_pem           = "${tls_self_signed_cert.etcd-ca.cert_pem}"
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "server_auth",
  ]
}

resource "tls_private_key" "etcd-client" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd-client" {
  key_algorithm   = "${tls_private_key.etcd-client.algorithm}"
  private_key_pem = "${tls_private_key.etcd-client.private_key_pem}"

  subject {
    common_name  = "etcd"
    organization = "etcd"
  }
}

resource "tls_locally_signed_cert" "etcd-client" {
  cert_request_pem      = "${tls_cert_request.etcd-client.cert_request_pem}"
  ca_key_algorithm      = "${tls_self_signed_cert.etcd-ca.key_algorithm}"
  ca_private_key_pem    = "${tls_private_key.etcd-ca.private_key_pem}"
  ca_cert_pem           = "${tls_self_signed_cert.etcd-ca.cert_pem}"
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "client_auth",
  ]
}

resource "tls_private_key" "etcd-peer" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "etcd-peer" {
  key_algorithm   = "${tls_private_key.etcd-peer.algorithm}"
  private_key_pem = "${tls_private_key.etcd-peer.private_key_pem}"

  subject {
    common_name  = "etcd"
    organization = "etcd"
  }

dns_names = ["k8s-node-2", "k8s-node-1", "k8s-master"]

ip_addresses = ["192.168.1.100", "192.168.1.101", "192.168.1.102"]
}

resource "tls_locally_signed_cert" "etcd-peer" {
  cert_request_pem      = "${tls_cert_request.etcd-peer.cert_request_pem}"
  ca_key_algorithm      = "${tls_self_signed_cert.etcd-ca.key_algorithm}"
  ca_private_key_pem    = "${tls_private_key.etcd-ca.private_key_pem}"
  ca_cert_pem           = "${tls_self_signed_cert.etcd-ca.cert_pem}"
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "etcd-ca-cert" {
  content  = "${tls_self_signed_cert.etcd-ca.cert_pem}"
  filename = "etcd-certs/etcd-client-ca.crt"
}

resource "local_file" "etcd-client-cert" {
  content  = "${tls_locally_signed_cert.etcd-client.cert_pem}"
  filename = "etcd-certs/etcd-client.crt"
}

resource "local_file" "etcd-client-key" {
  content  = "${tls_private_key.etcd-client.private_key_pem}"
  filename = "etcd-certs/etcd-client.key"
}

resource "local_file" "etcd-server-cert" {
  content  = "${tls_locally_signed_cert.etcd-server.cert_pem}"
  filename = "etcd-certs/etcd/server.crt"
}

resource "local_file" "etcd-server-key" {
  content  = "${tls_private_key.etcd-server.private_key_pem}"
  filename = "etcd-certs/etcd/server.key"
}

resource "local_file" "etcd-peer-cert" {
  content  = "${tls_locally_signed_cert.etcd-peer.cert_pem}"
  filename = "etcd-certs/etcd/peer.crt"
}

resource "local_file" "etcd-peer-key" {
  content  = "${tls_private_key.etcd-peer.private_key_pem}"
  filename = "etcd-certs/etcd/peer.key"
}