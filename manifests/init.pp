class hippie {
  service {
    "hippie":
      ensure => running,
      enable => true,
      hasrestart => true,
      hasstatus => true;
  }

  package {
    ["uuid-dev"]:
      ensure => installed;

    "zeromq":
      provider => dpkg,
      ensure => installed,
      require => [ Package["uuid-dev"], File["/home/eventd/zeromq_2.1.10-1_amd64.deb"] ],
      source => "/home/eventd/zeromq_2.1.10-1_amd64.deb";
  }
  
  user {
    "eventd":
      shell => "/bin/bash",
      uid => 2500,
      managehome => true;
  }

  file {
    "/home/eventd/zeromq_2.1.10-1_amd64.deb":
      require => User['eventd'],
      source => "puppet:///modules/hippie/zeromq_2.1.10-1_amd64.deb";

    "/home/eventd/hippie.psgi":
      owner => 'eventd',
      require => User['eventd'],
      content => template("hippie/hippie.psgi.erb");

    "/etc/init.d/hippie":
      source => "puppet:///modules/hippie/init",
      mode => 0755;
  }
}
