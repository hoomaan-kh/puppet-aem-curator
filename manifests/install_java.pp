# == Class: config::java
#
# Configuration AEM Java AMIs
#
# === Parameters
#
# [*cert_base_url*]
#   Base URL (supported by the puppet-archive module) to download the X.509
#   certificate and private key to be used with Apache.
#
# [*tmp_dir*]
#   A temporary directory used to store the X.509 certificate and private key
#   while building the PEM file for Apache.
#
# === Authors
#
# James Sinclair <james.sinclair@shinesolutions.com>
#
# === Copyright
#
# Copyright © 2017 Shine Solutions Group, unless otherwise noted.
#
class aem_curator::install_java (
  $cert_base_url,
  $tmp_dir,
  $jdk_base_url,
  $jdk_filename       = 'jdk-11.0.7_linux-x64_bin.rpm',
  $jdk_version        = '11.0.7',
) {


    class { 'oracle_java':
      download_url   => $jdk_base_url,
      filename       => $jdk_filename,
      # version        => "${jdk_version}u${jdk_version_update}",
      # build          => $jdk_version_build,
      # type           => 'jdk',
      # format         => $jdk_format,
      check_checksum => false,
    # Need to set alternative for java here due to oracle_java module's add alternative feature is broken in version 2.9.4
    }-> exec { "alternatives --set  java /usr/java/jdk-${jdk_version}/bin/java":
      path => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    } ->  wait_for { "60 seconds":
            seconds => 60,
      }
    #
    # java::download { 'jdk11' :
    #   ensure  => 'present',
    #   java_se => 'jdk',
    #   # url     => 's3://aem-opencloud/adobeaemcloud/jdk-11.0.7_linux-x64_bin.rpm',
    #   url     => "${jdk_base_url}/${jdk_filename}",
    # } ->  wait_for { "60 seconds":
    #         seconds => 60,
    #   }

  file { '/etc/ld.so.conf.d/99-libjvm.conf':
    ensure  => present,
    content => "/usr/java/latest/jre/lib/amd64/server\n",
    notify  => Exec['/sbin/ldconfig'],
  }

  exec { '/sbin/ldconfig':
    refreshonly => true,
  }

  file { "${tmp_dir}/java":
    ensure => directory,
    mode   => '0700',
  }


  [ 'cert' ].each |$idx, $part| {
    archive { "${tmp_dir}/aem.${part}":
      ensure  => present,
      source  => "${cert_base_url}/aem.${part}",
      require => [
        File["${tmp_dir}/java"],
        Wait_for["60 seconds"],
        ],
     } -> java_ks { "cqse-${idx}:/usr/java/jdk-${jdk_version}/lib/security/cacerts":

      ensure      => latest,
      certificate => "${tmp_dir}/aem.${part}",
      password    => 'changeit',
      path        => ['/bin','/usr/bin'],
    }
  }
  }
