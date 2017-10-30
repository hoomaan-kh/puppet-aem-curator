class aem_curator::install_aem62_cfp3(
  $aem_id = 'aem',
) {

  aem_curator::install_aem_package { 'cq-6.2.0-hotfix-11490':
    group   => 'adobe/cq620/hotfix',
    version => '1.2',
    aem_id  => $aem_id,
  } -> aem_curator::install_aem_package { 'cq-6.2.0-hotfix-12785':
    group                       => 'adobe/cq620/hotfix',
    version                     => '7.0',
    restart                     => true,
    post_install_sleep_secs     => 150,
    post_login_page_ready_sleep => 30,
    aem_id                      => $aem_id,
  } -> aem_curator::install_aem_package { 'aem-service-pkg':
    file_name => 'AEM-6.2-Service-Pack-1-6.2.SP1.zip',
    group     => 'adobe/cq620/servicepack',
    version   => '6.2.SP1',
    aem_id    => $aem_id,
  } -> aem_curator::install_aem_package { 'cq-6.2.0-sp1-cfp':
    file_name               => 'AEM-6.2-SP1-CFP3-3.0.zip',
    group                   => 'adobe/cq620/cumulativefixpack',
    post_install_sleep_secs => 900,
    version                 => '3.0',
    aem_id                  => $aem_id,
  } -> aem_curator::install_aem_package { 'cq-6.2.0-hotfix-15607':
    group   => 'adobe/cq620/hotfix',
    version => '1.0',
    aem_id  => $aem_id,
  }

}