#
# init.pp
# 
# Copyright (c) 2011, OSBI Ltd. All rights reserved.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301  USA
#

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
