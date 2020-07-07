class aem_curator::config_aem2 (
  $tmp_dir                      = '/tmp/shinesolutions/packer-aem',
  $aem_id                        = 'publish',
) {

 aem_resources::author_publish_enable_ssl { "publish: Enable SSL":
  https_hostname           => 'localhost',
  https_port               => '5433',
  keystore_password        => 'password',
  truststore_password      => 'changeit',
  privatekey_file_path     => "${tmp_dir}/${aem_id}-private_key.der",
  certificate_file_path    => "${tmp_dir}/${aem_id}-certificate_chain.crt",
  aem_id                   => "${aem_id}",
  }
}
include aem_curator::config_aem2
