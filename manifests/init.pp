# Managed with puppet

class ssh::server {
    package { "openssh-server":
        ensure => installed
    }

    service { "sshd":
        ensure => running,
        enable => true,
        require => Package["openssh-server"]
    }

    file { "/etc/ssh/sshd_config":
        owner => "root",
        group => "root",
        mode => 600,
        replace => true,
        source => [
            "puppet://$server/private/ssh/$os/$osver/sshd_config",
            "puppet://$server/private/ssh/$os/sshd_config",
            "puppet://$server/private/ssh/sshd_config",
            "puppet://$server/ssh/$os/$osver/etc/ssh/sshd_config",
            "puppet://$server/ssh/$os/etc/ssh/sshd_config",
            "puppet://$server/ssh/etc/ssh/sshd_config"
        ],
        notify => Service["sshd"],
        require => Package["openssh-server"]
    }
}

class ssh::denyhosts inherits ssh::server {
    package { "denyhosts":
        ensure => installed
    }

    service { "denyhosts":
        enable => true,
        ensure => running,
        require => Package["denyhosts"]
    }

    file { "/etc/denyhosts.conf":
        owner => "root",
        group => "root",
        mode => 644,
        replace => true,
        source => [
            "puppet://$server/private/ssh/denyhosts.conf",
            "puppet://$server/ssh/denyhosts.conf"
        ]
    }
}