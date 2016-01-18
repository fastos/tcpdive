%define kversion 2.6.32-431.17.1.el6

Name:		tcpdive-%{kversion}
Version:	1.0
Release:	stable
Summary:	A TCP performance profiling tool
Group:		System Environment/Kernel
License:	GPL
Source0:	%{name}-%{version}.tar.gz
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

Requires:	kernel = %{kversion} systemtap-runtime >= 2.3 

%description
A TCP performance profiling tool.

%prep

%setup -q

%build

%install
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/lib/modules/%{kversion}/kernel/net/ipv4
install -m 744 tcpdive %{buildroot}/usr/bin
install -m 744 tcpdive.ko %{buildroot}/lib/modules/%{kversion}/kernel/net/ipv4

%clean
rm -rf %{buildroot}

%files
/usr/bin/tcpdive
/lib/modules/%{kversion}/kernel/net/ipv4/tcpdive.ko
%defattr(-,root,root,-)
%doc

%changelog
* Thu Dec 31 2015 zhangsk <zhangskd@gmail.com>
- 1.0 First release


