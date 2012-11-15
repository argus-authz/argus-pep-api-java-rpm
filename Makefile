#
# Copyright (c) Members of the EGEE Collaboration. 2004-2010.
# See http://www.eu-egee.org/partners/ for details on the copyright holders. 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# RPM/ETICS
#
name = argus-pep-api-java
version = 2.2.0
release = 1

dist_url = http://github.com/downloads/argus-authz/$(name)/$(name)-$(version).tar.gz
spec_file = fedora/$(name).spec
rpmbuild_dir = $(CURDIR)/rpmbuild


all: srpm


clean:
	@echo "Cleaning..."
	rm -rf $(rpmbuild_dir) $(spec_file) *.rpm


spec:
	@echo "Setting version and release in spec file: $(version)-$(release)"
	sed -e 's#@@SPEC_VERSION@@#$(version)#g' -e 's#@@SPEC_RELEASE@@#$(release)#g' $(spec_file).in > $(spec_file)


pre_rpmbuild: spec
	@echo "Preparing for rpmbuild in $(rpmbuild_dir)"
	mkdir -p $(rpmbuild_dir)/BUILD $(rpmbuild_dir)/RPMS $(rpmbuild_dir)/SOURCES $(rpmbuild_dir)/SPECS $(rpmbuild_dir)/SRPMS
	test -f $(rpmbuild_dir)/SOURCES/$(name)-$(version).tar.gz || wget -P $(rpmbuild_dir)/SOURCES $(dist_url)


srpm: pre_rpmbuild
	@echo "Building SRPM in $(rpmbuild_dir)"
	rpmbuild --nodeps -v -bs $(spec_file) --define "_topdir $(rpmbuild_dir)"
	cp $(rpmbuild_dir)/SRPMS/*.src.rpm .


rpm: pre_rpmbuild
	@echo "Building RPM/SRPM in $(rpmbuild_dir)"
	rpmbuild --nodeps -v -ba $(spec_file) --define "_topdir $(rpmbuild_dir)"
	find $(rpmbuild_dir)/RPMS -name "*.rpm" -exec cp '{}' . \;
