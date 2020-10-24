output "Availability_Domains" {
  value = data.oci_identity_availability_domains.ADs
}

output "Images" {
  value = data.oci_core_images.oraclelinux.images
}

output "GeoserverImages" {
  value = data.oci_core_images.geoserver_image.images
}