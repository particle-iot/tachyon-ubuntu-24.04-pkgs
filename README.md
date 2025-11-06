# tachyon-ubuntu-24.04-pkgs

This repository contains the Debian packages (and supporting scripts) for the **Tachyon Ubuntu 24.04** base images. 

---

## Repository Overview

- **Purpose**:  
  To build, version, and release stable Debian packages for the Tachyon Ubuntu 24.04 environment.

- **Structure**:  

tachyon-ubuntu-24.04-pkgs/
├── android-platform-tools/
├── tachyon-firmware/
└── README.md

- **Key Files**:
  - `versions.json`: Tracks versions of package dependencies and build images.  
  - `tachyon-firmware/`: Firmware package containing versions and release control for BP images.  
  - `android-platform-tools/`: Android platform dependencies used by the base OS build process.  

---

## Build Instructions

1. **Install Dependencies**
   ```bash
   sudo apt update
   sudo apt install build-essential devscripts debhelper
   ```

	2.	Build All Packages

```
./scripts/build-all.sh
```


	3.	Generate Debian Packages

```
dpkg-buildpackage -us -uc
```


	4.	Validate the Build

Run lintian to verify correctness:

```
lintian ../*.deb
```

⸻

Update BP Images

To update the base platform (BP) images used in the Tachyon build system, follow these steps carefully:

1.	Edit the version.json file

- Open the versions.json file located inside the tachyon-firmware/ directory.
- Update the version string to the new build version.

2.	Submit a Pull Request

	•	Commit your change and open a pull request against the builder repository.
	•	The builder will automatically build and validate the new PR.

3.	Merge the Pull Request

- Once the PR passes validation, merge it into the main branch.
- This will automatically trigger a new build and produce a release tag incremented as 0.0.x.

4.	Create a Manual Tag
- After the auto-build completes, create a manual tag for the incremented version:

```
git tag v0.0.x
git push origin --tags
```

- This step triggers the repository again to regenerate the new stable Debian packages.

5.	Verify the Release

- Confirm that the new packages appear in the releases page.
- Ensure the generated Debian packages are marked as stable.
