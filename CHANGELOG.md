## [0.6.0](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.5.2...v0.6.0) (2026-06-23)

### Features

* migrate to dt3-pipeline ([#54](https://github.com/zextras/carbonio-ws-collaboration-db/issues/54)) ([74ff8ca](https://github.com/zextras/carbonio-ws-collaboration-db/commit/74ff8ca3a64f9fcf5cf973f76e9467d994a3f4a7))

## [0.5.1](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.5.0...v0.5.1) (2026-06-08)

### Bug Fixes

* **ci:** build packages for all distros ([#68](https://github.com/zextras/carbonio-ws-collaboration-db/issues/68)) ([4487a38](https://github.com/zextras/carbonio-ws-collaboration-db/commit/4487a38843eed86a6ccc4fad98d4c97543834701))

## [0.5.0](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.4.1...v0.5.0) (2026-06-04)

### Features

* **ci:** [IN-951] add arm64 platform to db sidecar (no-QEMU psql/openssl cross-download) ([#62](https://github.com/zextras/carbonio-ws-collaboration-db/issues/62)) ([2818bfa](https://github.com/zextras/carbonio-ws-collaboration-db/commit/2818bfa9c7e98db2b3770b2008df86f015bdc64a))

## [0.4.1](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.4.0...v0.4.1) (2026-05-26)

### Bug Fixes

* use dt3-migration branch for jenkins-lib-common ([#61](https://github.com/zextras/carbonio-ws-collaboration-db/issues/61)) ([179ebdf](https://github.com/zextras/carbonio-ws-collaboration-db/commit/179ebdf0de1a55ec3ab21bf24f715b83e3e59d13))

<!--
SPDX-FileCopyrightText: 2026 Zextras <https://www.zextras.com>

SPDX-License-Identifier: AGPL-3.0-only
-->

## [0.4.0](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.3.1...v0.4.0) (2026-05-25)

### Features

* **packaging:** use arch=('any') for architecture-independent package ([#55](https://github.com/zextras/carbonio-ws-collaboration-db/issues/55)) ([8c21b7b](https://github.com/zextras/carbonio-ws-collaboration-db/commit/8c21b7b382c8cfb46c2480400c1884be818ea4bc))

### Bug Fixes

* **deps:** add explicit service-discover-base dependency ([#58](https://github.com/zextras/carbonio-ws-collaboration-db/issues/58)) ([b0ed6c6](https://github.com/zextras/carbonio-ws-collaboration-db/commit/b0ed6c6f0a78388eb0c00e64426959936ba18bce))
* **sidecar:** increase startup timeout for RHEL8 compatibility ([#57](https://github.com/zextras/carbonio-ws-collaboration-db/issues/57)) ([00c6178](https://github.com/zextras/carbonio-ws-collaboration-db/commit/00c6178f7859f8ae53145e1ee53bd9c399a47737))

## [0.3.1](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.3.0...v0.3.1) (2026-05-06)

### Bug Fixes

* restore buildPackages() to fix pkgrel on tag builds ([#51](https://github.com/zextras/carbonio-ws-collaboration-db/issues/51)) ([7e13bcd](https://github.com/zextras/carbonio-ws-collaboration-db/commit/7e13bcd633835d479a06f524ade5ab3a6e57916c))

## [0.3.0](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.2.6...v0.3.0) (2026-05-04)

### Features

* systemd hardening and service-discover.target orchestration ([#43](https://github.com/zextras/carbonio-ws-collaboration-db/issues/43)) ([b645a45](https://github.com/zextras/carbonio-ws-collaboration-db/commit/b645a45eda50e4e51ac4da1c330fd1322737c05e))

## [0.2.6](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.2.5...v0.2.6) (2026-02-23)

## [](https://github.com/zextras/carbonio-ws-collaboration-db/compare/v0.2.5...v) (2026-01-08)
## [0.2.5](https://github.com/zextras/carbonio-ws-collaboration-db/compare/0.2.2...v0.2.5) (2025-11-17)

### Features

* add ubuntu 24.04 (ubuntu-noble) support ([#17](https://github.com/zextras/carbonio-ws-collaboration-db/issues/17)) ([e64e8ec](https://github.com/zextras/carbonio-ws-collaboration-db/commit/e64e8ecc293963edcfd216f8a81fcc235215f5a8))

### Bug Fixes

* revert WantedBy for compatibility with older systems ([#20](https://github.com/zextras/carbonio-ws-collaboration-db/issues/20)) ([87e2853](https://github.com/zextras/carbonio-ws-collaboration-db/commit/87e2853b5c59d999b6c06547cd69c79fb1f84c12))
## [0.2.2](https://github.com/zextras/carbonio-ws-collaboration-db/compare/0.2.1...0.2.2) (2024-06-25)
## [0.2.1](https://github.com/zextras/carbonio-ws-collaboration-db/compare/0.2.0...0.2.1) (2024-03-13)
## [0.2.0](https://github.com/zextras/carbonio-ws-collaboration-db/compare/803cf00921b3780d7363f1902bf3e41e74f083d2...0.2.0) (2023-12-07)

### Features

* move to yap agent and add rhel9 support ([#10](https://github.com/zextras/carbonio-ws-collaboration-db/issues/10)) ([5fca73a](https://github.com/zextras/carbonio-ws-collaboration-db/commit/5fca73ad524839feef26dc3153ca539d35101431))
* WSC-1003 update pre-commit-config yaml ([#9](https://github.com/zextras/carbonio-ws-collaboration-db/issues/9)) ([eb1c130](https://github.com/zextras/carbonio-ws-collaboration-db/commit/eb1c130cc3a90347cc061251cc80c0cf71bed788))

### Bug Fixes

* [CHATS-544] Clean up consul hcl configuration file ([803cf00](https://github.com/zextras/carbonio-ws-collaboration-db/commit/803cf00921b3780d7363f1902bf3e41e74f083d2))
