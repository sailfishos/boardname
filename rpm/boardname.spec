Name:       boardname

Summary:    Board vendor/name/version detection tool
Version:    0.7
Release:    1
Group:      System/Base
License:    GPLv2
URL:        http://meego.gitorious.org/meego-os-base/boardname
Source0:    boardname-%{version}.tar.gz
Source1:    boardname.service
Requires:   coreutils
Requires:   grep
Requires:   systemd >= 185
Requires(preun): systemd
Requires(post): /sbin/ldconfig
Requires(post): systemd
Requires(postun): /sbin/ldconfig
Requires(postun): systemd

%description
This tool allows multiple applications to determine board/skew specific
hardware in a consisten manner. Applications that need some form of
method of determining a custom workaround within a set of hardware are
required to parse the output of boardname to determine appropriate
workaround. Vendors can force boardname override values at shipping.


%package devel
Summary:    Headers for boardname
Group:      Development/Libraries
Requires:   %{name} = %{version}-%{release}

%description devel
Development files for boardname


%prep
%setup -q -n %{name}-%{version}

%build
make %{?jobs:-j%jobs}

%install
rm -rf %{buildroot}
%make_install

mkdir -p %{buildroot}/%{_lib}/systemd/system/sysinit.target.wants
install -D -m 0644 %SOURCE1 ${RPM_BUILD_ROOT}/%{_lib}/systemd/system/
mkdir -p %{buildroot}/%{_lib}/systemd/system/sysinit.target.wants/
ln -s ../boardname.service %{buildroot}/%{_lib}/systemd/system/sysinit.target.wants/boardname.service
chmod +x %{buildroot}/%{_libdir}/*.so*


%preun
if [ "$1" -eq 0 ]; then
systemctl stop boardname.service || :
fi

%post
/sbin/ldconfig
systemctl daemon-reload || :
systemctl reload-or-try-restart boardname.service || :

%postun
/sbin/ldconfig
systemctl daemon-reload || :

%files
%defattr(-,root,root,-)
/sbin/boardname
%{_libdir}/libboardname.so.1
/%{_lib}/systemd/system/boardname.service
/%{_lib}/systemd/system/sysinit.target.wants/boardname.service

%files devel
%defattr(-,root,root,-)
%{_includedir}/boardname/boardname.h
%{_libdir}/libboardname.so
%{_libdir}/pkgconfig/boardname.pc

