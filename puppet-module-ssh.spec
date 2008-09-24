Name:		puppet-module-ssh
Summary:	Puppet module for ssh
Group:		Applications/System
Version:	0.0.1
Release:	1%{?dist}
License:	GPLv2+
URL:		http://puppetmanaged.org/
Source0:	http://puppetmanaged.org/releases/puppet-module-ssh-%{version}.tar.gz
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:	noarch

BuildRequires:	publican
Requires:	puppet-server

%description
Puppet module for managing ssh

%prep
%setup -q

%build
cd documentation
make html-single-en-US

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}
make install DESTDIR=%{buildroot}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%doc README
%dir /var/lib/puppet/modules/ssh
/var/lib/puppet/modules/ssh/*

%changelog
* Thu Sep 25 2008 Jeroen van Meeuwen <kanarip@kanarip.com> - 0.0.1-1
- First packaged version
