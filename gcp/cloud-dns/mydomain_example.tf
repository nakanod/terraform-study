resource "google_dns_managed_zone" "mydomain" {
  name = "zone-mydomain"
  dns_name = "example.com."
  visibility = "public"
}

resource "google_dns_record_set" "a" {
  name = google_dns_managed_zone.mydomain.dns_name
  type = "A"
  ttl = 3600
  managed_zone = google_dns_managed_zone.mydomain.name
  rrdatas = ["192.0.2.10"]
}

resource "google_dns_record_set" "mx1-a" {
  name = "mx.${google_dns_managed_zone.mydomain.dns_name}"
  type = "A"
  ttl = 3600
  managed_zone = google_dns_managed_zone.mydomain.name
  rrdatas = ["192.0.2.11"]
}

resource "google_dns_record_set" "mx2-a" {
  name = "mx2.${google_dns_managed_zone.mydomain.dns_name}"
  type = "A"
  ttl = 3600
  managed_zone = google_dns_managed_zone.mydomain.name
  rrdatas = ["192.0.2.12"]
}

resource "google_dns_record_set" "mx" {
  name = google_dns_managed_zone.mydomain.dns_name
  type = "MX"
  ttl = 3600
  managed_zone = google_dns_managed_zone.mydomain.name
  rrdatas = [
    "10 mx.example.net.",
    "10 mx2.example.net.",
    "20 ${google_dns_record_set.mx1-a.name}",
    "20 ${google_dns_record_set.mx2-a.name}",
  ]
}

resource "google_dns_record_set" "txt" {
  name = google_dns_managed_zone.mydomain.dns_name
  type = "TXT"
  ttl = 3600
  managed_zone = google_dns_managed_zone.mydomain.name
  rrdatas = ["\"v=spf1 mx include:_spf.example.net ~all\""]
}

resource "google_dns_record_set" "caa" {
  name = google_dns_managed_zone.mydomain.dns_name
  type = "CAA"
  ttl = 3600
  managed_zone = google_dns_managed_zone.mydomain.name
  rrdatas = ["0 issue \"example.org\""]
}

resource "google_dns_record_set" "www" {
  name = "www.${google_dns_managed_zone.mydomain.dns_name}"
  type = "CNAME"
  ttl = 3600
  managed_zone = google_dns_managed_zone.mydomain.name
  rrdatas = ["${google_dns_managed_zone.mydomain.dns_name}"]
}
