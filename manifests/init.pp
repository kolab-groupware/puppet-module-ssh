# Managed with puppet

class ssh {
    @package { [
            "denyhosts",
            "openssh-clients",
            "openssh-server"
        ]:
        ensure => installed
    }

    @service { "sshd":
        ensure => running,
        enable => true,
        require => [
                File["/etc/ssh/sshd_config"],
                Package["openssh-server"]
            ]
    }

    @service { "denyhosts":
        enable => true,
        ensure => running,
        require => [
                File["/etc/denyhosts.conf"],
                Package["denyhosts"]
            ]
    }

    @file { "/etc/ssh/sshd_config":
        owner => "root",
        group => "root",
        mode => 600,
        replace => true,
        source => [
            "puppet://$server/private/$environment/ssh/$os/$osver/sshd_config.$hostname",
            "puppet://$server/private/$environment/ssh/$os/$osver/sshd_config",
            "puppet://$server/private/$environment/ssh/$os/sshd_config.$hostname",
            "puppet://$server/private/$environment/ssh/$os/sshd_config",
            "puppet://$server/private/$environment/ssh/sshd_config.$hostname",
            "puppet://$server/private/$environment/ssh/sshd_config",
            "puppet://$server/files/ssh/$os/$osver/sshd_config.$hostname",
            "puppet://$server/files/ssh/$os/$osver/sshd_config",
            "puppet://$server/files/ssh/$os/sshd_config.$hostname",
            "puppet://$server/files/ssh/$os/sshd_config",
            "puppet://$server/files/ssh/sshd_config.$hostname",
            "puppet://$server/files/ssh/sshd_config",
            "puppet://$server/ssh/$os/$osver/sshd_config.$hostname",
            "puppet://$server/ssh/$os/$osver/sshd_config",
            "puppet://$server/ssh/$os/sshd_config.$hostname",
            "puppet://$server/ssh/$os/sshd_config",
            "puppet://$server/ssh/sshd_config"
        ],
        notify => Service["sshd"],
        require => Package["openssh-server"]
    }

    @file { "/etc/denyhosts.conf":
        owner => "root",
        group => "root",
        mode => 644,
        replace => true,
        source => [
            "puppet://$server/private/$environment/ssh/denyhosts.conf",
            "puppet://$server/files/ssh/denyhosts.conf",
            "puppet://$server/ssh/denyhosts.conf"
        ]
    }

    class client inherits ssh {
        realize(Package["openssh-clients"])
    }

    class server inherits ssh {
        realize(Package["openssh-server"], Service["sshd"], File["/etc/ssh/sshd_config"])
    }

    class denyhosts inherits server {
        realize(Package["denyhosts"], Service["denyhosts"], File["/etc/denyhosts.conf"])
    }

    class rsakeys {
        case $sshrsakey {
            "": {
                err("No sshrsakey on $fqdn")
            }
            default: {
                @@sshkey { "$fqdn":
                    type => ssh-rsa,
                    host_aliases => "$hostname",
                    key => "$sshrsakey",
                    ensure => present,
                    tag => "ssh_key_$domain"
                }
            }
        }

        Sshkey <<| tag == "ssh_key_$domain" |>>
    }
}
