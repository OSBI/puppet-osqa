class osqainit {

package { "libapache2-mod-wsgi":
            ensure => installed
        }


        add_user { osqa:
                email => "osqa@analytical-labs.com",
                uid => 5006
        }


            group { www-data:
                    gid     => 33,
                    require => user[osqa]
            }
file { "/home/osqa/osqa-server":
  ensure => directory,
  owner => "osqa",
  group => "osqa",
  mode => 0755,
  require => add_user[osqa],
}

  file { "/home/osqa/osqa-server/osqa.wsgi":
        owner   => osqa,
        group   => osqa,
        mode    => 775,
        source  => "puppet:///osqa/osqa.wsgi",
	require => file["/home/osqa/osqa-server"],
    }

        apache::vhost {"ask.analytical-labs.com":
                ensure => present,
                config_file => "puppet:///apache/askhttp.txt",
                notify => Service["apache2"],
        }


        mysql::rights{ "set osqa":
                ensure   => present,
                database => osqa,
                user     => osqa,
                password => QqabnJjnbo,
                require => Mysql::Database["osqa"],
        }

        mysql::database{"osqa":
                ensure   => present,
        }

package { "python":
            ensure => installed
        }


package { "python-mysqldb":
            ensure => installed
        }

package { "python-setuptools":
            ensure => installed
        }

}
